# AUGGIE Database Specification Command

## Purpose
Generate comprehensive database specifications that prevent migration hell by planning the complete data architecture upfront. This includes schema design, relationships, constraints, indexes, functions, and migration strategy.

## Command Usage
This command is invoked via `auggie-database-spec "project-name" "database-focus-area"`

## Database Specification Template

### Project Database Overview
**Project**: {PROJECT_NAME}
**Database Focus**: {DATABASE_FOCUS}
**Database Type**: {DATABASE_TYPE} (PostgreSQL/MySQL/MongoDB/etc.)
**Expected Scale**: {SCALE_REQUIREMENTS}
**Performance Requirements**: {PERFORMANCE_TARGETS}

### Data Architecture Analysis

#### Business Domain Analysis
- **Core Business Entities**: [User, Product, Order, etc.]
- **Business Processes**: [Registration, Purchase, Inventory, etc.]
- **Data Relationships**: [One-to-many, Many-to-many, Hierarchical]
- **Business Rules**: [Constraints, validations, calculations]

#### Data Flow Analysis
- **Data Sources**: [User input, external APIs, file imports, etc.]
- **Data Transformations**: [Calculations, aggregations, formatting]
- **Data Destinations**: [Reports, APIs, exports, analytics]
- **Data Lifecycle**: [Creation, updates, archival, deletion]

### Complete Schema Design

#### Core Tables
```sql
-- Users table with all necessary fields from the start
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    date_of_birth DATE,
    profile_image_url TEXT,
    email_verified BOOLEAN DEFAULT FALSE,
    phone_verified BOOLEAN DEFAULT FALSE,
    status user_status_enum DEFAULT 'active',
    preferences JSONB DEFAULT '{}',
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    deleted_at TIMESTAMP WITH TIME ZONE
);

-- Add all anticipated tables here to prevent future schema conflicts
```

#### Relationship Tables
```sql
-- Junction tables for many-to-many relationships
-- Plan these upfront to avoid complex migrations later
CREATE TABLE user_roles (
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    role_id UUID REFERENCES roles(id) ON DELETE CASCADE,
    granted_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    granted_by UUID REFERENCES users(id),
    expires_at TIMESTAMP WITH TIME ZONE,
    PRIMARY KEY (user_id, role_id)
);
```

#### Audit and Tracking Tables
```sql
-- Audit tables for compliance and debugging
CREATE TABLE audit_log (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    table_name VARCHAR(100) NOT NULL,
    record_id UUID NOT NULL,
    action audit_action_enum NOT NULL,
    old_values JSONB,
    new_values JSONB,
    changed_by UUID REFERENCES users(id),
    changed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    ip_address INET,
    user_agent TEXT
);
```

### Data Types and Constraints

#### Custom Types and Enums
```sql
-- Define all enums upfront to avoid migration complexity
CREATE TYPE user_status_enum AS ENUM ('active', 'inactive', 'suspended', 'pending_verification');
CREATE TYPE audit_action_enum AS ENUM ('INSERT', 'UPDATE', 'DELETE', 'LOGIN', 'LOGOUT');
CREATE TYPE notification_type_enum AS ENUM ('email', 'sms', 'push', 'in_app');
```

#### Constraints and Validations
```sql
-- Business rule constraints
ALTER TABLE users ADD CONSTRAINT valid_email CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');
ALTER TABLE users ADD CONSTRAINT valid_phone CHECK (phone IS NULL OR phone ~* '^\+?[1-9]\d{1,14}$');
ALTER TABLE users ADD CONSTRAINT valid_age CHECK (date_of_birth IS NULL OR date_of_birth <= CURRENT_DATE - INTERVAL '13 years');
```

### Indexes and Performance

#### Primary Indexes
```sql
-- Performance-critical indexes planned upfront
CREATE INDEX idx_users_email ON users(email) WHERE deleted_at IS NULL;
CREATE INDEX idx_users_status ON users(status) WHERE deleted_at IS NULL;
CREATE INDEX idx_users_created_at ON users(created_at);
```

#### Composite Indexes
```sql
-- Multi-column indexes for common query patterns
CREATE INDEX idx_user_roles_lookup ON user_roles(user_id, role_id) WHERE expires_at IS NULL OR expires_at > NOW();
CREATE INDEX idx_audit_log_search ON audit_log(table_name, record_id, changed_at DESC);
```

#### Full-Text Search Indexes
```sql
-- Search functionality indexes
CREATE INDEX idx_users_search ON users USING gin(to_tsvector('english', first_name || ' ' || last_name || ' ' || email));
```

### Database Functions and Procedures

#### Utility Functions
```sql
-- Common utility functions to avoid code duplication
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply to all tables with updated_at
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
```

#### Business Logic Functions
```sql
-- Complex business logic in database functions
CREATE OR REPLACE FUNCTION calculate_user_score(user_id UUID)
RETURNS INTEGER AS $$
DECLARE
    score INTEGER := 0;
BEGIN
    -- Complex scoring logic here
    -- This prevents inconsistent calculations across the application
    RETURN score;
END;
$$ LANGUAGE plpgsql;
```

### Data Integrity and Relationships

#### Foreign Key Relationships
```sql
-- All relationships defined upfront with proper cascade rules
ALTER TABLE user_profiles ADD CONSTRAINT fk_user_profiles_user_id 
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

ALTER TABLE orders ADD CONSTRAINT fk_orders_user_id 
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT;
```

#### Check Constraints
```sql
-- Business rule enforcement at database level
ALTER TABLE orders ADD CONSTRAINT valid_order_total 
    CHECK (total_amount >= 0 AND total_amount <= 1000000);

ALTER TABLE products ADD CONSTRAINT valid_price 
    CHECK (price >= 0 AND (discount_price IS NULL OR discount_price < price));
```

### Migration Strategy

#### Initial Migration (v1.0.0)
```sql
-- Complete initial schema with all anticipated tables
-- This prevents the "30 migrations" problem by planning comprehensively
BEGIN;

-- Create all custom types first
CREATE TYPE user_status_enum AS ENUM (...);

-- Create all tables in dependency order
CREATE TABLE users (...);
CREATE TABLE roles (...);
CREATE TABLE user_roles (...);

-- Create all indexes
CREATE INDEX ...;

-- Create all functions and triggers
CREATE OR REPLACE FUNCTION ...;

COMMIT;
```

#### Future Migration Planning
```sql
-- Plan for anticipated future changes
-- v1.1.0 - Add user preferences (already included in users table as JSONB)
-- v1.2.0 - Add social login (oauth_providers table planned)
-- v1.3.0 - Add multi-tenancy (tenant_id columns planned)
```

### Data Seeding and Test Data

#### Reference Data
```sql
-- Static reference data that should be seeded
INSERT INTO roles (id, name, description) VALUES
    (gen_random_uuid(), 'admin', 'System administrator'),
    (gen_random_uuid(), 'user', 'Regular user'),
    (gen_random_uuid(), 'moderator', 'Content moderator');
```

#### Development Test Data
```sql
-- Comprehensive test data for development
-- This ensures all edge cases are tested from the start
INSERT INTO users (email, password_hash, first_name, last_name, status) VALUES
    ('admin@example.com', '$2b$12$...', 'Admin', 'User', 'active'),
    ('test@example.com', '$2b$12$...', 'Test', 'User', 'active'),
    ('inactive@example.com', '$2b$12$...', 'Inactive', 'User', 'inactive');
```

### Performance Considerations

#### Query Optimization
- **Anticipated Query Patterns**: [List common queries and their optimization]
- **Index Strategy**: [Covering indexes, partial indexes, expression indexes]
- **Partitioning Strategy**: [Table partitioning for large datasets]
- **Caching Strategy**: [Query result caching, materialized views]

#### Scalability Planning
- **Read Replicas**: [When and how to implement read replicas]
- **Sharding Strategy**: [Horizontal partitioning approach]
- **Connection Pooling**: [Database connection management]
- **Monitoring**: [Performance metrics and alerting]

### Security and Compliance

#### Data Security
```sql
-- Row Level Security (RLS) policies
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

CREATE POLICY user_isolation_policy ON users
    FOR ALL TO application_role
    USING (id = current_setting('app.current_user_id')::UUID);
```

#### Data Privacy
```sql
-- GDPR compliance functions
CREATE OR REPLACE FUNCTION anonymize_user_data(user_id UUID)
RETURNS VOID AS $$
BEGIN
    UPDATE users SET
        email = 'deleted_' || id || '@example.com',
        first_name = 'Deleted',
        last_name = 'User',
        phone = NULL,
        profile_image_url = NULL,
        preferences = '{}',
        metadata = '{}'
    WHERE id = user_id;
END;
$$ LANGUAGE plpgsql;
```

### Backup and Recovery

#### Backup Strategy
- **Full Backups**: [Daily full database backups]
- **Incremental Backups**: [Hourly transaction log backups]
- **Point-in-Time Recovery**: [Ability to restore to any point in time]
- **Cross-Region Replication**: [Disaster recovery setup]

#### Data Retention
```sql
-- Automated data cleanup procedures
CREATE OR REPLACE FUNCTION cleanup_old_audit_logs()
RETURNS VOID AS $$
BEGIN
    DELETE FROM audit_log 
    WHERE changed_at < NOW() - INTERVAL '2 years';
END;
$$ LANGUAGE plpgsql;
```

### Database Documentation

#### Schema Documentation
- **Entity Relationship Diagram**: [Complete ERD with all relationships]
- **Data Dictionary**: [All tables, columns, and their purposes]
- **Business Rules**: [All constraints and their business justification]
- **Query Examples**: [Common query patterns and their explanations]

#### Migration Documentation
- **Migration History**: [Complete record of all schema changes]
- **Rollback Procedures**: [How to safely rollback each migration]
- **Testing Procedures**: [How to test migrations before deployment]

### Monitoring and Maintenance

#### Performance Monitoring
```sql
-- Database performance monitoring queries
CREATE VIEW slow_queries AS
SELECT query, calls, total_time, mean_time, rows
FROM pg_stat_statements
WHERE mean_time > 1000
ORDER BY mean_time DESC;
```

#### Health Checks
```sql
-- Database health monitoring
CREATE OR REPLACE FUNCTION database_health_check()
RETURNS TABLE(check_name TEXT, status TEXT, details TEXT) AS $$
BEGIN
    -- Connection count check
    RETURN QUERY SELECT 'connection_count'::TEXT, 
        CASE WHEN count(*) < 80 THEN 'OK' ELSE 'WARNING' END,
        'Active connections: ' || count(*)::TEXT
    FROM pg_stat_activity WHERE state = 'active';
    
    -- More health checks...
END;
$$ LANGUAGE plpgsql;
```

---

## AUGGIE Instructions

When generating this specification:

1. **Analyze All Requirements**: Review all specifications, context materials, and business requirements
2. **Plan Comprehensively**: Design the complete data model upfront, not just immediate needs
3. **Consider Future Growth**: Anticipate future features and plan schema accordingly
4. **Prevent Migration Hell**: Design tables with all likely columns from the start
5. **Optimize for Performance**: Plan indexes and query patterns upfront
6. **Ensure Data Integrity**: Define all constraints and relationships properly
7. **Plan for Compliance**: Include audit trails and privacy features from the start

### Context Integration
- Analyze all existing specifications for data requirements
- Review business requirements for compliance needs
- Consider technical architecture for performance requirements
- Plan for the specific database technology chosen

### Output Requirements
- Complete schema with all anticipated tables and columns
- All relationships, constraints, and indexes defined
- Migration strategy that minimizes future schema changes
- Performance optimization plan
- Security and compliance considerations
- Comprehensive documentation

This specification should eliminate the need for multiple migrations by planning the complete data architecture upfront.
