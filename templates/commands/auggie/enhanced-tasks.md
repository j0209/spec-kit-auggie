# AUGGIE Enhanced Development Task Generation Command

## Purpose
Generate comprehensive development tasks in AUGGIE's native task management format that enable multiple AUGGIE agents to coordinate effectively during implementation, with proper dependency management and parallel execution support.

## Command Usage
This command is invoked via `auggie-tasks "project-name" [additional-context]`

## Enhanced Task Generation Template

### Project Development Overview
**Project**: {PROJECT_NAME}
**Development Focus**: {DEVELOPMENT_FOCUS}
**Technology Stack**: {TECH_STACK}
**Complexity Level**: {COMPLEXITY_LEVEL}
**Parallel Agents**: {ESTIMATED_AGENT_COUNT}

### Development Task Categories

#### 1. Setup & Infrastructure Tasks
```yaml
# Foundation tasks that must complete before parallel development
setup_tasks:
  priority: critical
  parallel_safe: false  # Sequential execution required
  dependencies: []
  
  tasks:
    - id: "setup-001"
      name: "Initialize Project Structure"
      description: "Create complete project structure with all directories, configuration files, and initial setup"
      type: "setup"
      estimated_hours: 2
      context_references:
        - ".augment/context/infrastructure-spec.md"
        - ".augment/context/scope-spec.md"
      files_created:
        - "package.json"
        - "tsconfig.json"
        - "src/"
        - "tests/"
      parallel_safe: false
      
    - id: "setup-002"
      name: "Configure Development Environment"
      description: "Setup linting, formatting, testing framework, and development tools"
      type: "setup"
      estimated_hours: 1.5
      dependencies: ["setup-001"]
      context_references:
        - ".augment/context/infrastructure-spec.md"
      files_modified:
        - "package.json"
        - ".eslintrc.js"
        - "jest.config.js"
      parallel_safe: false
```

#### 2. Database & Models Tasks
```yaml
# Data layer tasks - can run in parallel after setup
database_tasks:
  priority: high
  parallel_safe: true  # Different entities can be implemented in parallel
  dependencies: ["setup-001", "setup-002"]
  
  tasks:
    - id: "db-001"
      name: "Setup Database Connection"
      description: "Configure database connection, migrations, and connection pooling"
      type: "database"
      estimated_hours: 2
      context_references:
        - ".augment/context/database-spec.md"
        - ".augment/context/infrastructure-spec.md"
      files_created:
        - "src/database/connection.ts"
        - "src/database/migrations/"
      parallel_safe: false  # Single connection setup
      
    - id: "db-002"
      name: "Implement User Model"
      description: "Create User entity with validation, relationships, and database operations"
      type: "model"
      estimated_hours: 3
      dependencies: ["db-001"]
      context_references:
        - ".augment/context/database-spec.md"
        - ".augment/context/security-spec.md"
      files_created:
        - "src/models/User.ts"
        - "src/models/interfaces/IUser.ts"
      parallel_safe: true  # Can run parallel with other models
      
    - id: "db-003"
      name: "Implement Task Model"
      description: "Create Task entity with validation, relationships, and database operations"
      type: "model"
      estimated_hours: 2.5
      dependencies: ["db-001"]
      context_references:
        - ".augment/context/database-spec.md"
      files_created:
        - "src/models/Task.ts"
        - "src/models/interfaces/ITask.ts"
      parallel_safe: true  # Can run parallel with other models
```

#### 3. API & Service Layer Tasks
```yaml
# Business logic tasks - can run in parallel after models
service_tasks:
  priority: high
  parallel_safe: true  # Different services can be implemented in parallel
  dependencies: ["db-002", "db-003"]  # Depends on models
  
  tasks:
    - id: "svc-001"
      name: "Implement User Service"
      description: "Create UserService with CRUD operations, validation, and business logic"
      type: "service"
      estimated_hours: 4
      dependencies: ["db-002"]
      context_references:
        - ".augment/context/api-spec.md"
        - ".augment/context/security-spec.md"
      files_created:
        - "src/services/UserService.ts"
        - "src/services/interfaces/IUserService.ts"
      parallel_safe: true  # Independent service
      
    - id: "svc-002"
      name: "Implement Task Service"
      description: "Create TaskService with CRUD operations, validation, and business logic"
      type: "service"
      estimated_hours: 3.5
      dependencies: ["db-003"]
      context_references:
        - ".augment/context/api-spec.md"
      files_created:
        - "src/services/TaskService.ts"
        - "src/services/interfaces/ITaskService.ts"
      parallel_safe: true  # Independent service
      
    - id: "api-001"
      name: "Implement User API Endpoints"
      description: "Create REST API endpoints for user operations with proper validation and error handling"
      type: "api"
      estimated_hours: 4
      dependencies: ["svc-001"]
      context_references:
        - ".augment/context/api-spec.md"
        - ".augment/context/security-spec.md"
      files_created:
        - "src/controllers/UserController.ts"
        - "src/routes/users.ts"
      parallel_safe: true  # Different endpoint groups
      
    - id: "api-002"
      name: "Implement Task API Endpoints"
      description: "Create REST API endpoints for task operations with proper validation and error handling"
      type: "api"
      estimated_hours: 3.5
      dependencies: ["svc-002"]
      context_references:
        - ".augment/context/api-spec.md"
      files_created:
        - "src/controllers/TaskController.ts"
        - "src/routes/tasks.ts"
      parallel_safe: true  # Different endpoint groups
```

#### 4. Authentication & Security Tasks
```yaml
# Security tasks - some parallel, some sequential
security_tasks:
  priority: critical
  parallel_safe: mixed  # Some parallel, some sequential
  dependencies: ["setup-002"]
  
  tasks:
    - id: "auth-001"
      name: "Implement JWT Authentication"
      description: "Create JWT token generation, validation, and refresh functionality"
      type: "security"
      estimated_hours: 4
      context_references:
        - ".augment/context/security-spec.md"
        - ".augment/context/api-spec.md"
      files_created:
        - "src/auth/JWTService.ts"
        - "src/auth/interfaces/IAuthService.ts"
      parallel_safe: false  # Core auth system
      
    - id: "auth-002"
      name: "Implement Authorization Middleware"
      description: "Create middleware for route protection and role-based access control"
      type: "security"
      estimated_hours: 3
      dependencies: ["auth-001"]
      context_references:
        - ".augment/context/security-spec.md"
      files_created:
        - "src/middleware/auth.ts"
        - "src/middleware/rbac.ts"
      parallel_safe: false  # Depends on core auth
      
    - id: "auth-003"
      name: "Implement Input Validation"
      description: "Create comprehensive input validation and sanitization for all endpoints"
      type: "security"
      estimated_hours: 2.5
      dependencies: ["setup-002"]
      context_references:
        - ".augment/context/security-spec.md"
        - ".augment/context/api-spec.md"
      files_created:
        - "src/validation/schemas.ts"
        - "src/validation/middleware.ts"
      parallel_safe: true  # Independent validation logic
```

#### 5. Testing Tasks
```yaml
# Testing tasks - highly parallel
testing_tasks:
  priority: high
  parallel_safe: true  # Most tests can run in parallel
  dependencies: []  # Can start early with TDD approach
  
  tasks:
    - id: "test-001"
      name: "Setup Testing Framework"
      description: "Configure Jest, testing utilities, and test database setup"
      type: "testing"
      estimated_hours: 2
      dependencies: ["setup-002"]
      context_references:
        - ".augment/context/testing-spec.md"
        - ".augment/context/infrastructure-spec.md"
      files_created:
        - "tests/setup.ts"
        - "tests/utils/testDb.ts"
      parallel_safe: false  # Core testing setup
      
    - id: "test-002"
      name: "Write User Model Tests"
      description: "Create comprehensive unit tests for User model validation and operations"
      type: "testing"
      estimated_hours: 2.5
      dependencies: ["test-001"]
      context_references:
        - ".augment/context/testing-spec.md"
        - ".augment/context/database-spec.md"
      files_created:
        - "tests/models/User.test.ts"
      parallel_safe: true  # Independent test suite
      
    - id: "test-003"
      name: "Write Task Model Tests"
      description: "Create comprehensive unit tests for Task model validation and operations"
      type: "testing"
      estimated_hours: 2
      dependencies: ["test-001"]
      context_references:
        - ".augment/context/testing-spec.md"
        - ".augment/context/database-spec.md"
      files_created:
        - "tests/models/Task.test.ts"
      parallel_safe: true  # Independent test suite
      
    - id: "test-004"
      name: "Write API Integration Tests"
      description: "Create end-to-end tests for all API endpoints with authentication"
      type: "testing"
      estimated_hours: 4
      dependencies: ["test-001"]
      context_references:
        - ".augment/context/testing-spec.md"
        - ".augment/context/api-spec.md"
      files_created:
        - "tests/integration/api.test.ts"
      parallel_safe: true  # Independent test suite
```

#### 6. Frontend Tasks (if applicable)
```yaml
# Frontend tasks - highly parallel
frontend_tasks:
  priority: medium
  parallel_safe: true  # Different components can be built in parallel
  dependencies: ["setup-001"]
  
  tasks:
    - id: "fe-001"
      name: "Setup Frontend Framework"
      description: "Configure React/Vue/Angular with routing, state management, and build tools"
      type: "frontend"
      estimated_hours: 3
      dependencies: ["setup-001"]
      context_references:
        - ".augment/context/infrastructure-spec.md"
        - ".augment/context/design-spec.md"
      files_created:
        - "frontend/src/App.tsx"
        - "frontend/src/router.ts"
      parallel_safe: false  # Core frontend setup
      
    - id: "fe-002"
      name: "Implement Authentication Components"
      description: "Create login, register, and authentication state management components"
      type: "frontend"
      estimated_hours: 4
      dependencies: ["fe-001"]
      context_references:
        - ".augment/context/design-spec.md"
        - ".augment/context/ux-spec.md"
        - ".augment/context/security-spec.md"
      files_created:
        - "frontend/src/components/Login.tsx"
        - "frontend/src/components/Register.tsx"
        - "frontend/src/hooks/useAuth.ts"
      parallel_safe: true  # Independent component
      
    - id: "fe-003"
      name: "Implement Task Management Components"
      description: "Create task list, task creation, and task management interface components"
      type: "frontend"
      estimated_hours: 5
      dependencies: ["fe-001"]
      context_references:
        - ".augment/context/design-spec.md"
        - ".augment/context/ux-spec.md"
      files_created:
        - "frontend/src/components/TaskList.tsx"
        - "frontend/src/components/TaskForm.tsx"
        - "frontend/src/hooks/useTasks.ts"
      parallel_safe: true  # Independent component
```

### Parallel Execution Strategy

#### Phase 1: Sequential Setup (No Parallelism)
```yaml
execution_order: sequential
tasks: ["setup-001", "setup-002", "db-001", "test-001", "auth-001"]
reason: "Foundation tasks that other tasks depend on"
estimated_time: 8 hours
agents_required: 1
```

#### Phase 2: Model & Service Development (High Parallelism)
```yaml
execution_order: parallel
parallel_groups:
  group_1: ["db-002", "test-002"]  # User model + tests
  group_2: ["db-003", "test-003"]  # Task model + tests  
  group_3: ["auth-003"]            # Input validation
reason: "Independent models and tests can be developed simultaneously"
estimated_time: 3 hours (parallel) vs 7.5 hours (sequential)
agents_required: 3
```

#### Phase 3: Service Layer (Medium Parallelism)
```yaml
execution_order: parallel
parallel_groups:
  group_1: ["svc-001"]  # User service
  group_2: ["svc-002"]  # Task service
dependencies: ["db-002", "db-003"]
reason: "Services depend on models but are independent of each other"
estimated_time: 4 hours (parallel) vs 7.5 hours (sequential)
agents_required: 2
```

#### Phase 4: API & Frontend (High Parallelism)
```yaml
execution_order: parallel
parallel_groups:
  group_1: ["api-001", "auth-002"]  # User API + auth middleware
  group_2: ["api-002"]              # Task API
  group_3: ["fe-002"]               # Auth components
  group_4: ["fe-003"]               # Task components
  group_5: ["test-004"]             # Integration tests
dependencies: ["svc-001", "svc-002", "fe-001"]
reason: "Different API endpoints and frontend components are independent"
estimated_time: 5 hours (parallel) vs 19 hours (sequential)
agents_required: 5
```

### Conflict Prevention Rules

#### File-Level Conflict Prevention
```yaml
conflict_rules:
  same_file_modification:
    rule: "Tasks that modify the same file cannot run in parallel"
    enforcement: "Check files_created and files_modified arrays"
    
  shared_dependencies:
    rule: "Tasks with shared file dependencies must be sequential"
    enforcement: "Analyze dependency chains for file conflicts"
    
  database_migrations:
    rule: "Database schema changes must be sequential"
    enforcement: "All migration tasks marked parallel_safe: false"
```

#### Resource-Level Conflict Prevention
```yaml
resource_conflicts:
  database_connection:
    rule: "Only one task can modify database schema at a time"
    affected_tasks: ["db-001", "migration tasks"]
    
  configuration_files:
    rule: "Core config files can only be modified by one task"
    affected_files: ["package.json", "tsconfig.json", "jest.config.js"]
    
  test_database:
    rule: "Test database setup must complete before parallel tests"
    enforcement: "test-001 must complete before other test tasks"
```

---

## AUGGIE Instructions

When generating development tasks:

1. **Analyze All Specifications**: Read every specification to understand the complete system
2. **Create Native AUGGIE Tasks**: Use add_tasks() format with proper structure
3. **Identify Dependencies**: Map out which tasks must complete before others can start
4. **Mark Parallel Safety**: Clearly identify which tasks can run simultaneously
5. **Prevent Conflicts**: Ensure no two parallel tasks modify the same files
6. **Include Context References**: Link each task to relevant specification documents
7. **Estimate Effort**: Provide realistic time estimates based on task complexity
8. **Plan Agent Coordination**: Organize tasks for optimal parallel execution

### Context Integration
- Reference all specifications for comprehensive task planning
- Include file paths and specific implementation details
- Plan for proper error handling and testing coverage
- Consider security and performance requirements in all tasks

### Output Requirements
- Complete task list in AUGGIE's native format using add_tasks()
- Clear dependency mapping with parallel execution opportunities
- Comprehensive context references for each task
- Conflict prevention through proper file and resource management
- Realistic effort estimates and agent coordination planning

This enhanced task generation ensures multiple AUGGIE agents can coordinate effectively during development while preventing conflicts and maximizing parallel execution efficiency.
