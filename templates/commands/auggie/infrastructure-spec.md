# AUGGIE Infrastructure & Deployment Specification Command

## Purpose
Generate comprehensive infrastructure and deployment specifications that ensure production-ready, scalable, and maintainable deployments. This prevents deployment failures, downtime, and operational issues.

## Command Usage
This command is invoked via `auggie-infrastructure-spec "project-name" "infrastructure-focus-area"`

## Infrastructure Specification Template

### Project Infrastructure Overview
**Project**: {PROJECT_NAME}
**Infrastructure Focus**: {INFRASTRUCTURE_FOCUS}
**Deployment Environment**: {DEPLOYMENT_ENVIRONMENT} (AWS/GCP/Azure/On-premise)
**Expected Scale**: {SCALE_REQUIREMENTS}
**Availability Requirements**: {AVAILABILITY_SLA}

### Deployment Architecture

#### Environment Strategy
```yaml
# Environment Configuration
environments:
  development:
    replicas: 1
    resources: { cpu: "0.5", memory: "512Mi" }
    database: single-instance
    monitoring: basic
  
  staging:
    replicas: 2
    resources: { cpu: "1", memory: "1Gi" }
    database: replica-set
    monitoring: full
    
  production:
    replicas: 3
    resources: { cpu: "2", memory: "2Gi" }
    database: cluster
    monitoring: full
    alerting: enabled
```

#### Container Specifications
```dockerfile
# Production-ready Dockerfile template
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

FROM node:18-alpine AS runtime
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nextjs -u 1001
WORKDIR /app
COPY --from=builder --chown=nextjs:nodejs /app/node_modules ./node_modules
COPY --from=builder --chown=nextjs:nodejs /app/package.json ./package.json
USER nextjs
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1
CMD ["npm", "start"]
```

#### Kubernetes Deployment
```yaml
# Production Kubernetes deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {PROJECT_NAME}
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  template:
    spec:
      containers:
      - name: app
        image: {PROJECT_NAME}:latest
        ports:
        - containerPort: 3000
        env:
        - name: NODE_ENV
          value: "production"
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
          limits:
            cpu: 500m
            memory: 512Mi
        livenessProbe:
          httpGet:
            path: /health
            port: 3000
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /ready
            port: 3000
          initialDelaySeconds: 5
          periodSeconds: 5
```

### CI/CD Pipeline

#### GitHub Actions Workflow
```yaml
# .github/workflows/deploy.yml
name: Deploy to Production
on:
  push:
    branches: [main]
    
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - name: Run Tests
      run: |
        npm ci
        npm run test:unit
        npm run test:integration
        npm run test:e2e
        
  security:
    runs-on: ubuntu-latest
    steps:
    - name: Security Scan
      run: |
        npm audit --audit-level high
        docker run --rm -v "$PWD:/app" securecodewarrior/docker-security-scan
        
  build:
    needs: [test, security]
    runs-on: ubuntu-latest
    steps:
    - name: Build and Push
      run: |
        docker build -t ${{ secrets.REGISTRY }}/${{ github.repository }}:${{ github.sha }} .
        docker push ${{ secrets.REGISTRY }}/${{ github.repository }}:${{ github.sha }}
        
  deploy:
    needs: build
    runs-on: ubuntu-latest
    steps:
    - name: Deploy to Production
      run: |
        kubectl set image deployment/{PROJECT_NAME} app=${{ secrets.REGISTRY }}/${{ github.repository }}:${{ github.sha }}
        kubectl rollout status deployment/{PROJECT_NAME}
```

### Health Checks & Monitoring

#### Health Check Endpoints
```javascript
// /health - Liveness probe
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    uptime: process.uptime()
  });
});

// /ready - Readiness probe
app.get('/ready', async (req, res) => {
  try {
    await database.ping();
    await redis.ping();
    res.status(200).json({
      status: 'ready',
      services: {
        database: 'connected',
        redis: 'connected'
      }
    });
  } catch (error) {
    res.status(503).json({
      status: 'not ready',
      error: error.message
    });
  }
});
```

#### Graceful Shutdown
```javascript
// Graceful shutdown handling
process.on('SIGTERM', () => {
  console.log('SIGTERM received, shutting down gracefully');
  server.close(() => {
    database.close();
    redis.quit();
    process.exit(0);
  });
});

process.on('SIGINT', () => {
  console.log('SIGINT received, shutting down gracefully');
  server.close(() => {
    database.close();
    redis.quit();
    process.exit(0);
  });
});
```

### Configuration Management

#### Environment Variables
```bash
# Production environment variables
NODE_ENV=production
PORT=3000
DATABASE_URL=postgresql://user:pass@db:5432/dbname
REDIS_URL=redis://redis:6379
JWT_SECRET=${JWT_SECRET}
API_KEY=${API_KEY}
LOG_LEVEL=info
METRICS_ENABLED=true
```

#### Secrets Management
```yaml
# Kubernetes secrets
apiVersion: v1
kind: Secret
metadata:
  name: {PROJECT_NAME}-secrets
type: Opaque
data:
  jwt-secret: ${JWT_SECRET_BASE64}
  api-key: ${API_KEY_BASE64}
  database-password: ${DB_PASSWORD_BASE64}
```

### Scaling & Performance

#### Horizontal Pod Autoscaler
```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: {PROJECT_NAME}-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: {PROJECT_NAME}
  minReplicas: 3
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80
```

#### Load Balancer Configuration
```yaml
apiVersion: v1
kind: Service
metadata:
  name: {PROJECT_NAME}-service
spec:
  type: LoadBalancer
  ports:
  - port: 80
    targetPort: 3000
    protocol: TCP
  selector:
    app: {PROJECT_NAME}
```

### Backup & Recovery

#### Database Backup Strategy
```bash
#!/bin/bash
# Automated database backup script
BACKUP_DIR="/backups/$(date +%Y-%m-%d)"
mkdir -p $BACKUP_DIR

# Full backup
pg_dump $DATABASE_URL > $BACKUP_DIR/full_backup.sql

# Upload to cloud storage
aws s3 cp $BACKUP_DIR/full_backup.sql s3://backups/{PROJECT_NAME}/$(date +%Y-%m-%d)/

# Retention policy - keep 30 days
find /backups -type d -mtime +30 -exec rm -rf {} \;
```

#### Disaster Recovery Plan
```yaml
# Disaster recovery procedures
recovery_procedures:
  database:
    rto: 4 hours  # Recovery Time Objective
    rpo: 1 hour   # Recovery Point Objective
    steps:
      - Restore from latest backup
      - Verify data integrity
      - Update DNS records
      - Restart applications
      
  application:
    rto: 30 minutes
    rpo: 5 minutes
    steps:
      - Deploy to backup region
      - Update load balancer
      - Verify health checks
```

### Security Configuration

#### Network Policies
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: {PROJECT_NAME}-network-policy
spec:
  podSelector:
    matchLabels:
      app: {PROJECT_NAME}
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: nginx-ingress
    ports:
    - protocol: TCP
      port: 3000
```

#### SSL/TLS Configuration
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {PROJECT_NAME}-ingress
  annotations:
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
spec:
  tls:
  - hosts:
    - {PROJECT_DOMAIN}
    secretName: {PROJECT_NAME}-tls
  rules:
  - host: {PROJECT_DOMAIN}
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: {PROJECT_NAME}-service
            port:
              number: 80
```

---

## AUGGIE Instructions

When generating this specification:

1. **Analyze Project Requirements**: Review all existing specifications for infrastructure needs
2. **Plan for Scale**: Design infrastructure that can handle expected load and growth
3. **Ensure High Availability**: Plan for redundancy and failover scenarios
4. **Security First**: Include security configurations and best practices
5. **Automate Everything**: Create CI/CD pipelines and automated deployment procedures
6. **Monitor & Alert**: Include comprehensive monitoring and alerting setup
7. **Plan for Disasters**: Include backup, recovery, and disaster recovery procedures

### Context Integration
- Analyze performance requirements from technical specifications
- Consider security requirements from security specifications
- Plan database infrastructure based on database specifications
- Integrate with existing project architecture and constraints

### Output Requirements
- Complete deployment strategy with environment configurations
- CI/CD pipeline specifications with automated testing and security scanning
- Health check and monitoring configurations
- Scaling and performance optimization plans
- Backup, recovery, and disaster recovery procedures
- Security configurations and network policies
- Infrastructure as code templates (Kubernetes, Docker, etc.)

This specification ensures the project can be deployed, scaled, and maintained in production environments.
