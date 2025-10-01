#!/bin/bash

##############################################################################
# Security Scanning Script
#
# This script runs all security scans locally before committing code.
# It helps identify security vulnerabilities early in the development cycle.
#
# Usage: ./run-security-scans.sh [options]
#
# Options:
#   --quick     Run quick scans only (skip time-consuming scans)
#   --verbose   Show verbose output
#   --help      Display this help message
##############################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default options
QUICK_MODE=false
VERBOSE=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --quick)
            QUICK_MODE=true
            shift
            ;;
        --verbose)
            VERBOSE=true
            shift
            ;;
        --help)
            grep "^#" "$0" | grep -v "#!/bin/bash" | sed 's/^# //'
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help to see available options"
            exit 1
            ;;
    esac
done

# Function to print section headers
print_header() {
    echo ""
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""
}

# Function to print success messages
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

# Function to print warning messages
print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# Function to print error messages
print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Start timer
START_TIME=$(date +%s)

print_header "Starting Security Scans"

# Check prerequisites
print_header "Checking Prerequisites"

if [ ! -f "./gradlew" ]; then
    print_error "Gradle wrapper not found. Are you in the project root directory?"
    exit 1
fi
print_success "Gradle wrapper found"

# Make gradlew executable
chmod +x ./gradlew
print_success "Gradle wrapper is executable"

# Clean previous build artifacts
print_header "Cleaning Previous Build"
./gradlew clean
print_success "Build cleaned"

# Build the project
print_header "Building Project"
if [ "$VERBOSE" = true ]; then
    ./gradlew build -x test --info
else
    ./gradlew build -x test
fi
print_success "Project built successfully"

# Run OWASP Dependency-Check
print_header "Running OWASP Dependency-Check (SCA)"
print_warning "This may take a few minutes on first run..."

if [ "$VERBOSE" = true ]; then
    ./gradlew dependencyCheckAnalyze --info
else
    ./gradlew dependencyCheckAnalyze
fi

if [ $? -eq 0 ]; then
    print_success "OWASP Dependency-Check completed"
    if [ -f "build/reports/dependency-check/dependency-check-report.html" ]; then
        print_success "Report: build/reports/dependency-check/dependency-check-report.html"
    fi
else
    print_error "OWASP Dependency-Check found vulnerabilities (CVSS >= 7)"
    print_warning "Review the report: build/reports/dependency-check/dependency-check-report.html"
fi

# Run SpotBugs with FindSecBugs
print_header "Running SpotBugs with FindSecBugs (SAST)"

if [ "$VERBOSE" = true ]; then
    ./gradlew spotbugsMain spotbugsTest --info --continue
else
    ./gradlew spotbugsMain spotbugsTest --continue
fi

if [ $? -eq 0 ]; then
    print_success "SpotBugs analysis completed"
    if [ -f "build/reports/spotbugs/spotbugs.html" ]; then
        print_success "Report: build/reports/spotbugs/spotbugs.html"
    fi
else
    print_warning "SpotBugs found potential security issues"
    print_warning "Review the report: build/reports/spotbugs/spotbugs.html"
fi

# Run Trivy scans if available
if [ "$QUICK_MODE" = false ]; then
    if command_exists trivy; then
        print_header "Running Trivy Vulnerability Scanner"

        # Create reports directory
        mkdir -p build/reports

        # Trivy filesystem scan
        print_warning "Running Trivy filesystem scan..."
        trivy fs \
            --severity HIGH,CRITICAL \
            --format table \
            --exit-code 0 \
            .

        print_success "Trivy filesystem scan completed"

        # Trivy configuration scan
        print_warning "Running Trivy configuration scan..."
        trivy config \
            --severity HIGH,CRITICAL \
            --format table \
            --exit-code 0 \
            .

        print_success "Trivy configuration scan completed"
    else
        print_warning "Trivy not found. Install with: brew install trivy (macOS) or see https://aquasecurity.github.io/trivy/"
    fi
else
    print_warning "Skipping Trivy scans (quick mode enabled)"
fi

# Generate summary
print_header "Security Scan Summary"

echo "Reports generated:"
echo ""

if [ -f "build/reports/dependency-check/dependency-check-report.html" ]; then
    echo "  OWASP Dependency-Check:"
    echo "    - HTML: build/reports/dependency-check/dependency-check-report.html"
    echo "    - JSON: build/reports/dependency-check/dependency-check-report.json"
fi

if [ -f "build/reports/spotbugs/spotbugs.html" ]; then
    echo "  SpotBugs:"
    echo "    - HTML: build/reports/spotbugs/spotbugs.html"
    echo "    - XML: build/reports/spotbugs/spotbugs.xml"
    echo "    - SARIF: build/reports/spotbugs/spotbugs.sarif"
fi

echo ""

# Calculate duration
END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))
MINUTES=$((DURATION / 60))
SECONDS=$((DURATION % 60))

print_success "All security scans completed in ${MINUTES}m ${SECONDS}s"

echo ""
print_warning "Next steps:"
echo "  1. Review all security reports for vulnerabilities"
echo "  2. Address any HIGH or CRITICAL severity findings"
echo "  3. Update dependencies if vulnerabilities are found"
echo "  4. Run tests to ensure fixes don't break functionality"
echo ""

# Open reports in browser (macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    read -p "Open reports in browser? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        [ -f "build/reports/dependency-check/dependency-check-report.html" ] && open build/reports/dependency-check/dependency-check-report.html
        [ -f "build/reports/spotbugs/spotbugs.html" ] && open build/reports/spotbugs/spotbugs.html
    fi
fi

exit 0
