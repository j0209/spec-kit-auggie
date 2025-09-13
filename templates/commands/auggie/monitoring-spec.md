# AUGGIE Monitoring & Observability Specification Command

## Purpose
Generate comprehensive monitoring and observability specifications that ensure production systems are properly monitored, alerting is configured, and issues can be quickly identified and resolved.

## Command Usage
This command is invoked via `auggie-monitoring-spec "project-name" "monitoring-focus-area"`

## Monitoring Specification Template

### Project Monitoring Overview
**Project**: {PROJECT_NAME}
**Monitoring Focus**: {MONITORING_FOCUS}
**Monitoring Stack**: {MONITORING_STACK} (Prometheus/Grafana/ELK/DataDog)
**Alert Channels**: {ALERT_CHANNELS}
**SLA Requirements**: {SLA_REQUIREMENTS}

### Logging Strategy

#### Structured Logging Configuration
```javascript
// Winston logging configuration
const winston = require('winston');

const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.errors({ stack: true }),
    winston.format.json()
  ),
  defaultMeta: {
    service: '{PROJECT_NAME}',
    version: process.env.APP_VERSION,
    environment: process.env.NODE_ENV
  },
  transports: [
    new winston.transports.Console(),
    new winston.transports.File({ 
      filename: 'logs/error.log', 
      level: 'error' 
    }),
    new winston.transports.File({ 
      filename: 'logs/combined.log' 
    })
  ]
});

// Request logging middleware
app.use((req, res, next) => {
  const start = Date.now();
  res.on('finish', () => {
    const duration = Date.now() - start;
    logger.info('HTTP Request', {
      method: req.method,
      url: req.url,
      status: res.statusCode,
      duration: duration,
      userAgent: req.get('User-Agent'),
      ip: req.ip,
      userId: req.user?.id
    });
  });
  next();
});
```

#### Log Aggregation Setup
```yaml
# Fluentd configuration for log aggregation
apiVersion: v1
kind: ConfigMap
metadata:
  name: fluentd-config
data:
  fluent.conf: |
    <source>
      @type tail
      path /var/log/containers/*{PROJECT_NAME}*.log
      pos_file /var/log/fluentd-containers.log.pos
      tag kubernetes.*
      format json
    </source>
    
    <filter kubernetes.**>
      @type kubernetes_metadata
    </filter>
    
    <match kubernetes.**>
      @type elasticsearch
      host elasticsearch.logging.svc.cluster.local
      port 9200
      index_name {PROJECT_NAME}-logs
    </match>
```

### Metrics & Monitoring

#### Application Metrics
```javascript
// Prometheus metrics setup
const promClient = require('prom-client');

// Custom metrics
const httpRequestDuration = new promClient.Histogram({
  name: 'http_request_duration_seconds',
  help: 'Duration of HTTP requests in seconds',
  labelNames: ['method', 'route', 'status_code']
});

const httpRequestTotal = new promClient.Counter({
  name: 'http_requests_total',
  help: 'Total number of HTTP requests',
  labelNames: ['method', 'route', 'status_code']
});

const activeConnections = new promClient.Gauge({
  name: 'active_connections',
  help: 'Number of active connections'
});

const businessMetrics = new promClient.Counter({
  name: 'business_events_total',
  help: 'Total business events',
  labelNames: ['event_type', 'status']
});

// Metrics middleware
app.use((req, res, next) => {
  const start = Date.now();
  res.on('finish', () => {
    const duration = (Date.now() - start) / 1000;
    httpRequestDuration
      .labels(req.method, req.route?.path || req.path, res.statusCode)
      .observe(duration);
    httpRequestTotal
      .labels(req.method, req.route?.path || req.path, res.statusCode)
      .inc();
  });
  next();
});

// Metrics endpoint
app.get('/metrics', (req, res) => {
  res.set('Content-Type', promClient.register.contentType);
  res.end(promClient.register.metrics());
});
```

#### Infrastructure Metrics
```yaml
# Prometheus configuration
global:
  scrape_interval: 15s
  evaluation_interval: 15s

rule_files:
  - "alert_rules.yml"

scrape_configs:
  - job_name: '{PROJECT_NAME}'
    static_configs:
      - targets: ['{PROJECT_NAME}-service:3000']
    metrics_path: /metrics
    scrape_interval: 5s
    
  - job_name: 'kubernetes-pods'
    kubernetes_sd_configs:
      - role: pod
    relabel_configs:
      - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
        action: keep
        regex: true

alertmanager:
  alertmanagers:
    - static_configs:
        - targets:
          - alertmanager:9093
```

### Alerting Configuration

#### Alert Rules
```yaml
# alert_rules.yml
groups:
- name: {PROJECT_NAME}_alerts
  rules:
  - alert: HighErrorRate
    expr: rate(http_requests_total{status_code=~"5.."}[5m]) > 0.1
    for: 5m
    labels:
      severity: critical
    annotations:
      summary: "High error rate detected"
      description: "Error rate is {{ $value }} errors per second"
      
  - alert: HighResponseTime
    expr: histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m])) > 1
    for: 5m
    labels:
      severity: warning
    annotations:
      summary: "High response time detected"
      description: "95th percentile response time is {{ $value }} seconds"
      
  - alert: DatabaseConnectionFailure
    expr: up{job="database"} == 0
    for: 1m
    labels:
      severity: critical
    annotations:
      summary: "Database connection failure"
      description: "Database is unreachable"
      
  - alert: HighMemoryUsage
    expr: (container_memory_usage_bytes / container_spec_memory_limit_bytes) > 0.8
    for: 10m
    labels:
      severity: warning
    annotations:
      summary: "High memory usage"
      description: "Memory usage is {{ $value | humanizePercentage }}"
      
  - alert: PodCrashLooping
    expr: rate(kube_pod_container_status_restarts_total[15m]) > 0
    for: 5m
    labels:
      severity: critical
    annotations:
      summary: "Pod is crash looping"
      description: "Pod {{ $labels.pod }} is restarting frequently"
```

#### Notification Channels
```yaml
# Alertmanager configuration
global:
  smtp_smarthost: 'smtp.gmail.com:587'
  smtp_from: 'alerts@{PROJECT_DOMAIN}'

route:
  group_by: ['alertname']
  group_wait: 10s
  group_interval: 10s
  repeat_interval: 1h
  receiver: 'web.hook'
  routes:
  - match:
      severity: critical
    receiver: 'critical-alerts'
  - match:
      severity: warning
    receiver: 'warning-alerts'

receivers:
- name: 'web.hook'
  webhook_configs:
  - url: 'http://127.0.0.1:5001/'

- name: 'critical-alerts'
  email_configs:
  - to: 'oncall@{PROJECT_DOMAIN}'
    subject: 'CRITICAL: {{ .GroupLabels.alertname }}'
    body: |
      {{ range .Alerts }}
      Alert: {{ .Annotations.summary }}
      Description: {{ .Annotations.description }}
      {{ end }}
  slack_configs:
  - api_url: '${SLACK_WEBHOOK_URL}'
    channel: '#alerts'
    title: 'CRITICAL Alert'
    text: '{{ range .Alerts }}{{ .Annotations.summary }}{{ end }}'

- name: 'warning-alerts'
  email_configs:
  - to: 'team@{PROJECT_DOMAIN}'
    subject: 'WARNING: {{ .GroupLabels.alertname }}'
```

### Dashboard Configuration

#### Grafana Dashboards
```json
{
  "dashboard": {
    "title": "{PROJECT_NAME} Overview",
    "panels": [
      {
        "title": "Request Rate",
        "type": "graph",
        "targets": [
          {
            "expr": "rate(http_requests_total[5m])",
            "legendFormat": "{{ method }} {{ route }}"
          }
        ]
      },
      {
        "title": "Response Time",
        "type": "graph",
        "targets": [
          {
            "expr": "histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))",
            "legendFormat": "95th percentile"
          },
          {
            "expr": "histogram_quantile(0.50, rate(http_request_duration_seconds_bucket[5m]))",
            "legendFormat": "50th percentile"
          }
        ]
      },
      {
        "title": "Error Rate",
        "type": "graph",
        "targets": [
          {
            "expr": "rate(http_requests_total{status_code=~\"5..\"}[5m])",
            "legendFormat": "5xx errors"
          },
          {
            "expr": "rate(http_requests_total{status_code=~\"4..\"}[5m])",
            "legendFormat": "4xx errors"
          }
        ]
      },
      {
        "title": "Resource Usage",
        "type": "graph",
        "targets": [
          {
            "expr": "container_memory_usage_bytes / container_spec_memory_limit_bytes",
            "legendFormat": "Memory Usage %"
          },
          {
            "expr": "rate(container_cpu_usage_seconds_total[5m])",
            "legendFormat": "CPU Usage"
          }
        ]
      }
    ]
  }
}
```

### Business Metrics

#### Key Performance Indicators
```javascript
// Business metrics tracking
const trackBusinessEvent = (eventType, status, metadata = {}) => {
  businessMetrics.labels(eventType, status).inc();
  
  logger.info('Business Event', {
    eventType,
    status,
    metadata,
    timestamp: new Date().toISOString()
  });
};

// Usage examples
app.post('/api/users', async (req, res) => {
  try {
    const user = await createUser(req.body);
    trackBusinessEvent('user_registration', 'success', { userId: user.id });
    res.status(201).json(user);
  } catch (error) {
    trackBusinessEvent('user_registration', 'failure', { error: error.message });
    res.status(400).json({ error: error.message });
  }
});

app.post('/api/orders', async (req, res) => {
  try {
    const order = await createOrder(req.body);
    trackBusinessEvent('order_created', 'success', { 
      orderId: order.id, 
      amount: order.total 
    });
    res.status(201).json(order);
  } catch (error) {
    trackBusinessEvent('order_created', 'failure', { error: error.message });
    res.status(400).json({ error: error.message });
  }
});
```

### Error Tracking

#### Error Monitoring Setup
```javascript
// Sentry integration for error tracking
const Sentry = require('@sentry/node');

Sentry.init({
  dsn: process.env.SENTRY_DSN,
  environment: process.env.NODE_ENV,
  tracesSampleRate: 1.0,
  beforeSend(event) {
    // Filter out sensitive information
    if (event.request) {
      delete event.request.headers.authorization;
      delete event.request.headers.cookie;
    }
    return event;
  }
});

// Error handling middleware
app.use(Sentry.Handlers.errorHandler());

app.use((error, req, res, next) => {
  logger.error('Unhandled Error', {
    error: error.message,
    stack: error.stack,
    url: req.url,
    method: req.method,
    userId: req.user?.id
  });
  
  res.status(500).json({
    error: 'Internal Server Error',
    requestId: req.id
  });
});
```

### Performance Monitoring

#### Application Performance Monitoring
```javascript
// APM integration
const apm = require('elastic-apm-node').start({
  serviceName: '{PROJECT_NAME}',
  environment: process.env.NODE_ENV,
  serverUrl: process.env.ELASTIC_APM_SERVER_URL
});

// Custom performance tracking
const trackPerformance = (operation, duration, metadata = {}) => {
  logger.info('Performance Metric', {
    operation,
    duration,
    metadata,
    timestamp: new Date().toISOString()
  });
  
  // Send to APM
  apm.setCustomContext({
    operation,
    duration,
    ...metadata
  });
};

// Database query performance tracking
const executeQuery = async (query, params) => {
  const start = Date.now();
  try {
    const result = await database.query(query, params);
    const duration = Date.now() - start;
    trackPerformance('database_query', duration, { 
      query: query.substring(0, 100),
      rowCount: result.rows.length 
    });
    return result;
  } catch (error) {
    const duration = Date.now() - start;
    trackPerformance('database_query_error', duration, { 
      query: query.substring(0, 100),
      error: error.message 
    });
    throw error;
  }
};
```

---

## AUGGIE Instructions

When generating this specification:

1. **Analyze System Requirements**: Review all specifications for monitoring needs
2. **Plan Comprehensive Coverage**: Include application, infrastructure, and business metrics
3. **Configure Proper Alerting**: Set up meaningful alerts with appropriate thresholds
4. **Design Useful Dashboards**: Create dashboards that provide actionable insights
5. **Implement Error Tracking**: Ensure all errors are captured and tracked
6. **Monitor Performance**: Track application and infrastructure performance
7. **Plan for Scale**: Ensure monitoring scales with the application

### Context Integration
- Analyze performance requirements from technical specifications
- Consider security monitoring requirements from security specifications
- Plan database monitoring based on database specifications
- Integrate with infrastructure monitoring from infrastructure specifications

### Output Requirements
- Complete logging strategy with structured logging and aggregation
- Comprehensive metrics collection for application and infrastructure
- Alerting configuration with proper notification channels
- Dashboard specifications for monitoring and troubleshooting
- Error tracking and performance monitoring setup
- Business metrics tracking for key performance indicators

This specification ensures the project has proper observability and can be effectively monitored in production.
