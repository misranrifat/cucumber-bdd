# Cucumber BDD Automated Testing Framework

Java-based BDD testing framework using Cucumber.

## Technologies

- Java 17
- Gradle 8.12
- Cucumber 7.15.0
- JUnit 4.13.2
- Hamcrest 2.2

## Project Structure

```
cucumber-bdd/
├── src/
│   ├── main/
│   │   └── java/
│   │       └── com/testing/calculator/
│   │           └── Calculator.java
│   └── test/
│       ├── java/
│       │   └── com/testing/
│       │       ├── runner/
│       │       │   └── TestRunner.java
│       │       └── steps/
│       │           └── CalculatorSteps.java
│       └── resources/
│           └── features/
│               ├── addition.feature
│               ├── subtraction.feature
│               ├── multiplication.feature
│               └── division.feature
├── build.gradle
├── settings.gradle
├── .gitignore
└── gradle/
    └── wrapper/
        └── gradle-wrapper.properties
```

## Running Tests

Run Cucumber tests:
```bash
./gradlew cucumber
```

Run tests with regression tag:
```bash
./gradlew cucumber -Dcucumber.filter.tags="@regression"
```

## Test Reports

After running tests, reports are generated in:
- HTML: `target/cucumber-reports/cucumber.html`
- JSON: `target/cucumber-reports/cucumber.json`

## Security Scanning

This project implements comprehensive security scanning in the CI/CD pipeline to identify vulnerabilities early.

### Security Tools

- **Gradle Wrapper Validation**: Validates wrapper integrity
- **OWASP Dependency-Check**: Scans dependencies for known vulnerabilities (SCA)
- **SpotBugs with FindSecBugs**: Static security analysis of Java code (SAST)
- **Trivy**: Multi-purpose vulnerability scanner
- **Dependabot**: Automated dependency updates

### Run Security Scans Locally

```bash
# Run all security scans
./run-security-scans.sh

# Run quick scans (skip Trivy)
./run-security-scans.sh --quick

# Run OWASP Dependency-Check only
./gradlew dependencyCheckAnalyze

# Run SpotBugs only
./gradlew spotbugsMain spotbugsTest
```

### Security Reports

After running security scans, reports are available at:
- OWASP Dependency-Check: `build/reports/dependency-check/dependency-check-report.html`
- SpotBugs: `build/reports/spotbugs/spotbugs.html`

### GitHub Security Integration

Security scan results are automatically:
- Uploaded as workflow artifacts (30-day retention)
- Published to GitHub Security tab (Code Scanning Alerts)
- Run on every push, PR, and daily at 2 AM UTC

### Documentation

- **Security Policy**: [SECURITY.md](SECURITY.md)
- **Security Scanning Guide**: [docs/SECURITY_SCANNING.md](docs/SECURITY_SCANNING.md)

For more information about security scanning, see the [Security Scanning Guide](docs/SECURITY_SCANNING.md).
