# Security Scanning Setup Checklist

This checklist will help you verify and complete the security scanning setup for your Cucumber BDD project.

## Pre-Deployment Checklist

### 1. Local Verification

- [ ] Run security scans locally to verify setup
  ```bash
  ./run-security-scans.sh --quick
  ```

- [ ] Verify OWASP Dependency-Check runs successfully
  ```bash
  ./gradlew dependencyCheckAnalyze
  ```

- [ ] Verify SpotBugs runs successfully
  ```bash
  ./gradlew spotbugsMain spotbugsTest
  ```

- [ ] Review generated reports
  - [ ] `build/reports/dependency-check/dependency-check-report.html`
  - [ ] `build/reports/spotbugs/spotbugs.html`

### 2. Repository Configuration

- [ ] Verify all files are in repository
  - [ ] `.github/workflows/security-scan.yml`
  - [ ] `.github/workflows/regression.yml` (updated)
  - [ ] `.github/dependabot.yml`
  - [ ] `config/dependency-check-suppressions.xml`
  - [ ] `config/spotbugs-exclude.xml`
  - [ ] `run-security-scans.sh` (executable)
  - [ ] `SECURITY.md`
  - [ ] `docs/SECURITY_SCANNING.md`
  - [ ] `README.md` (updated)

- [ ] Verify `.gitignore` excludes security reports
  ```bash
  grep "build/reports/" .gitignore
  ```

### 3. GitHub Configuration

- [ ] Enable GitHub Security features
  - [ ] Go to Settings > Code security and analysis
  - [ ] Enable Dependabot alerts
  - [ ] Enable Dependabot security updates
  - [ ] Enable Secret scanning (if available)

- [ ] Configure branch protection (recommended)
  - [ ] Settings > Branches > Add rule for main
  - [ ] Require status checks to pass before merging
  - [ ] Select "Security Scanning" workflow
  - [ ] Require branches to be up to date

- [ ] Set up notifications
  - [ ] Settings > Notifications
  - [ ] Enable security alerts
  - [ ] Configure notification preferences

### 4. Optional but Recommended

- [ ] Obtain NVD API key for faster scans
  - [ ] Request key at: https://nvd.nist.gov/developers/request-an-api-key
  - [ ] Add to GitHub Secrets as `NVD_API_KEY`
    - [ ] Settings > Secrets and variables > Actions
    - [ ] New repository secret: `NVD_API_KEY`
  - [ ] For local use: `export NVD_API_KEY=your-key`

- [ ] Install Trivy locally for comprehensive scanning
  ```bash
  # macOS
  brew install trivy

  # Or follow: https://aquasecurity.github.io/trivy/
  ```

## Post-Deployment Verification

### 5. First CI/CD Run

- [ ] Commit and push all changes
  ```bash
  git add .
  git commit -m "Add comprehensive security scanning to CI/CD pipeline"
  git push origin main
  ```

- [ ] Monitor the security scan workflow
  - [ ] Go to Actions tab
  - [ ] Select "Security Scanning" workflow
  - [ ] Watch the workflow run to completion

- [ ] Verify all steps complete successfully
  - [ ] Gradle wrapper validation
  - [ ] OWASP Dependency-Check
  - [ ] SpotBugs analysis
  - [ ] Trivy scans
  - [ ] Report uploads

- [ ] Check for any failures or warnings
  - [ ] Review workflow logs
  - [ ] Address any high/critical findings

### 6. Verify GitHub Security Integration

- [ ] Check Security tab
  - [ ] Navigate to Security > Code scanning alerts
  - [ ] Verify SARIF results are uploaded
  - [ ] Review any security findings

- [ ] Check workflow artifacts
  - [ ] Actions > Workflow run > Artifacts
  - [ ] Download and review reports:
    - [ ] dependency-check-report
    - [ ] spotbugs-report
    - [ ] trivy-reports

- [ ] Verify Dependabot is active
  - [ ] Security > Dependabot alerts
  - [ ] Should see dependency scanning enabled

### 7. Test Security Gates

- [ ] Create a test PR with a known vulnerability
  - [ ] Add an old dependency version with known CVEs
  - [ ] Verify security scan runs on PR
  - [ ] Verify build fails if CVSS >= 7

- [ ] Test suppression mechanism
  - [ ] Add a suppression to `config/dependency-check-suppressions.xml`
  - [ ] Verify suppressed vulnerability doesn't fail build
  - [ ] Document the suppression reason

## Team Setup

### 8. Developer Onboarding

- [ ] Share security documentation with team
  - [ ] [SECURITY.md](SECURITY.md)
  - [ ] [docs/SECURITY_SCANNING.md](docs/SECURITY_SCANNING.md)

- [ ] Train team on security tools
  - [ ] How to run local scans
  - [ ] How to read security reports
  - [ ] How to address vulnerabilities

- [ ] Set expectations
  - [ ] All high/critical vulnerabilities must be fixed before merge
  - [ ] Review security scan results before merging PRs
  - [ ] Update dependencies regularly

### 9. Establish Processes

- [ ] Define security incident response process
  - [ ] Who to notify for critical vulnerabilities
  - [ ] Timeline for remediation by severity
  - [ ] Escalation procedures

- [ ] Schedule regular reviews
  - [ ] Weekly: Review Dependabot PRs
  - [ ] Monthly: Review suppression files
  - [ ] Quarterly: Review security tools and configurations

- [ ] Create security champions
  - [ ] Designate team member(s) responsible for security
  - [ ] Grant appropriate GitHub permissions
  - [ ] Provide security training resources

## Monitoring and Maintenance

### 10. Regular Monitoring

- [ ] Set up monitoring dashboard
  - [ ] Track open security alerts
  - [ ] Track time to remediation
  - [ ] Track dependency freshness

- [ ] Review security metrics weekly
  - [ ] Number of vulnerabilities by severity
  - [ ] Failed vs. successful scans
  - [ ] Dependency update frequency

### 11. Maintenance Tasks

- [ ] Monthly tasks
  - [ ] Review and update suppressions
  - [ ] Check for security tool updates
  - [ ] Review false positive rate
  - [ ] Update security documentation

- [ ] Quarterly tasks
  - [ ] Update security scanning tools
  - [ ] Review and adjust severity thresholds
  - [ ] Conduct security retrospective
  - [ ] Update team training

- [ ] Annual tasks
  - [ ] Comprehensive security audit
  - [ ] Update security policy
  - [ ] Review compliance requirements
  - [ ] Benchmark against industry standards

## Troubleshooting

### Common Issues

- [ ] If OWASP Dependency-Check is slow
  - [ ] Add NVD API key
  - [ ] Check network connectivity
  - [ ] Verify cache is working

- [ ] If SpotBugs reports too many issues
  - [ ] Review and adjust report level
  - [ ] Add appropriate exclusions
  - [ ] Focus on security-critical findings first

- [ ] If SARIF upload fails
  - [ ] Check workflow permissions
  - [ ] Verify SARIF file size < 10MB
  - [ ] Check GitHub Security features enabled

- [ ] If build fails unexpectedly
  - [ ] Review workflow logs
  - [ ] Check security scan output
  - [ ] Verify all configuration files present

## Success Criteria

Your security scanning implementation is successful when:

- [x] All security scanning tools are integrated
- [x] CI/CD pipeline runs security scans automatically
- [x] Security findings appear in GitHub Security tab
- [x] Build fails on high/critical vulnerabilities
- [x] Developers can run scans locally
- [x] Documentation is comprehensive and accessible
- [x] Team is trained on security tools
- [x] Regular monitoring and maintenance processes established

## Next Steps

After completing this checklist:

1. **Monitor for first security findings**
   - Review GitHub Security tab daily for first week
   - Address any high/critical findings promptly

2. **Optimize performance**
   - Add NVD API key if scans are slow
   - Adjust cache settings as needed
   - Fine-tune exclusions and suppressions

3. **Enhance over time**
   - Consider adding CodeQL analysis
   - Add container scanning if using Docker
   - Implement secret scanning
   - Generate SBOM (Software Bill of Materials)

4. **Measure and improve**
   - Track security metrics
   - Measure time to remediation
   - Gather team feedback
   - Iterate on processes

## Support Resources

- **Documentation**: See SECURITY.md and docs/SECURITY_SCANNING.md
- **Tool Documentation**:
  - [OWASP Dependency-Check](https://jeremylong.github.io/DependencyCheck/)
  - [SpotBugs](https://spotbugs.github.io/)
  - [FindSecBugs](https://find-sec-bugs.github.io/)
  - [Trivy](https://aquasecurity.github.io/trivy/)
- **GitHub Docs**: [Code Security](https://docs.github.com/en/code-security)

## Sign-off

- [ ] Security scanning implementation reviewed and approved
- [ ] All checklist items completed
- [ ] Team trained and ready
- [ ] Monitoring processes in place

**Implemented by**: _________________
**Date**: _________________
**Reviewed by**: _________________
**Date**: _________________

---

Congratulations! Your comprehensive security scanning pipeline is now active.
