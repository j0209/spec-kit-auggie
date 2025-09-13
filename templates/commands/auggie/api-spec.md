# AUGGIE API & Integration Specification Command

## Purpose
Generate comprehensive API and integration specifications that ensure robust, scalable, and well-documented APIs with proper third-party integrations, caching, and rate limiting.

## Command Usage
This command is invoked via `auggie-api-spec "project-name" "api-focus-area"`

## API Specification Template

### Project API Overview
**Project**: {PROJECT_NAME}
**API Focus**: {API_FOCUS}
**API Type**: {API_TYPE} (REST/GraphQL/gRPC)
**Authentication**: {AUTH_METHOD}
**Expected Load**: {EXPECTED_LOAD}

### API Architecture

#### API Design Standards
```yaml
# OpenAPI 3.0 Specification Template
openapi: 3.0.3
info:
  title: {PROJECT_NAME} API
  description: Comprehensive API for {PROJECT_NAME}
  version: 1.0.0
  contact:
    name: API Support
    email: api-support@{PROJECT_DOMAIN}
  license:
    name: MIT
    url: https://opensource.org/licenses/MIT

servers:
  - url: https://api.{PROJECT_DOMAIN}/v1
    description: Production server
  - url: https://staging-api.{PROJECT_DOMAIN}/v1
    description: Staging server

paths:
  /users:
    get:
      summary: List users
      parameters:
        - name: page
          in: query
          schema:
            type: integer
            minimum: 1
            default: 1
        - name: limit
          in: query
          schema:
            type: integer
            minimum: 1
            maximum: 100
            default: 20
        - name: sort
          in: query
          schema:
            type: string
            enum: [created_at, updated_at, name]
            default: created_at
      responses:
        '200':
          description: Successful response
          content:
            application/json:
              schema:
                type: object
                properties:
                  data:
                    type: array
                    items:
                      $ref: '#/components/schemas/User'
                  pagination:
                    $ref: '#/components/schemas/Pagination'
        '400':
          $ref: '#/components/responses/BadRequest'
        '401':
          $ref: '#/components/responses/Unauthorized'
        '429':
          $ref: '#/components/responses/RateLimited'
```

#### Rate Limiting Strategy
```javascript
// Rate limiting configuration
const rateLimit = require('express-rate-limit');
const RedisStore = require('rate-limit-redis');

// Different rate limits for different endpoints
const createRateLimiter = (windowMs, max, message) => {
  return rateLimit({
    store: new RedisStore({
      client: redisClient,
      prefix: 'rl:'
    }),
    windowMs,
    max,
    message: {
      error: 'Rate limit exceeded',
      message,
      retryAfter: Math.ceil(windowMs / 1000)
    },
    standardHeaders: true,
    legacyHeaders: false,
    keyGenerator: (req) => {
      return req.user?.id || req.ip;
    }
  });
};

// Apply different rate limits
app.use('/api/auth', createRateLimiter(15 * 60 * 1000, 5, 'Too many authentication attempts'));
app.use('/api/users', createRateLimiter(15 * 60 * 1000, 100, 'Too many user requests'));
app.use('/api/orders', createRateLimiter(15 * 60 * 1000, 50, 'Too many order requests'));
app.use('/api', createRateLimiter(15 * 60 * 1000, 1000, 'Too many API requests'));
```

#### API Versioning Strategy
```javascript
// API versioning implementation
const express = require('express');
const app = express();

// Version-specific routers
const v1Router = require('./routes/v1');
const v2Router = require('./routes/v2');

// Version routing
app.use('/api/v1', v1Router);
app.use('/api/v2', v2Router);

// Default to latest version
app.use('/api', v2Router);

// Version deprecation middleware
const deprecationWarning = (version, deprecationDate, sunsetDate) => {
  return (req, res, next) => {
    res.set({
      'Deprecation': deprecationDate,
      'Sunset': sunsetDate,
      'Link': `</api/v${version + 1}>; rel="successor-version"`
    });
    next();
  };
};

// Apply deprecation warnings
app.use('/api/v1', deprecationWarning(1, '2024-06-01', '2024-12-01'));
```

### Caching Strategy

#### Multi-Level Caching
```javascript
// Redis caching implementation
const redis = require('redis');
const client = redis.createClient();

// Cache middleware
const cache = (duration = 300) => {
  return async (req, res, next) => {
    const key = `cache:${req.originalUrl}:${JSON.stringify(req.query)}`;
    
    try {
      const cached = await client.get(key);
      if (cached) {
        res.set('X-Cache', 'HIT');
        return res.json(JSON.parse(cached));
      }
    } catch (error) {
      console.error('Cache error:', error);
    }
    
    // Override res.json to cache the response
    const originalJson = res.json;
    res.json = function(data) {
      res.set('X-Cache', 'MISS');
      client.setex(key, duration, JSON.stringify(data));
      return originalJson.call(this, data);
    };
    
    next();
  };
};

// Apply caching to specific routes
app.get('/api/users', cache(300), getUsersHandler);
app.get('/api/products', cache(600), getProductsHandler);
app.get('/api/categories', cache(3600), getCategoriesHandler);
```

#### CDN Configuration
```yaml
# CloudFront distribution configuration
Resources:
  CloudFrontDistribution:
    Type: AWS::CloudFront::Distribution
    Properties:
      DistributionConfig:
        Origins:
          - Id: APIOrigin
            DomainName: api.{PROJECT_DOMAIN}
            CustomOriginConfig:
              HTTPPort: 443
              OriginProtocolPolicy: https-only
        DefaultCacheBehavior:
          TargetOriginId: APIOrigin
          ViewerProtocolPolicy: redirect-to-https
          CachePolicyId: 4135ea2d-6df8-44a3-9df3-4b5a84be39ad  # CachingDisabled
          OriginRequestPolicyId: 88a5eaf4-2fd4-4709-b370-b4c650ea3fcf  # CORS-S3Origin
        CacheBehaviors:
          - PathPattern: "/api/static/*"
            TargetOriginId: APIOrigin
            ViewerProtocolPolicy: redirect-to-https
            CachePolicyId: 658327ea-f89d-4fab-a63d-7e88639e58f6  # CachingOptimized
            TTL: 86400
```

### Authentication & Authorization

#### JWT Implementation
```javascript
// JWT authentication middleware
const jwt = require('jsonwebtoken');
const { promisify } = require('util');

const authenticate = async (req, res, next) => {
  try {
    const token = req.headers.authorization?.replace('Bearer ', '');
    
    if (!token) {
      return res.status(401).json({
        error: 'Authentication required',
        code: 'MISSING_TOKEN'
      });
    }
    
    const decoded = await promisify(jwt.verify)(token, process.env.JWT_SECRET);
    const user = await User.findById(decoded.userId);
    
    if (!user || !user.isActive) {
      return res.status(401).json({
        error: 'Invalid or expired token',
        code: 'INVALID_TOKEN'
      });
    }
    
    req.user = user;
    next();
  } catch (error) {
    return res.status(401).json({
      error: 'Invalid token',
      code: 'TOKEN_VERIFICATION_FAILED'
    });
  }
};

// Role-based authorization
const authorize = (...roles) => {
  return (req, res, next) => {
    if (!req.user) {
      return res.status(401).json({
        error: 'Authentication required',
        code: 'NOT_AUTHENTICATED'
      });
    }
    
    if (!roles.includes(req.user.role)) {
      return res.status(403).json({
        error: 'Insufficient permissions',
        code: 'INSUFFICIENT_PERMISSIONS',
        required: roles,
        current: req.user.role
      });
    }
    
    next();
  };
};
```

### Third-Party Integrations

#### Payment Integration
```javascript
// Stripe payment integration
const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY);

const createPaymentIntent = async (req, res) => {
  try {
    const { amount, currency = 'usd', metadata = {} } = req.body;
    
    const paymentIntent = await stripe.paymentIntents.create({
      amount: amount * 100, // Convert to cents
      currency,
      metadata: {
        userId: req.user.id,
        ...metadata
      },
      automatic_payment_methods: {
        enabled: true
      }
    });
    
    res.json({
      clientSecret: paymentIntent.client_secret,
      paymentIntentId: paymentIntent.id
    });
  } catch (error) {
    res.status(400).json({
      error: 'Payment creation failed',
      details: error.message
    });
  }
};

// Webhook handling
const handleStripeWebhook = async (req, res) => {
  const sig = req.headers['stripe-signature'];
  
  try {
    const event = stripe.webhooks.constructEvent(
      req.body,
      sig,
      process.env.STRIPE_WEBHOOK_SECRET
    );
    
    switch (event.type) {
      case 'payment_intent.succeeded':
        await handlePaymentSuccess(event.data.object);
        break;
      case 'payment_intent.payment_failed':
        await handlePaymentFailure(event.data.object);
        break;
      default:
        console.log(`Unhandled event type: ${event.type}`);
    }
    
    res.json({ received: true });
  } catch (error) {
    console.error('Webhook error:', error);
    res.status(400).json({ error: 'Webhook verification failed' });
  }
};
```

#### Email Service Integration
```javascript
// SendGrid email integration
const sgMail = require('@sendgrid/mail');
sgMail.setApiKey(process.env.SENDGRID_API_KEY);

const emailService = {
  async sendWelcomeEmail(user) {
    const msg = {
      to: user.email,
      from: process.env.FROM_EMAIL,
      templateId: process.env.WELCOME_TEMPLATE_ID,
      dynamicTemplateData: {
        firstName: user.firstName,
        loginUrl: `${process.env.FRONTEND_URL}/login`
      }
    };
    
    try {
      await sgMail.send(msg);
      console.log('Welcome email sent to:', user.email);
    } catch (error) {
      console.error('Email sending failed:', error);
      throw new Error('Failed to send welcome email');
    }
  },
  
  async sendPasswordReset(user, resetToken) {
    const msg = {
      to: user.email,
      from: process.env.FROM_EMAIL,
      templateId: process.env.PASSWORD_RESET_TEMPLATE_ID,
      dynamicTemplateData: {
        firstName: user.firstName,
        resetUrl: `${process.env.FRONTEND_URL}/reset-password?token=${resetToken}`
      }
    };
    
    try {
      await sgMail.send(msg);
      console.log('Password reset email sent to:', user.email);
    } catch (error) {
      console.error('Password reset email failed:', error);
      throw new Error('Failed to send password reset email');
    }
  }
};
```

### API Documentation

#### Interactive Documentation
```javascript
// Swagger/OpenAPI documentation setup
const swaggerJsdoc = require('swagger-jsdoc');
const swaggerUi = require('swagger-ui-express');

const options = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: '{PROJECT_NAME} API',
      version: '1.0.0',
      description: 'Comprehensive API documentation for {PROJECT_NAME}',
    },
    servers: [
      {
        url: process.env.API_URL || 'http://localhost:3000/api',
        description: 'Development server',
      },
    ],
    components: {
      securitySchemes: {
        bearerAuth: {
          type: 'http',
          scheme: 'bearer',
          bearerFormat: 'JWT',
        },
      },
    },
    security: [
      {
        bearerAuth: [],
      },
    ],
  },
  apis: ['./routes/*.js', './models/*.js'],
};

const specs = swaggerJsdoc(options);
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(specs, {
  explorer: true,
  customCss: '.swagger-ui .topbar { display: none }',
  customSiteTitle: '{PROJECT_NAME} API Documentation'
}));
```

### Error Handling

#### Comprehensive Error Responses
```javascript
// Centralized error handling
class APIError extends Error {
  constructor(message, statusCode = 500, code = 'INTERNAL_ERROR', details = null) {
    super(message);
    this.statusCode = statusCode;
    this.code = code;
    this.details = details;
    this.isOperational = true;
  }
}

// Error handling middleware
const errorHandler = (error, req, res, next) => {
  let { statusCode = 500, message, code = 'INTERNAL_ERROR', details } = error;
  
  // Handle specific error types
  if (error.name === 'ValidationError') {
    statusCode = 400;
    code = 'VALIDATION_ERROR';
    details = Object.values(error.errors).map(err => ({
      field: err.path,
      message: err.message
    }));
  } else if (error.name === 'CastError') {
    statusCode = 400;
    code = 'INVALID_ID';
    message = 'Invalid ID format';
  } else if (error.code === 11000) {
    statusCode = 409;
    code = 'DUPLICATE_ENTRY';
    message = 'Resource already exists';
  }
  
  // Log error
  console.error('API Error:', {
    error: message,
    statusCode,
    code,
    stack: error.stack,
    url: req.url,
    method: req.method,
    userId: req.user?.id
  });
  
  // Send error response
  res.status(statusCode).json({
    error: message,
    code,
    ...(details && { details }),
    ...(process.env.NODE_ENV === 'development' && { stack: error.stack }),
    timestamp: new Date().toISOString(),
    requestId: req.id
  });
};

app.use(errorHandler);
```

### API Testing

#### Automated API Testing
```javascript
// Jest API testing setup
const request = require('supertest');
const app = require('../app');

describe('Users API', () => {
  let authToken;
  
  beforeAll(async () => {
    // Setup test user and get auth token
    const response = await request(app)
      .post('/api/auth/login')
      .send({
        email: 'test@example.com',
        password: 'testpassword'
      });
    authToken = response.body.token;
  });
  
  describe('GET /api/users', () => {
    it('should return paginated users', async () => {
      const response = await request(app)
        .get('/api/users')
        .set('Authorization', `Bearer ${authToken}`)
        .query({ page: 1, limit: 10 })
        .expect(200);
        
      expect(response.body).toHaveProperty('data');
      expect(response.body).toHaveProperty('pagination');
      expect(Array.isArray(response.body.data)).toBe(true);
    });
    
    it('should handle rate limiting', async () => {
      // Make multiple requests to trigger rate limit
      const requests = Array(101).fill().map(() =>
        request(app)
          .get('/api/users')
          .set('Authorization', `Bearer ${authToken}`)
      );
      
      const responses = await Promise.all(requests);
      const rateLimitedResponse = responses.find(r => r.status === 429);
      expect(rateLimitedResponse).toBeDefined();
    });
  });
});
```

---

## AUGGIE Instructions

When generating this specification:

1. **Analyze API Requirements**: Review all specifications for API and integration needs
2. **Design Comprehensive APIs**: Create complete API specifications with proper documentation
3. **Plan for Scale**: Include rate limiting, caching, and performance optimization
4. **Secure by Design**: Implement proper authentication, authorization, and security measures
5. **Handle Errors Gracefully**: Design comprehensive error handling and response strategies
6. **Document Everything**: Create interactive API documentation and testing procedures
7. **Plan Integrations**: Design robust third-party integration patterns

### Context Integration
- Analyze business requirements for API functionality
- Consider security requirements for API protection
- Plan database integration for API data access
- Integrate with monitoring for API observability

### Output Requirements
- Complete API specification with OpenAPI documentation
- Rate limiting and caching strategies
- Authentication and authorization implementation
- Third-party integration specifications
- Error handling and response patterns
- API testing strategies and procedures
- Performance optimization and scaling plans

This specification ensures APIs are robust, scalable, well-documented, and production-ready.
