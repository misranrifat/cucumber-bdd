# Security Policy

## Security Scanning

This project implements comprehensive security scanning as part of the CI/CD pipeline to identify and address vulnerabilities early in the development lifecycle.

### Automated Security Scans

The following security scans run automatically on every push and pull request:

#### 1. Gradle Wrapper Validation
- Validates the integrity of the Gradle wrapper
- Ensures the wrapper has not been tampered with
- Prevents supply chain attacks via compromised build tools

#### 2. OWASP Dependency-Check (SCA)
- Scans all project dependencies for known vulnerabilities
- Checks against the National Vulnerability Database (NVD)
- Generates detailed reports in HTML, JSON, XML, and SARIF formats
- Fails build on vulnerabilities with CVSS score >= 7 (High/Critical)

**Reports Location:** `build/reports/dependency-check/`

#### 3. SpotBugs with FindSecBugs (SAST)
- Static analysis of Java bytecode
- Identifies potential security vulnerabilities and coding issues
- Includes FindSecBugs plugin for security-focused analysis
- Detects common security issues like SQL injection, XSS, weak crypto, etc.

**Reports Location:** `build/reports/spotbugs/`

#### 4. Trivy Vulnerability Scanner
- Multi-purpose scanner for vulnerabilities and misconfigurations
- Scans filesystem for vulnerabilities
- Scans configuration files for security issues
- Focuses on HIGH and CRITICAL severity findings

**Reports Location:** `build/reports/trivy-*.sarif`

### Running Security Scans Locally

You can run security scans locally before pushing code:

```bash
# Run all security scans
./gradlew clean build dependencyCheckAnalyze spotbugsMain spotbugsTest

# Run OWASP Dependency-Check only
./gradlew dependencyCheckAnalyze

# Run SpotBugs only
./gradlew spotbugsMain spotbugsTest

# Install and run Trivy locally
brew install trivy  # macOS
trivy fs --severity HIGH,CRITICAL .
```

### Viewing Security Reports

#### Local Reports
After running scans locally, view reports at:
- OWASP: `build/reports/dependency-check/dependency-check-report.html`
- SpotBugs: `build/reports/spotbugs/spotbugs.html`

#### GitHub Security Tab
Security findings are automatically uploaded to GitHub's Security tab (Code Scanning Alerts):
1. Navigate to the repository on GitHub
2. Click on the "Security" tab
3. Select "Code scanning alerts"
4. Review findings by severity, category, and tool

#### GitHub Actions Artifacts
All security reports are uploaded as artifacts in GitHub Actions:
1. Go to Actions tab in the repository
2. Select the workflow run
3. Download artifacts from the "Artifacts" section

### Security Scan Configuration

#### OWASP Dependency-Check Configuration
- **Configuration File:** `build.gradle` (dependencyCheck section)
- **Suppression File:** `config/dependency-check-suppressions.xml`
- **Fail Threshold:** CVSS >= 7
- **Cache Duration:** 4 hours

To suppress false positives, edit `config/dependency-check-suppressions.xml` and document the reason for suppression.

#### SpotBugs Configuration
- **Configuration File:** `build.gradle` (spotbugs section)
- **Exclusion File:** `config/spotbugs-exclude.xml`
- **Effort Level:** Maximum
- **Report Level:** Low (reports all findings)

To exclude false positives, edit `config/spotbugs-exclude.xml` and document the reason for exclusion.

### NVD API Key (Optional but Recommended)

To speed up OWASP Dependency-Check scans, obtain a free NVD API key:

1. Request an API key at: https://nvd.nist.gov/developers/request-an-api-key
2. Add it to your GitHub repository secrets:
   - Go to Settings > Secrets and variables > Actions
   - Create a new secret named `NVD_API_KEY`
   - Paste your API key as the value

3. For local development, set the environment variable:
   ```bash
   export NVD_API_KEY=your-api-key-here
   ./gradlew dependencyCheckAnalyze
   ```

### Security Workflow Schedule

The security scanning workflow runs:
- On every push to main branch
- On every pull request to main branch
- Daily at 2 AM UTC (scheduled scan)
- Manually via workflow dispatch

### Addressing Security Findings

When security vulnerabilities are identified:

1. **Review the Finding**
   - Check the severity (Critical, High, Medium, Low)
   - Understand the vulnerability details
   - Determine if it affects your application

2. **Remediate**
   - Update vulnerable dependencies to patched versions
   - Apply security patches
   - Refactor code to eliminate security issues

3. **Suppress False Positives**
   - Only suppress confirmed false positives
   - Document the reason in suppression files
   - Review suppressions regularly

4. **Track Progress**
   - Create GitHub issues for non-trivial security findings
   - Assign priorities based on severity and exploitability
   - Set target resolution dates

### Security Best Practices

- Keep dependencies up to date
- Review security scan results before merging PRs
- Never commit secrets or sensitive data
- Use environment variables for configuration
- Apply principle of least privilege
- Validate all inputs
- Use parameterized queries to prevent SQL injection
- Enable proper authentication and authorization

## Reporting Security Vulnerabilities

If you discover a security vulnerability in this project, please report it privately:

1. Do NOT create a public GitHub issue
2. Email the security team or repository maintainers
3. Include detailed information about the vulnerability
4. Allow time for the issue to be addressed before public disclosure

## Security Contacts

For security-related questions or concerns, please contact the project maintainers.

## Compliance

This security scanning implementation helps maintain compliance with:
- OWASP Top 10
- CWE (Common Weakness Enumeration)
- SANS Top 25
- PCI DSS (for applicable projects)
- SOC 2 requirements

## Additional Resources

- [OWASP Dependency-Check Documentation](https://jeremylong.github.io/DependencyCheck/)
- [SpotBugs Documentation](https://spotbugs.github.io/)
- [FindSecBugs Plugin](https://find-sec-bugs.github.io/)
- [Trivy Documentation](https://aquasecurity.github.io/trivy/)
- [GitHub Code Scanning](https://docs.github.com/en/code-security/code-scanning)
- [OWASP Secure Coding Practices](https://owasp.org/www-project-secure-coding-practices-quick-reference-guide/)
