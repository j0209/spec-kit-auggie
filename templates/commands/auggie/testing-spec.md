# AUGGIE Testing Strategy Specification Command

## Purpose
Generate comprehensive testing specifications that ensure robust, reliable, and high-quality applications through systematic testing strategies covering all aspects from unit tests to performance testing.

## Command Usage
This command is invoked via `auggie-testing-spec "project-name" "testing-focus-area"`

## Testing Specification Template

### Project Testing Overview
**Project**: {PROJECT_NAME}
**Testing Focus**: {TESTING_FOCUS}
**Testing Framework**: {TESTING_FRAMEWORK}
**Coverage Target**: {COVERAGE_TARGET}
**Performance Targets**: {PERFORMANCE_TARGETS}

### Testing Strategy

#### Testing Pyramid
```
                    /\
                   /  \
                  / E2E \
                 /______\
                /        \
               /Integration\
              /__________\
             /            \
            /     Unit     \
           /________________\
```

#### Test Categories and Coverage
- **Unit Tests (70%)**: Individual functions and components
- **Integration Tests (20%)**: Component interactions and API endpoints
- **End-to-End Tests (10%)**: Complete user workflows
- **Performance Tests**: Load, stress, and scalability testing
- **Security Tests**: Vulnerability and penetration testing

### Unit Testing Strategy

#### Jest Configuration
```javascript
// jest.config.js
module.exports = {
  testEnvironment: 'node',
  collectCoverageFrom: [
    'src/**/*.{js,ts}',
    '!src/**/*.d.ts',
    '!src/**/*.test.{js,ts}',
    '!src/index.js'
  ],
  coverageThreshold: {
    global: {
      branches: 80,
      functions: 80,
      lines: 80,
      statements: 80
    }
  },
  setupFilesAfterEnv: ['<rootDir>/tests/setup.js'],
  testMatch: [
    '<rootDir>/tests/unit/**/*.test.{js,ts}',
    '<rootDir>/src/**/__tests__/**/*.{js,ts}'
  ]
};
```

#### Unit Test Examples
```javascript
// tests/unit/userService.test.js
const UserService = require('../../src/services/UserService');
const User = require('../../src/models/User');

jest.mock('../../src/models/User');

describe('UserService', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  describe('createUser', () => {
    it('should create a user with valid data', async () => {
      const userData = {
        email: 'test@example.com',
        firstName: 'John',
        lastName: 'Doe'
      };

      User.create.mockResolvedValue({ id: 1, ...userData });

      const result = await UserService.createUser(userData);

      expect(User.create).toHaveBeenCalledWith(userData);
      expect(result).toEqual({ id: 1, ...userData });
    });

    it('should throw error for invalid email', async () => {
      const userData = {
        email: 'invalid-email',
        firstName: 'John',
        lastName: 'Doe'
      };

      await expect(UserService.createUser(userData))
        .rejects
        .toThrow('Invalid email format');
    });

    it('should handle database errors', async () => {
      const userData = {
        email: 'test@example.com',
        firstName: 'John',
        lastName: 'Doe'
      };

      User.create.mockRejectedValue(new Error('Database connection failed'));

      await expect(UserService.createUser(userData))
        .rejects
        .toThrow('Database connection failed');
    });
  });
});
```

### Integration Testing Strategy

#### API Integration Tests
```javascript
// tests/integration/userAPI.test.js
const request = require('supertest');
const app = require('../../src/app');
const { setupTestDB, cleanupTestDB } = require('../helpers/database');

describe('User API Integration', () => {
  beforeAll(async () => {
    await setupTestDB();
  });

  afterAll(async () => {
    await cleanupTestDB();
  });

  describe('POST /api/users', () => {
    it('should create a new user', async () => {
      const userData = {
        email: 'test@example.com',
        firstName: 'John',
        lastName: 'Doe',
        password: 'securePassword123'
      };

      const response = await request(app)
        .post('/api/users')
        .send(userData)
        .expect(201);

      expect(response.body).toMatchObject({
        email: userData.email,
        firstName: userData.firstName,
        lastName: userData.lastName
      });
      expect(response.body).not.toHaveProperty('password');
      expect(response.body).toHaveProperty('id');
    });

    it('should return 400 for duplicate email', async () => {
      const userData = {
        email: 'duplicate@example.com',
        firstName: 'John',
        lastName: 'Doe',
        password: 'securePassword123'
      };

      // Create first user
      await request(app)
        .post('/api/users')
        .send(userData)
        .expect(201);

      // Try to create duplicate
      const response = await request(app)
        .post('/api/users')
        .send(userData)
        .expect(400);

      expect(response.body).toHaveProperty('error');
      expect(response.body.error).toContain('already exists');
    });
  });

  describe('GET /api/users', () => {
    it('should return paginated users', async () => {
      const response = await request(app)
        .get('/api/users')
        .query({ page: 1, limit: 10 })
        .expect(200);

      expect(response.body).toHaveProperty('data');
      expect(response.body).toHaveProperty('pagination');
      expect(Array.isArray(response.body.data)).toBe(true);
    });
  });
});
```

#### Database Integration Tests
```javascript
// tests/integration/database.test.js
const { User, Order } = require('../../src/models');
const { setupTestDB, cleanupTestDB } = require('../helpers/database');

describe('Database Integration', () => {
  beforeAll(async () => {
    await setupTestDB();
  });

  afterAll(async () => {
    await cleanupTestDB();
  });

  describe('User-Order Relationship', () => {
    it('should create user with orders', async () => {
      const user = await User.create({
        email: 'test@example.com',
        firstName: 'John',
        lastName: 'Doe'
      });

      const order = await Order.create({
        userId: user.id,
        total: 99.99,
        status: 'pending'
      });

      const userWithOrders = await User.findByPk(user.id, {
        include: [Order]
      });

      expect(userWithOrders.Orders).toHaveLength(1);
      expect(userWithOrders.Orders[0].total).toBe(99.99);
    });
  });
});
```

### End-to-End Testing Strategy

#### Cypress E2E Tests
```javascript
// cypress/e2e/userRegistration.cy.js
describe('User Registration Flow', () => {
  beforeEach(() => {
    cy.visit('/register');
  });

  it('should complete user registration successfully', () => {
    // Fill registration form
    cy.get('[data-testid="email-input"]')
      .type('test@example.com');
    cy.get('[data-testid="firstName-input"]')
      .type('John');
    cy.get('[data-testid="lastName-input"]')
      .type('Doe');
    cy.get('[data-testid="password-input"]')
      .type('securePassword123');
    cy.get('[data-testid="confirmPassword-input"]')
      .type('securePassword123');

    // Submit form
    cy.get('[data-testid="register-button"]').click();

    // Verify success
    cy.url().should('include', '/dashboard');
    cy.get('[data-testid="welcome-message"]')
      .should('contain', 'Welcome, John');
  });

  it('should show validation errors for invalid data', () => {
    cy.get('[data-testid="email-input"]')
      .type('invalid-email');
    cy.get('[data-testid="register-button"]').click();

    cy.get('[data-testid="email-error"]')
      .should('contain', 'Please enter a valid email');
  });

  it('should handle server errors gracefully', () => {
    // Mock server error
    cy.intercept('POST', '/api/users', {
      statusCode: 500,
      body: { error: 'Internal server error' }
    });

    cy.get('[data-testid="email-input"]')
      .type('test@example.com');
    cy.get('[data-testid="firstName-input"]')
      .type('John');
    cy.get('[data-testid="lastName-input"]')
      .type('Doe');
    cy.get('[data-testid="password-input"]')
      .type('securePassword123');
    cy.get('[data-testid="confirmPassword-input"]')
      .type('securePassword123');

    cy.get('[data-testid="register-button"]').click();

    cy.get('[data-testid="error-message"]')
      .should('contain', 'Registration failed');
  });
});
```

#### Playwright E2E Tests
```javascript
// tests/e2e/userWorkflow.spec.js
const { test, expect } = require('@playwright/test');

test.describe('Complete User Workflow', () => {
  test('should complete full user journey', async ({ page }) => {
    // Registration
    await page.goto('/register');
    await page.fill('[data-testid="email-input"]', 'test@example.com');
    await page.fill('[data-testid="firstName-input"]', 'John');
    await page.fill('[data-testid="lastName-input"]', 'Doe');
    await page.fill('[data-testid="password-input"]', 'securePassword123');
    await page.fill('[data-testid="confirmPassword-input"]', 'securePassword123');
    await page.click('[data-testid="register-button"]');

    // Verify dashboard
    await expect(page).toHaveURL(/.*dashboard/);
    await expect(page.locator('[data-testid="welcome-message"]'))
      .toContainText('Welcome, John');

    // Create order
    await page.click('[data-testid="create-order-button"]');
    await page.fill('[data-testid="order-description"]', 'Test Order');
    await page.fill('[data-testid="order-amount"]', '99.99');
    await page.click('[data-testid="submit-order-button"]');

    // Verify order creation
    await expect(page.locator('[data-testid="order-success"]'))
      .toContainText('Order created successfully');
  });
});
```

### Performance Testing Strategy

#### Load Testing with Artillery
```yaml
# artillery-config.yml
config:
  target: 'http://localhost:3000'
  phases:
    - duration: 60
      arrivalRate: 10
      name: "Warm up"
    - duration: 120
      arrivalRate: 50
      name: "Ramp up load"
    - duration: 300
      arrivalRate: 100
      name: "Sustained load"
  payload:
    path: "users.csv"
    fields:
      - "email"
      - "password"

scenarios:
  - name: "User Registration and Login"
    weight: 30
    flow:
      - post:
          url: "/api/users"
          json:
            email: "{{ email }}"
            firstName: "Test"
            lastName: "User"
            password: "{{ password }}"
      - post:
          url: "/api/auth/login"
          json:
            email: "{{ email }}"
            password: "{{ password }}"
          capture:
            - json: "$.token"
              as: "authToken"
      - get:
          url: "/api/users/profile"
          headers:
            Authorization: "Bearer {{ authToken }}"

  - name: "API Endpoints Load Test"
    weight: 70
    flow:
      - get:
          url: "/api/users"
      - get:
          url: "/api/products"
      - get:
          url: "/api/orders"
```

#### K6 Performance Tests
```javascript
// k6-performance-test.js
import http from 'k6/http';
import { check, sleep } from 'k6';

export let options = {
  stages: [
    { duration: '2m', target: 100 }, // Ramp up
    { duration: '5m', target: 100 }, // Stay at 100 users
    { duration: '2m', target: 200 }, // Ramp up to 200 users
    { duration: '5m', target: 200 }, // Stay at 200 users
    { duration: '2m', target: 0 },   // Ramp down
  ],
  thresholds: {
    http_req_duration: ['p(95)<500'], // 95% of requests under 500ms
    http_req_failed: ['rate<0.1'],    // Error rate under 10%
  },
};

export default function () {
  // Test user registration
  let registrationResponse = http.post('http://localhost:3000/api/users', {
    email: `test${Math.random()}@example.com`,
    firstName: 'Test',
    lastName: 'User',
    password: 'testPassword123'
  });

  check(registrationResponse, {
    'registration status is 201': (r) => r.status === 201,
    'registration response time < 500ms': (r) => r.timings.duration < 500,
  });

  sleep(1);

  // Test API endpoints
  let apiResponse = http.get('http://localhost:3000/api/users');
  
  check(apiResponse, {
    'API status is 200': (r) => r.status === 200,
    'API response time < 200ms': (r) => r.timings.duration < 200,
  });

  sleep(1);
}
```

### Security Testing Strategy

#### OWASP ZAP Integration
```yaml
# zap-baseline-scan.yml
name: Security Scan
on: [push, pull_request]

jobs:
  security-scan:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
        
      - name: Start application
        run: |
          npm install
          npm start &
          sleep 30
          
      - name: OWASP ZAP Baseline Scan
        uses: zaproxy/action-baseline@v0.7.0
        with:
          target: 'http://localhost:3000'
          rules_file_name: '.zap/rules.tsv'
          cmd_options: '-a'
```

#### Security Test Cases
```javascript
// tests/security/security.test.js
const request = require('supertest');
const app = require('../../src/app');

describe('Security Tests', () => {
  describe('SQL Injection Protection', () => {
    it('should prevent SQL injection in user queries', async () => {
      const maliciousInput = "'; DROP TABLE users; --";
      
      const response = await request(app)
        .get('/api/users')
        .query({ search: maliciousInput })
        .expect(200);
        
      // Should not crash and should sanitize input
      expect(response.body).toBeDefined();
    });
  });

  describe('XSS Protection', () => {
    it('should sanitize XSS attempts in user input', async () => {
      const xssPayload = '<script>alert("xss")</script>';
      
      const response = await request(app)
        .post('/api/users')
        .send({
          email: 'test@example.com',
          firstName: xssPayload,
          lastName: 'User',
          password: 'password123'
        })
        .expect(201);
        
      expect(response.body.firstName).not.toContain('<script>');
    });
  });

  describe('Rate Limiting', () => {
    it('should enforce rate limits', async () => {
      const requests = Array(101).fill().map(() =>
        request(app).get('/api/users')
      );
      
      const responses = await Promise.all(requests);
      const rateLimitedResponse = responses.find(r => r.status === 429);
      
      expect(rateLimitedResponse).toBeDefined();
    });
  });
});
```

### Cross-Browser Testing

#### Selenium Grid Configuration
```yaml
# docker-compose.selenium.yml
version: '3'
services:
  selenium-hub:
    image: selenium/hub:4.0.0
    container_name: selenium-hub
    ports:
      - "4444:4444"

  chrome:
    image: selenium/node-chrome:4.0.0
    shm_size: 2gb
    depends_on:
      - selenium-hub
    environment:
      - HUB_HOST=selenium-hub
      - HUB_PORT=4444

  firefox:
    image: selenium/node-firefox:4.0.0
    shm_size: 2gb
    depends_on:
      - selenium-hub
    environment:
      - HUB_HOST=selenium-hub
      - HUB_PORT=4444
```

#### Cross-Browser Test Suite
```javascript
// tests/cross-browser/browser.test.js
const { Builder, By, until } = require('selenium-webdriver');

const browsers = ['chrome', 'firefox', 'safari'];

browsers.forEach(browserName => {
  describe(`Cross-browser tests - ${browserName}`, () => {
    let driver;

    beforeAll(async () => {
      driver = await new Builder()
        .forBrowser(browserName)
        .usingServer('http://localhost:4444/wd/hub')
        .build();
    });

    afterAll(async () => {
      await driver.quit();
    });

    it('should load homepage correctly', async () => {
      await driver.get('http://localhost:3000');
      
      const title = await driver.getTitle();
      expect(title).toContain('{PROJECT_NAME}');
      
      const header = await driver.findElement(By.css('h1'));
      const headerText = await header.getText();
      expect(headerText).toBeDefined();
    });

    it('should handle form submission', async () => {
      await driver.get('http://localhost:3000/register');
      
      await driver.findElement(By.css('[data-testid="email-input"]'))
        .sendKeys('test@example.com');
      await driver.findElement(By.css('[data-testid="firstName-input"]'))
        .sendKeys('John');
      await driver.findElement(By.css('[data-testid="lastName-input"]'))
        .sendKeys('Doe');
      await driver.findElement(By.css('[data-testid="password-input"]'))
        .sendKeys('password123');
      
      await driver.findElement(By.css('[data-testid="register-button"]')).click();
      
      await driver.wait(until.urlContains('/dashboard'), 5000);
    });
  });
});
```

### Mobile Testing Strategy

#### Appium Mobile Tests
```javascript
// tests/mobile/mobile.test.js
const { remote } = require('webdriverio');

const capabilities = {
  platformName: 'iOS',
  platformVersion: '15.0',
  deviceName: 'iPhone 13',
  app: '/path/to/app.ipa',
  automationName: 'XCUITest'
};

describe('Mobile App Tests', () => {
  let driver;

  beforeAll(async () => {
    driver = await remote({
      port: 4723,
      capabilities
    });
  });

  afterAll(async () => {
    await driver.deleteSession();
  });

  it('should complete mobile registration flow', async () => {
    await driver.$('~email-input').setValue('test@example.com');
    await driver.$('~firstName-input').setValue('John');
    await driver.$('~lastName-input').setValue('Doe');
    await driver.$('~password-input').setValue('password123');
    
    await driver.$('~register-button').click();
    
    await driver.waitUntil(async () => {
      const welcomeText = await driver.$('~welcome-message').getText();
      return welcomeText.includes('Welcome');
    }, 5000);
  });
});
```

---

## AUGGIE Instructions

When generating this specification:

1. **Analyze Testing Requirements**: Review all specifications for testing needs and quality requirements
2. **Design Comprehensive Strategy**: Create testing strategy covering all levels from unit to E2E
3. **Plan Performance Testing**: Include load testing, stress testing, and performance benchmarks
4. **Include Security Testing**: Plan security testing procedures and vulnerability assessments
5. **Cover All Platforms**: Include cross-browser, mobile, and accessibility testing
6. **Automate Everything**: Design automated testing pipelines and CI/CD integration
7. **Set Quality Gates**: Define coverage thresholds and quality metrics

### Context Integration
- Analyze functional requirements for test case generation
- Consider performance requirements for performance testing
- Plan security testing based on security specifications
- Integrate with CI/CD pipeline from infrastructure specifications

### Output Requirements
- Complete testing strategy with all test types and frameworks
- Unit, integration, and E2E test specifications
- Performance and load testing procedures
- Security testing protocols and tools
- Cross-browser and mobile testing strategies
- Test automation and CI/CD integration
- Quality metrics and coverage requirements

This specification ensures comprehensive testing coverage and high-quality, reliable applications.
