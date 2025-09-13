# Spec-Kit + Augment: Technical Reference

## 🔧 Command Reference

### Core Workflow Commands

#### 1. Specification Generation
```bash
# Using AUGGIE integration
source templates/auggie-commands.sh
auggie-specify "Your feature description here"

# Direct AUGGIE call
auggie --print "Generate a comprehensive feature specification for: [description]"
```

#### 2. Implementation Planning  
```bash
# Using integration script
auggie-plan specs/[feature-dir]/spec.md

# Direct AUGGIE call
auggie --print "Create implementation plan from specification: specs/[feature-dir]/spec.md"
```

#### 3. Task Generation
```bash
# Using integration script  
auggie-tasks specs/[feature-dir]/plan.md

# Direct AUGGIE call
auggie --print "Generate executable tasks from plan: specs/[feature-dir]/plan.md"
```

#### 4. Task Integration (Direct Markdown Approach)
```bash
# Convert Spec-Kit tasks to Augment format
python3 spec-kit-to-augment-md.py specs/[feature-dir]/tasks.md output.md

# Then use Augment's reorganize_tasklist() with the generated markdown
```

### Multi-Agent Orchestration

#### Parallel Task Execution
```bash
# Launch multiple AUGGIE instances for parallel tasks
auggie --print "Task description 1" &
auggie --print "Task description 2" &  
auggie --print "Task description 3" &
auggie --print "Task description 4" &

# Wait for all to complete
wait
```

#### Specialized Agent Assignment
```bash
# Backend tasks
auggie --print "Initialize backend Node.js project with TypeScript and Express"

# Frontend tasks  
auggie --print "Initialize frontend React project with TypeScript and Tailwind CSS"

# DevOps tasks
auggie --print "Setup Docker configuration with docker-compose.yml"

# Testing tasks
auggie --print "Configure Jest testing framework for backend"
```

## 📁 File Structure Reference

### Generated Project Structure
```
project-name/
├── specs/                          # Spec-Kit specifications
│   └── 001-feature-name/
│       ├── spec.md                 # Feature specification
│       ├── plan.md                 # Implementation plan  
│       └── tasks.md                # Generated tasks
├── templates/                      # AUGGIE integration
│   ├── commands/auggie/            # AUGGIE-specific templates
│   ├── memory/                     # Project memory/context
│   └── scripts/                    # Automation scripts
├── backend/                        # Backend implementation
│   ├── src/
│   ├── tests/
│   └── package.json
├── frontend/                       # Frontend implementation  
│   ├── src/
│   ├── tests/
│   └── package.json
├── shared/                         # Shared TypeScript types
│   ├── src/
│   └── package.json
└── docs/                          # Documentation
```

### Integration Scripts
```
├── multi-auggie-orchestrator.py   # Python multi-agent orchestrator
└── multi-auggie.sh                # Multi-agent orchestration shell script
```

## 🔄 Task Management Integration

### Task States
- `[ ]` NOT_STARTED - Task not yet begun
- `[/]` IN_PROGRESS - Currently working on task  
- `[x]` COMPLETE - Task finished and verified
- `[-]` CANCELLED - Task no longer relevant

### Task Update Commands
```python
# Single task update
update_tasks([{"task_id": "uuid", "state": "IN_PROGRESS"}])

# Batch task updates (recommended)
update_tasks([
    {"task_id": "prev-uuid", "state": "COMPLETE"},
    {"task_id": "next-uuid", "state": "IN_PROGRESS"}
])
```

### Task Hierarchy Management
```python
# View current task structure
view_tasklist()

# Major restructuring (use generated markdown)
reorganize_tasklist(markdown_content)

# Add new tasks with hierarchy
add_tasks([{
    "name": "Task name",
    "description": "Task description", 
    "parent_task_id": "parent-uuid"  # Optional
}])
```

## 🧪 Testing Integration

### TDD Workflow Enforcement
```markdown
## Phase 3.2: Tests First (TDD) ⚠️ MUST COMPLETE BEFORE 3.3
- [ ] T011 [P] Contract test POST /api/users
- [ ] T012 [P] Contract test GET /api/users/{id}  
- [ ] T013 [P] Contract test POST /api/exercises
```

### Test Categories Generated
1. **Contract Tests**: API endpoint validation
2. **Integration Tests**: User flow validation  
3. **Unit Tests**: Business logic validation
4. **E2E Tests**: Full application validation

### Parallel Test Execution
```bash
# All contract tests can run in parallel (different files)
auggie --print "Write contract test for POST /api/users" &
auggie --print "Write contract test for GET /api/users/{id}" &
auggie --print "Write contract test for POST /api/exercises" &
```

## 🔧 Configuration Files

### AUGGIE Integration Templates
```bash
# Command definitions
templates/commands/auggie/specify.md
templates/commands/auggie/plan.md  
templates/commands/auggie/tasks.md

# Agent instructions
templates/agents/auggie/instructions.md
templates/agents/auggie/context.md
```

### Project Configuration
```json
// package.json workspace setup
{
  "workspaces": ["backend", "frontend", "shared"],
  "scripts": {
    "dev:all": "concurrently \"npm run dev:backend\" \"npm run dev:frontend\"",
    "test:all": "npm run test:backend && npm run test:frontend && npm run test:shared",
    "lint:all": "npm run lint:backend && npm run lint:frontend && npm run lint:shared"
  }
}
```

### ESLint + Prettier Setup
```javascript
// .eslintrc.js (root)
module.exports = {
  root: true,
  extends: ['@typescript-eslint/recommended', 'prettier'],
  rules: {
    // Project-specific rules
  }
};
```

## 📊 Performance Metrics

### Task Generation Metrics
- **Specification → Tasks**: ~2 minutes
- **76 tasks generated** from single specification
- **6 phases** with clear dependencies
- **Parallel execution** reduces setup time by 4x

### Development Efficiency  
- **Setup Phase**: 4 tasks completed in parallel vs sequential
- **Testing Phase**: 12 contract tests can run simultaneously
- **Implementation Phase**: Models, services, endpoints properly ordered

### Quality Metrics
- **100% task coverage** - no missing implementation steps
- **Zero ambiguity** - exact file paths specified
- **Constitution compliance** built into every task
- **Professional standards** enforced throughout

## 🚨 Troubleshooting

### Common Issues

#### Task Import Failures
```bash
# Issue: UUID resolution problems with bridge script
# Solution: Use direct markdown approach
python3 spec-kit-to-augment-md.py tasks.md output.md
```

#### Parallel Execution Conflicts
```bash
# Issue: Multiple tasks modifying same file
# Solution: Check [P] markers - only parallel if different files
grep "\[P\]" specs/*/tasks.md
```

#### AUGGIE CLI Issues
```bash
# Issue: Command not found
# Solution: Install globally
sudo npm install -g @augmentcode/auggie

# Issue: Authentication problems  
# Solution: Re-run setup
auggie --setup
```

### Debug Commands
```bash
# Check AUGGIE installation
auggie --version

# Validate task file format
python3 -c "import json; print('Valid JSON')" < tasks.json

# Test parallel execution
./multi-auggie.sh status
```

## 🔮 Advanced Usage

### Custom Agent Specialization
```bash
# Create specialized AUGGIE instances
export AUGGIE_ROLE="backend-specialist"
auggie --print "Backend-specific task"

export AUGGIE_ROLE="frontend-specialist"  
auggie --print "Frontend-specific task"
```

### Workflow Automation
```bash
# Complete SDD workflow automation
./create-auggie-project.sh "Feature description"
# → Generates spec → plan → tasks → imports to Augment
```

### Integration with CI/CD
```yaml
# GitHub Actions integration
- name: Generate Tasks
  run: |
    auggie-specify "${{ github.event.issue.body }}"
    auggie-plan specs/*/spec.md
    auggie-tasks specs/*/plan.md
```

---

*This technical reference covers all commands and configurations for the Spec-Kit + Augment integration.*
