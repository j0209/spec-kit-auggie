# AUGGIE Security Specification Command

## Purpose
Generate comprehensive security specifications for a project, covering both general security principles and project-specific security requirements.

## Command Usage
This command is invoked via `auggie-security-spec "project-name" "security-focus-area"`

## Security Specification Template

### Project Security Overview
**Project**: {PROJECT_NAME}
**Security Focus**: {SECURITY_FOCUS}
**Threat Model**: {THREAT_MODEL_LEVEL}
**Compliance Requirements**: {COMPLIANCE_REQUIREMENTS}

### Security Architecture

#### Authentication & Authorization
- **Authentication Method**: [OAuth 2.0/JWT/Session-based/Multi-factor]
- **Authorization Model**: [RBAC/ABAC/ACL]
- **Session Management**: [Token expiration, refresh strategy]
- **Password Policy**: [Complexity, rotation, storage]

#### Data Protection
- **Data Classification**: [Public/Internal/Confidential/Restricted]
- **Encryption at Rest**: [Algorithm, key management]
- **Encryption in Transit**: [TLS version, certificate management]
- **Data Retention**: [Retention periods, deletion policies]
- **PII Handling**: [Collection, processing, storage, deletion]

#### Infrastructure Security
- **Network Security**: [Firewalls, VPNs, network segmentation]
- **Container Security**: [Image scanning, runtime protection]
- **Cloud Security**: [IAM, resource isolation, monitoring]
- **Secrets Management**: [Key rotation, access controls]

#### Application Security
- **Input Validation**: [Sanitization, parameterized queries]
- **Output Encoding**: [XSS prevention, content security policy]
- **Error Handling**: [Information disclosure prevention]
- **Logging & Monitoring**: [Security events, anomaly detection]

### Threat Modeling

#### Assets to Protect
- **Data Assets**: [User data, business data, system data]
- **System Assets**: [Applications, databases, infrastructure]
- **Process Assets**: [Business processes, workflows]

#### Threat Actors
- **External Threats**: [Hackers, competitors, nation-states]
- **Internal Threats**: [Malicious insiders, negligent users]
- **Supply Chain**: [Third-party vendors, dependencies]

#### Attack Vectors
- **Web Application**: [OWASP Top 10 vulnerabilities]
- **API Security**: [Authentication bypass, injection attacks]
- **Infrastructure**: [Privilege escalation, lateral movement]
- **Social Engineering**: [Phishing, pretexting]

### Security Controls

#### Preventive Controls
- **Access Controls**: [Multi-factor authentication, least privilege]
- **Input Validation**: [Server-side validation, sanitization]
- **Secure Coding**: [Code review, static analysis]
- **Network Controls**: [Firewalls, intrusion prevention]

#### Detective Controls
- **Monitoring**: [Security information and event management]
- **Logging**: [Comprehensive audit trails]
- **Vulnerability Scanning**: [Regular security assessments]
- **Penetration Testing**: [Annual security testing]

#### Corrective Controls
- **Incident Response**: [Response procedures, communication plans]
- **Backup & Recovery**: [Data backup, disaster recovery]
- **Patch Management**: [Regular updates, vulnerability remediation]

### Compliance & Standards

#### Regulatory Requirements
- **GDPR**: [Data protection, privacy by design]
- **CCPA**: [Consumer privacy rights]
- **HIPAA**: [Healthcare data protection]
- **SOX**: [Financial controls and reporting]
- **PCI DSS**: [Payment card data protection]

#### Security Frameworks
- **NIST Cybersecurity Framework**: [Identify, Protect, Detect, Respond, Recover]
- **ISO 27001**: [Information security management system]
- **OWASP**: [Web application security guidelines]
- **CIS Controls**: [Critical security controls]

### Security Testing

#### Static Analysis
- **Code Review**: [Manual and automated code review]
- **SAST Tools**: [Static application security testing]
- **Dependency Scanning**: [Third-party vulnerability assessment]

#### Dynamic Analysis
- **DAST Tools**: [Dynamic application security testing]
- **Penetration Testing**: [Manual security testing]
- **Vulnerability Assessment**: [Infrastructure scanning]

#### Security Metrics
- **Vulnerability Metrics**: [Time to detection, time to remediation]
- **Incident Metrics**: [Mean time to detection, mean time to response]
- **Compliance Metrics**: [Audit findings, control effectiveness]

### Implementation Roadmap

#### Phase 1: Foundation (Weeks 1-2)
- [ ] Implement authentication and authorization
- [ ] Set up basic logging and monitoring
- [ ] Configure HTTPS and basic encryption
- [ ] Establish secure development practices

#### Phase 2: Hardening (Weeks 3-4)
- [ ] Implement comprehensive input validation
- [ ] Set up vulnerability scanning
- [ ] Configure security headers and CSP
- [ ] Establish incident response procedures

#### Phase 3: Advanced Security (Weeks 5-6)
- [ ] Implement advanced threat detection
- [ ] Set up security automation
- [ ] Conduct penetration testing
- [ ] Establish security metrics and reporting

### Security Checklist

#### Development Security
- [ ] Secure coding standards implemented
- [ ] Code review process includes security review
- [ ] Static analysis tools integrated into CI/CD
- [ ] Dependency vulnerability scanning enabled
- [ ] Security testing included in QA process

#### Deployment Security
- [ ] Infrastructure hardening completed
- [ ] Network segmentation implemented
- [ ] Monitoring and alerting configured
- [ ] Backup and recovery procedures tested
- [ ] Incident response plan documented

#### Operational Security
- [ ] Security awareness training completed
- [ ] Access controls regularly reviewed
- [ ] Vulnerability management process active
- [ ] Security metrics tracked and reported
- [ ] Compliance requirements met

### Risk Assessment

#### High Risk Items
- [List specific high-risk security concerns for this project]

#### Medium Risk Items
- [List medium-risk security concerns]

#### Low Risk Items
- [List low-risk security concerns]

### Security Documentation

#### Required Documents
- [ ] Security Architecture Document
- [ ] Threat Model Document
- [ ] Incident Response Plan
- [ ] Security Policies and Procedures
- [ ] Compliance Documentation

#### Training Materials
- [ ] Security Awareness Training
- [ ] Secure Coding Guidelines
- [ ] Incident Response Procedures
- [ ] Compliance Requirements Training

---

## AUGGIE Instructions

When generating this specification:

1. **Analyze Project Context**: Review the project's technology stack, data handling, and business requirements
2. **Assess Risk Level**: Determine appropriate security measures based on project complexity and data sensitivity
3. **Reference Standards**: Apply relevant security frameworks and compliance requirements
4. **Prioritize Controls**: Focus on the most critical security controls for the specific project
5. **Create Actionable Items**: Generate specific, testable security requirements
6. **Consider Implementation**: Ensure security measures are practical and implementable

### Context Integration
- Read project metadata from `.project-meta.json`
- Analyze existing specifications for security implications
- Reference context materials for compliance requirements
- Consider technology stack security characteristics

### Output Requirements
- Generate specific security requirements, not generic guidelines
- Include implementation details and acceptance criteria
- Provide risk-based prioritization
- Create measurable security objectives
- Include both technical and process controls

This specification should be comprehensive enough that development teams can implement security measures without additional interpretation.
