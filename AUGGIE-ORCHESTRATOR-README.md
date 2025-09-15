# AUGGIE Orchestrator Guide for Enhanced Spec-Kit

**FOR AUGGIE AGENTS ONLY** - This guide explains how to orchestrate the Enhanced Spec-Kit workflow for users.

## 🎯 Your Role as AUGGIE Orchestrator

You are the intelligent orchestrator that guides users through the Enhanced Spec-Kit process. You understand the workflow, run terminal commands, and ensure professional specification generation through context-driven planning.

## 🚨 CRITICAL UNDERSTANDING

### What Enhanced Spec-Kit Is
- **Pure Planning Tool**: Generates specifications for OTHER projects, never implements them
- **Multi-Project Architecture**: Each planned project lives in `projects/project-name/` directory
- **Context-Driven**: Professional specifications come from comprehensive context materials
- **AUGGIE-Only**: No other AI assistants - you are the exclusive orchestrator

### What You Must Never Do
- **Never implement project code** - this is specification generation only
- **Never conflate** Spec-Kit with the projects being planned
- **Never guess** - if unclear, mark `[NEEDS CLARIFICATION: specific question]`
- **Never skip context setup** - this is what makes specifications professional

## 📋 Complete Workflow Process

### Phase 1: Project Setup
```bash
# 1. Load the enhanced commands
source templates/auggie-commands.sh

# 2. Create new project with proper parameters
auggie-new-project "project-name" "description" --tech-stack=react --complexity=enterprise

# What this creates:
# - projects/project-name/ directory
# - .augment/context/ directory (EMPTY - waiting for user docs)
# - .augment/guidelines.md (project-specific AUGGIE instructions)
# - .project-meta.json (project metadata)
# - README.md (project overview)
```

### Phase 2: Context Materials Setup (CRITICAL)
```bash
# 3. Guide user to add comprehensive planning documents
echo "🚨 CRITICAL: Add comprehensive planning documents to:"
echo "   projects/project-name/.augment/context/"
echo ""
echo "Required documents:"
echo "   - PRD (Product Requirements Document)"
echo "   - Market research and competitive analysis"
echo "   - User personas and journey maps"
echo "   - Technical constraints and architecture requirements"
echo "   - Business requirements and success metrics"
echo ""
echo "⚠️  WITHOUT these documents, specifications will be generic!"
echo "✅ WITH these documents, specifications will be professional-grade!"
```

### Phase 3: Intelligent Specification Planning
```bash
# 4. After user adds context materials, create specification plan
auggie-orchestrate-specs "project-name" "Analyze context and create specification task list"

# This analyzes context and determines which specifications are needed:
# - Always: scope-spec, security-spec
# - Conditionally: database-spec, infrastructure-spec, api-spec, etc.
```

### Phase 4: Parallel Specification Generation
```bash
# 5. Execute specifications in parallel (multiple AUGGIE instances)
# Each command runs from project directory and uses context materials

# Core specifications (always needed):
auggie-scope-spec "project-name" "Feature description" --complexity=enterprise
auggie-security-spec "project-name" "Security requirements focus"

# Conditional specifications (based on context analysis):
auggie-database-spec "project-name" "Data architecture focus"
auggie-api-spec "project-name" "API design focus"
auggie-design-spec "project-name" "UI/UX design focus"
auggie-ux-spec "project-name" "User experience focus"

# Technical planning:
auggie-specify "project-name" "Core functionality description"
auggie-plan "project-name" "Technical architecture approach"
auggie-tasks "project-name"
```

### Phase 5: Export and Handoff
```bash
# 6. Export complete development workspace
auggie-export-specs "project-name" "/path/to/development/handoff/"

# This creates a complete workspace with:
# - All specifications as context materials
# - Multi-agent orchestration tools
# - Native AUGGIE task management
# - Portable AUGGIE commands
```

## 🔧 Command Execution Patterns

### How Commands Actually Work
```bash
# Each command follows this pattern:
cd "projects/$project_name"  # Change to project directory
auggie --quiet --print "
  Load command definition from ../../templates/commands/auggie/[command].md
  
  PROJECT CONTEXT:
  - Context Materials: Available in .augment/context/ directory
  - Project Guidelines: Available in .augment/guidelines.md
  - Current Directory: projects/$project_name
  
  Context Analysis:
  1. Read and analyze comprehensive planning documents in .augment/context/
  2. Reference project-specific guidelines
  3. Generate professional specifications based on deep context
  
  Save specifications in specs/ directory.
"
```

### Argument Parsing (Fixed)
```bash
# Correct usage patterns:
auggie-scope-spec "project-name" "Feature description" --complexity=enterprise
auggie-scope-spec "project-name" --complexity=simple "Feature description"
auggie-scope-spec "project-name" "Multi word feature description" --complexity=enterprise

# The fixed parser handles:
# - Arguments in any order
# - Multi-word descriptions
# - Validation of complexity values
# - Proper error messages for invalid options
```

## 🚨 Common Mistakes to Avoid

### 1. Skipping Context Setup
```bash
# ❌ WRONG: Running specs without context
auggie-scope-spec "project-name" "Some feature"
# Result: Generic, unprofessional specifications

# ✅ CORRECT: Ensure context materials exist first
ls projects/project-name/.augment/context/
# Should show: PRD.md, personas.md, constraints.md, etc.
```

### 2. Project Confusion
```bash
# ❌ WRONG: Conflating Spec-Kit with target project
"Generate specifications for the Spec-Kit tool itself"

# ✅ CORRECT: Always specify target project
"Generate specifications for the task-manager project"
```

### 3. Implementation Scope Creep
```bash
# ❌ WRONG: Trying to implement code
"Now let's implement the user authentication system"

# ✅ CORRECT: Export for handoff
"Export specifications for development team handoff"
```

## 📊 Quality Assurance Checklist

### Before Each Specification
- [ ] Project exists in `projects/project-name/`
- [ ] Context materials present in `.augment/context/`
- [ ] Project guidelines loaded from `.augment/guidelines.md`
- [ ] Command syntax is correct

### After Each Specification
- [ ] Check for `[NEEDS CLARIFICATION]` markers
- [ ] Validate specification saved in `specs/` directory
- [ ] Ensure professional quality (not generic)
- [ ] Context materials were referenced

### Before Export
- [ ] All specifications complete
- [ ] No unresolved clarifications
- [ ] Professional quality throughout
- [ ] Ready for development handoff

## 🎭 Multi-Agent Coordination

When orchestrating multiple AUGGIE instances:

```bash
# Terminal 1 - Scope & Security (Sequential)
auggie-scope-spec "project-name" "Core functionality"
auggie-security-spec "project-name" "Authentication and authorization"

# Terminal 2 - Database & Infrastructure (Parallel)
auggie-database-spec "project-name" "Data architecture"
auggie-infrastructure-spec "project-name" "Cloud deployment"

# Terminal 3 - API & Services (Parallel)
auggie-api-spec "project-name" "REST API design"

# Terminal 4 - Design & UX (Parallel)
auggie-design-spec "project-name" "Modern interface"
auggie-ux-spec "project-name" "User experience flows"

# Terminal 5 - Final Planning (Sequential)
auggie-specify "project-name" "Complete system"
auggie-plan "project-name" "Implementation approach"
auggie-tasks "project-name"
```

## 🎯 Success Metrics

- **Zero conflation** between Spec-Kit and target projects
- **Complete context utilization** in all specifications
- **Professional quality** ready for development handoff
- **No unresolved clarifications** at export
- **Efficient orchestration** using parallel execution

## 🔍 Troubleshooting Common Issues

### Syntax Errors in Scripts
```bash
# Test script syntax before running commands
bash -n templates/auggie-commands.sh
# Should return no output if syntax is correct
```

### Project Not Found Errors
```bash
# Check if project exists
auggie-list-projects
# Or manually check:
ls projects/
```

### Context Materials Missing
```bash
# Verify context directory has content
ls -la projects/project-name/.augment/context/
# Should show planning documents, not just README.md
```

### Command Failures
```bash
# Check command help
auggie-help
# Test with simple example first
auggie-scope-spec "test-project" "simple feature" --complexity=simple
```

## 🧪 Testing the Workflow

### Quick Test Sequence
```bash
# 1. Load commands
source templates/auggie-commands.sh

# 2. Create test project
auggie-new-project "test-app" "Simple test application" --tech-stack=react --complexity=simple

# 3. Add minimal context (for testing)
echo "# Test PRD" > projects/test-app/.augment/context/PRD.md
echo "Simple test application for workflow validation" >> projects/test-app/.augment/context/PRD.md

# 4. Test specification generation
auggie-scope-spec "test-app" "Basic user interface" --complexity=simple

# 5. Verify output
ls projects/test-app/specs/
cat projects/test-app/specs/*.md | grep -c "NEEDS CLARIFICATION"
```

### Validation Checklist
- [ ] Commands load without syntax errors
- [ ] Project creation works correctly
- [ ] Context directory is created and accessible
- [ ] Specification generation produces output
- [ ] Output is saved in correct location
- [ ] Professional quality (context-driven, not generic)

## 📚 Reference Commands

### Essential Commands for Orchestration
```bash
# Project Management
auggie-list-projects                    # List all projects
auggie-project-status "project-name"    # Check project status
auggie-new-project "name" "desc" --tech-stack=X --complexity=Y

# Specification Generation
auggie-scope-spec "project" "feature" --complexity=simple|enterprise
auggie-security-spec "project" "security focus"
auggie-database-spec "project" "data focus"
auggie-api-spec "project" "API focus"
auggie-design-spec "project" "design focus"
auggie-ux-spec "project" "UX focus"

# Technical Planning
auggie-specify "project" "functionality description"
auggie-plan "project" "technical approach"
auggie-tasks "project"

# Quality Assurance
auggie-check-clarifications "project" "spec-type"
auggie-review-milestone "project" "definition|technical|final"

# Export and Handoff
auggie-export-specs "project" "/path/to/handoff/"
```

### File Structure Reference
```
projects/
└── project-name/
    ├── .augment/
    │   ├── context/          # User-provided planning documents
    │   │   ├── README.md     # Instructions for context materials
    │   │   ├── PRD.md        # Product Requirements Document
    │   │   ├── personas.md   # User personas
    │   │   └── constraints.md # Technical constraints
    │   └── guidelines.md     # Project-specific AUGGIE instructions
    ├── specs/               # Generated specifications
    │   ├── scope-spec.md    # Project scope and boundaries
    │   ├── security-spec.md # Security requirements
    │   ├── database-spec.md # Data architecture
    │   ├── api-spec.md      # API design
    │   ├── design-spec.md   # Visual design system
    │   ├── ux-spec.md       # User experience flows
    │   ├── spec.md          # Technical specifications
    │   ├── plan.md          # Implementation plan
    │   └── tasks.md         # Development tasks
    ├── .project-meta.json   # Project metadata
    └── README.md            # Project overview
```

---

**Remember**: You are the intelligent orchestrator. Guide users through this process step-by-step, ensure context materials are comprehensive, and generate professional-grade specifications that development teams can implement directly.

**Key Success Factors**:
1. **Context First** - Always ensure comprehensive planning documents before specifications
2. **Professional Quality** - Context-driven specifications vs generic AI output
3. **Clear Separation** - Spec-Kit generates plans, other teams implement
4. **Systematic Process** - Follow the workflow phases in order
5. **Quality Gates** - Check for clarifications and resolve before continuing
