# AUGGIE Operations & Maintenance Specification Command

## Purpose
Generate comprehensive operations and maintenance specifications that ensure production systems can be effectively operated, maintained, and supported with proper incident response, backup procedures, and operational documentation.

## Command Usage
This command is invoked via `auggie-operations-spec "project-name" "operations-focus-area"`

## Operations Specification Template

### Project Operations Overview
**Project**: {PROJECT_NAME}
**Operations Focus**: {OPERATIONS_FOCUS}
**Support Model**: {SUPPORT_MODEL} (24/7/365, Business Hours, Community)
**SLA Requirements**: {SLA_REQUIREMENTS}
**Team Structure**: {TEAM_STRUCTURE}

### Incident Response

#### Incident Classification
```yaml
# Incident severity levels
severity_levels:
  P1_Critical:
    description: "Complete service outage or data loss"
    response_time: "15 minutes"
    resolution_time: "4 hours"
    escalation: "Immediate C-level notification"
    
  P2_High:
    description: "Major functionality impaired"
    response_time: "1 hour"
    resolution_time: "24 hours"
    escalation: "Management notification within 2 hours"
    
  P3_Medium:
    description: "Minor functionality issues"
    response_time: "4 hours"
    resolution_time: "72 hours"
    escalation: "Team lead notification"
    
  P4_Low:
    description: "Cosmetic issues or feature requests"
    response_time: "24 hours"
    resolution_time: "Next release cycle"
    escalation: "Standard workflow"
```

#### Incident Response Procedures
```markdown
# Incident Response Playbook

## Detection
1. **Automated Alerts**: Monitor alerts from monitoring systems
2. **User Reports**: Support tickets, social media, direct reports
3. **Health Checks**: Regular system health monitoring
4. **Third-Party Notifications**: External service status pages

## Response Process
1. **Acknowledge** (within SLA response time)
   - Acknowledge receipt of incident
   - Assign incident commander
   - Create incident channel/room
   
2. **Assess** (within 30 minutes)
   - Determine severity level
   - Identify affected systems/users
   - Estimate impact and scope
   
3. **Communicate** (ongoing)
   - Internal stakeholder notification
   - Customer communication via status page
   - Regular updates every 30 minutes for P1/P2
   
4. **Investigate** (parallel to communication)
   - Gather logs and metrics
   - Identify root cause
   - Document findings
   
5. **Resolve** (within SLA resolution time)
   - Implement fix or workaround
   - Verify resolution
   - Monitor for recurrence
   
6. **Post-Incident** (within 48 hours)
   - Conduct post-mortem review
   - Document lessons learned
   - Create action items for prevention
```

#### Escalation Matrix
```yaml
# On-call escalation procedures
escalation_matrix:
  primary_oncall:
    role: "Senior Engineer"
    response_time: "15 minutes"
    escalate_after: "30 minutes"
    
  secondary_oncall:
    role: "Team Lead"
    response_time: "30 minutes"
    escalate_after: "1 hour"
    
  management:
    role: "Engineering Manager"
    response_time: "1 hour"
    escalate_after: "2 hours"
    
  executive:
    role: "CTO/VP Engineering"
    response_time: "2 hours"
    conditions: ["P1 incidents", "Data breach", "Security incident"]
```

### Backup & Recovery

#### Backup Strategy
```bash
#!/bin/bash
# Comprehensive backup procedures

# Database backups
backup_database() {
    local backup_type=$1  # full, incremental, differential
    local retention_days=$2
    
    case $backup_type in
        "full")
            pg_dump $DATABASE_URL | gzip > "/backups/full_$(date +%Y%m%d_%H%M%S).sql.gz"
            ;;
        "incremental")
            pg_dump --incremental $DATABASE_URL | gzip > "/backups/inc_$(date +%Y%m%d_%H%M%S).sql.gz"
            ;;
    esac
    
    # Upload to cloud storage
    aws s3 sync /backups/ s3://backups/{PROJECT_NAME}/database/
    
    # Cleanup old backups
    find /backups -name "*.sql.gz" -mtime +$retention_days -delete
}

# Application data backups
backup_application_data() {
    # User uploads
    aws s3 sync /app/uploads/ s3://backups/{PROJECT_NAME}/uploads/
    
    # Configuration files
    tar -czf "/backups/config_$(date +%Y%m%d).tar.gz" /app/config/
    
    # Logs (last 30 days)
    find /var/log -name "*.log" -mtime -30 | tar -czf "/backups/logs_$(date +%Y%m%d).tar.gz" -T -
}

# Backup schedule
# Full backup: Daily at 2 AM
# Incremental backup: Every 4 hours
# Application data: Daily at 3 AM
```

#### Recovery Procedures
```yaml
# Recovery Time Objectives (RTO) and Recovery Point Objectives (RPO)
recovery_objectives:
  database:
    rto: "4 hours"      # Maximum downtime
    rpo: "1 hour"       # Maximum data loss
    procedure: |
      1. Identify latest valid backup
      2. Restore database from backup
      3. Apply transaction logs if available
      4. Verify data integrity
      5. Update application configuration
      6. Restart services
      
  application:
    rto: "30 minutes"
    rpo: "15 minutes"
    procedure: |
      1. Deploy previous known-good version
      2. Update load balancer configuration
      3. Verify health checks pass
      4. Monitor error rates
      
  infrastructure:
    rto: "2 hours"
    rpo: "5 minutes"
    procedure: |
      1. Provision new infrastructure
      2. Deploy application from artifacts
      3. Restore data from backups
      4. Update DNS records
      5. Verify full functionality
```

### Maintenance Procedures

#### Scheduled Maintenance
```yaml
# Maintenance windows and procedures
maintenance_windows:
  weekly:
    schedule: "Sunday 2:00 AM - 4:00 AM UTC"
    activities:
      - Security updates
      - Minor version updates
      - Database maintenance
      - Log rotation
      
  monthly:
    schedule: "First Sunday 1:00 AM - 6:00 AM UTC"
    activities:
      - Major version updates
      - Infrastructure updates
      - Performance optimization
      - Capacity planning review
      
  quarterly:
    schedule: "Scheduled with 2 weeks notice"
    activities:
      - Major infrastructure changes
      - Database migrations
      - Security audits
      - Disaster recovery testing
```

#### Maintenance Checklist
```markdown
# Pre-Maintenance Checklist
- [ ] Notify stakeholders 48 hours in advance
- [ ] Create maintenance branch/environment
- [ ] Test changes in staging environment
- [ ] Prepare rollback procedures
- [ ] Verify backup completion
- [ ] Update status page
- [ ] Coordinate with on-call team

# During Maintenance
- [ ] Execute maintenance window notification
- [ ] Follow documented procedures step-by-step
- [ ] Monitor system metrics continuously
- [ ] Document any deviations or issues
- [ ] Verify functionality after each step
- [ ] Update status page with progress

# Post-Maintenance Checklist
- [ ] Verify all systems operational
- [ ] Run smoke tests
- [ ] Monitor error rates for 2 hours
- [ ] Update documentation
- [ ] Close maintenance window
- [ ] Conduct post-maintenance review
```

### Support Documentation

#### Runbooks
```markdown
# Common Operations Runbooks

## Database Connection Issues
**Symptoms**: Connection timeouts, "too many connections" errors
**Investigation**:
1. Check connection pool metrics
2. Review database logs
3. Verify database server resources
**Resolution**:
1. Restart connection pool if needed
2. Scale database resources
3. Optimize long-running queries

## High Memory Usage
**Symptoms**: OOM kills, slow response times
**Investigation**:
1. Check memory usage metrics
2. Analyze heap dumps
3. Review memory-intensive operations
**Resolution**:
1. Restart affected services
2. Scale resources vertically
3. Optimize memory usage

## SSL Certificate Expiration
**Symptoms**: SSL warnings, connection failures
**Investigation**:
1. Check certificate expiration dates
2. Verify certificate chain
**Resolution**:
1. Renew certificates
2. Update certificate stores
3. Verify SSL configuration
```

#### Troubleshooting Guides
```markdown
# Troubleshooting Decision Tree

## Service Unavailable (5xx Errors)
1. **Check Load Balancer**
   - Are backend servers healthy?
   - Is traffic being routed correctly?
   
2. **Check Application Servers**
   - Are processes running?
   - Check resource utilization
   - Review application logs
   
3. **Check Database**
   - Is database accessible?
   - Check connection limits
   - Review slow query log
   
4. **Check External Dependencies**
   - Are third-party services available?
   - Check API rate limits
   - Verify network connectivity

## Performance Issues
1. **Identify Bottleneck**
   - CPU, Memory, Disk, Network?
   - Database queries?
   - External API calls?
   
2. **Gather Metrics**
   - Application performance metrics
   - Infrastructure metrics
   - User experience metrics
   
3. **Implement Quick Fixes**
   - Scale resources if needed
   - Enable caching
   - Optimize queries
   
4. **Plan Long-term Solutions**
   - Code optimization
   - Architecture improvements
   - Capacity planning
```

### Monitoring & Alerting Integration

#### Operational Metrics
```yaml
# Key operational metrics to monitor
operational_metrics:
  availability:
    - uptime_percentage
    - error_rate
    - response_time_p95
    
  performance:
    - throughput_requests_per_second
    - database_query_time
    - cache_hit_ratio
    
  capacity:
    - cpu_utilization
    - memory_utilization
    - disk_usage
    - connection_pool_usage
    
  business:
    - active_users
    - transaction_volume
    - revenue_impact
```

#### Alert Runbooks
```markdown
# Alert Response Procedures

## High Error Rate Alert
**Threshold**: Error rate > 5% for 5 minutes
**Response**:
1. Check recent deployments
2. Review error logs for patterns
3. Verify external service status
4. Consider rollback if deployment-related

## Database Connection Pool Exhausted
**Threshold**: Available connections < 10%
**Response**:
1. Identify long-running transactions
2. Check for connection leaks
3. Scale connection pool if needed
4. Optimize query performance

## Disk Space Low
**Threshold**: Disk usage > 85%
**Response**:
1. Identify large files/directories
2. Clean up logs and temporary files
3. Archive old data
4. Scale storage if needed
```

### Change Management

#### Change Control Process
```yaml
# Change management workflow
change_types:
  emergency:
    approval: "Incident Commander"
    documentation: "Post-change"
    testing: "Production verification"
    
  standard:
    approval: "Team Lead + Peer Review"
    documentation: "Pre-change"
    testing: "Staging environment"
    
  major:
    approval: "Change Advisory Board"
    documentation: "Comprehensive"
    testing: "Full test suite + UAT"
```

#### Deployment Procedures
```markdown
# Deployment Checklist

## Pre-Deployment
- [ ] Code review completed
- [ ] All tests passing
- [ ] Security scan completed
- [ ] Performance testing completed
- [ ] Rollback plan prepared
- [ ] Stakeholders notified

## Deployment
- [ ] Deploy to staging first
- [ ] Verify staging functionality
- [ ] Deploy to production
- [ ] Monitor metrics during deployment
- [ ] Verify production functionality
- [ ] Update documentation

## Post-Deployment
- [ ] Monitor for 2 hours
- [ ] Verify key metrics
- [ ] Check error rates
- [ ] Confirm user feedback
- [ ] Document any issues
- [ ] Update change log
```

---

## AUGGIE Instructions

When generating this specification:

1. **Analyze System Requirements**: Review all specifications for operational needs
2. **Plan Comprehensive Coverage**: Include incident response, maintenance, and support procedures
3. **Define Clear Procedures**: Create step-by-step operational procedures
4. **Establish SLAs**: Define service level agreements and response times
5. **Create Runbooks**: Develop troubleshooting guides and operational runbooks
6. **Plan for Scale**: Ensure operations can scale with the system
7. **Integrate with Monitoring**: Connect operational procedures with monitoring and alerting

### Context Integration
- Analyze infrastructure requirements for operational procedures
- Consider monitoring requirements for incident response
- Plan maintenance procedures based on system architecture
- Integrate with security requirements for incident handling

### Output Requirements
- Complete incident response procedures with escalation matrix
- Comprehensive backup and recovery procedures
- Detailed maintenance schedules and procedures
- Operational runbooks and troubleshooting guides
- Change management and deployment procedures
- Support documentation and knowledge base

This specification ensures the project can be effectively operated and maintained in production.
