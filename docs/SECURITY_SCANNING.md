# Security Scanning Quick Reference Guide

## Overview

This document provides a quick reference for the security scanning implementation in the Cucumber BDD project.

## Security Tools Implemented

| Tool | Type | Purpose | Scan Target |
|------|------|---------|-------------|
| Gradle Wrapper Validation | Supply Chain | Validates wrapper integrity | Gradle wrapper files |
| OWASP Dependency-Check | SCA | Identifies vulnerable dependencies | JAR files, dependencies |
| SpotBugs + FindSecBugs | SAST | Static code analysis | Java bytecode |
| Trivy | Vulnerability Scanner | Multi-purpose security scanner | Filesystem, configs |

## Quick Commands

### Run All Security Scans Locally
```bash
./run-security-scans.sh
```

### Run Quick Scans (Skip Trivy)
```bash
./run-security-scans.sh --quick
```

### Run Individual Scans

#### OWASP Dependency-Check
```bash
./gradlew dependencyCheckAnalyze
```

#### SpotBugs
```bash
./gradlew spotbugsMain spotbugsTest
```

#### Clean + All Security Scans
```bash
./gradlew clean build dependencyCheckAnalyze spotbugsMain spotbugsTest
```

## CI/CD Workflows

### Security Scan Workflow
- **File:** `.github/workflows/security-scan.yml`
- **Triggers:** Push to main, PRs, daily at 2 AM UTC, manual
- **Duration:** ~10-30 minutes (first run slower due to NVD database download)
- **Artifacts:** All security reports uploaded for 30 days

### Regression Test Workflow
- **File:** `.github/workflows/regression.yml`
- **Includes:** Gradle wrapper validation
- **Duration:** ~5-10 minutes

## Configuration Files

| File | Purpose |
|------|---------|
| `build.gradle` | Security plugin configurations |
| `config/dependency-check-suppressions.xml` | OWASP false positive suppressions |
| `config/spotbugs-exclude.xml` | SpotBugs exclusion rules |
| `.github/dependabot.yml` | Automated dependency updates |
| `SECURITY.md` | Security policy and procedures |

## Report Locations

### Local Development
```
build/reports/
├── dependency-check/
│   ├── dependency-check-report.html    # Main OWASP report
│   ├── dependency-check-report.json    # JSON format
│   ├── dependency-check-report.xml     # XML format
│   └── dependency-check-report.sarif   # SARIF for GitHub
├── spotbugs/
│   ├── spotbugs.html                   # Main SpotBugs report
│   ├── spotbugs.xml                    # XML format
│   └── spotbugs.sarif                  # SARIF for GitHub
└── trivy-*.sarif                       # Trivy SARIF reports
```

### GitHub
- **Artifacts:** Actions > Workflow Run > Artifacts section
- **Security Tab:** Security > Code scanning alerts
- **SARIF Results:** Automatically uploaded to Security tab

## Severity Levels

| Severity | CVSS Score | Action Required |
|----------|------------|-----------------|
| Critical | 9.0-10.0 | Immediate fix required, blocks PR |
| High | 7.0-8.9 | Fix before merge, blocks build |
| Medium | 4.0-6.9 | Plan fix, doesn't block build |
| Low | 0.1-3.9 | Review and fix when convenient |

## Failure Thresholds

- **OWASP Dependency-Check:** Fails on CVSS >= 7 (High/Critical)
- **SpotBugs:** Fails on any security bugs found
- **Trivy:** Reports only, doesn't fail build

## Common Tasks

### Suppress False Positive (OWASP)

Edit `config/dependency-check-suppressions.xml`:
```xml
<suppress>
    <notes><![CDATA[
        Reason for suppression: This CVE doesn't apply to our usage
    ]]></notes>
    <packageUrl regex="true">^pkg:maven/group\.id/artifact\-id@.*$</packageUrl>
    <cve>CVE-2024-12345</cve>
</suppress>
```

### Exclude False Positive (SpotBugs)

Edit `config/spotbugs-exclude.xml`:
```xml
<Match>
    <Class name="com.example.MyClass" />
    <Bug pattern="SECURITY_BUG_PATTERN" />
</Match>
```

### Update Dependencies

1. **Check for updates:**
   ```bash
   ./gradlew dependencyUpdates
   ```

2. **Update in `build.gradle`**

3. **Run security scans:**
   ```bash
   ./run-security-scans.sh
   ```

4. **Run tests:**
   ```bash
   ./gradlew test
   ```

### Add NVD API Key (Faster Scans)

1. Get API key: https://nvd.nist.gov/developers/request-an-api-key

2. **For GitHub Actions:**
   - Settings > Secrets and variables > Actions
   - New secret: `NVD_API_KEY`

3. **For Local Development:**
   ```bash
   export NVD_API_KEY=your-api-key-here
   ./gradlew dependencyCheckAnalyze
   ```

## Workflow Permissions

The security workflows require these permissions:
```yaml
permissions:
  contents: read          # Read repository contents
  security-events: write  # Upload SARIF to Security tab
  actions: read          # Read workflow status
```

## Troubleshooting

### OWASP Dependency-Check is slow
- **Solution:** Add NVD API key (speeds up by 10-20x)
- **First Run:** Takes longer to download NVD database (~500MB)
- **Subsequent Runs:** Uses cached data (4-hour cache)

### SpotBugs reports too many issues
- **Solution:** Adjust `reportLevel` in `build.gradle`
  - `low` = all issues
  - `medium` = medium and high priority
  - `high` = high priority only

### Build fails on vulnerability in transitive dependency
- **Option 1:** Update parent dependency
- **Option 2:** Exclude vulnerable transitive dependency
- **Option 3:** Suppress if not applicable (document reason)

### Trivy not installed
```bash
# macOS
brew install trivy

# Linux (Debian/Ubuntu)
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo "deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update
sudo apt-get install trivy
```

## Best Practices

1. **Run scans before committing**
   ```bash
   ./run-security-scans.sh --quick
   ```

2. **Review security alerts promptly**
   - Check GitHub Security tab daily
   - Prioritize Critical/High severity

3. **Keep dependencies updated**
   - Review Dependabot PRs weekly
   - Merge security updates promptly

4. **Document suppressions**
   - Always add clear notes for suppressions
   - Review suppressions monthly
   - Remove outdated suppressions

5. **Test after security fixes**
   - Run full test suite
   - Verify functionality unchanged
   - Check for breaking changes

6. **Monitor trends**
   - Track vulnerability counts over time
   - Measure time to remediation
   - Review security metrics monthly

## Security Scan Schedule

| Trigger | Frequency | Purpose |
|---------|-----------|---------|
| Push to main | Every push | Verify main branch security |
| Pull Request | Every PR | Prevent vulnerable code merge |
| Scheduled | Daily at 2 AM UTC | Detect new vulnerabilities |
| Manual | On demand | Ad-hoc security review |

## Integration with Development Workflow

```
Developer Workflow:
1. Write code
2. Run quick security scan: ./run-security-scans.sh --quick
3. Fix any HIGH/CRITICAL issues
4. Commit and push
5. CI runs full security scan
6. Review GitHub Security tab
7. Address findings before merge
```

## Resources

- **OWASP Dependency-Check:** https://jeremylong.github.io/DependencyCheck/
- **SpotBugs:** https://spotbugs.github.io/
- **FindSecBugs:** https://find-sec-bugs.github.io/
- **Trivy:** https://aquasecurity.github.io/trivy/
- **NVD:** https://nvd.nist.gov/
- **CVE Details:** https://www.cvedetails.com/
- **CVSS Calculator:** https://www.first.org/cvss/calculator/3.1

## Support

For questions or issues with security scanning:
1. Review this documentation
2. Check SECURITY.md
3. Review tool-specific documentation
4. Contact security team or repository maintainers
