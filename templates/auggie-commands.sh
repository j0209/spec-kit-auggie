#!/bin/bash
# Enhanced AUGGIE CLI Integration for Complete Spec-Driven Development
# Source this file to enable comprehensive AUGGIE commands for design, UX, and development

# Check if AUGGIE CLI is available
if ! command -v auggie &> /dev/null; then
    echo "Error: AUGGIE CLI not found. Install with: npm install -g @augmentcode/auggie"
    return 1
fi

# Get the repository root directory
get_repo_root() {
    git rev-parse --show-toplevel 2>/dev/null || pwd
}

# Get projects directory
get_projects_dir() {
    local repo_root=$(get_repo_root)
    echo "$repo_root/projects"
}

# Validate project exists
validate_project() {
    local project_name="$1"
    local projects_dir=$(get_projects_dir)

    if [[ -z "$project_name" ]]; then
        echo "❌ Error: Project name is required"
        return 1
    fi

    if [[ ! -d "$projects_dir/$project_name" ]]; then
        echo "❌ Error: Project '$project_name' does not exist"
        echo "💡 Available projects:"
        auggie-list-projects
        echo "💡 Create new project with: auggie-new-project \"$project_name\" \"description\""
        return 1
    fi

    return 0
}

# Get project directory
get_project_dir() {
    local project_name="$1"
    local projects_dir=$(get_projects_dir)
    echo "$projects_dir/$project_name"
}

# ============================================================================
# PROJECT MANAGEMENT COMMANDS
# ============================================================================

# AUGGIE-New-Project: Create a new project with AUGGIE workspace structure
auggie-new-project() {
    if [ $# -lt 2 ]; then
        echo "Usage: auggie-new-project \"project-name\" \"description\" [--tech-stack=react|node|python|etc] [--complexity=simple|enterprise]"
        echo "Example: auggie-new-project \"task-manager\" \"A collaborative task management application\" --tech-stack=react --complexity=enterprise"
        return 1
    fi

    local project_name="$1"
    local description="$2"
    local tech_stack=""
    local complexity="simple"

    # Parse optional arguments
    shift 2
    while [[ $# -gt 0 ]]; do
        case $1 in
            --tech-stack=*)
                tech_stack="${1#*=}"
                shift
                ;;
            --complexity=*)
                complexity="${1#*=}"
                shift
                ;;
            *)
                echo "Unknown option: $1"
                return 1
                ;;
        esac
    done

    local projects_dir=$(get_projects_dir)
    local project_dir="$projects_dir/$project_name"

    # Check if project already exists
    if [[ -d "$project_dir" ]]; then
        echo "❌ Error: Project '$project_name' already exists"
        return 1
    fi

    echo "🌱 Creating new project with AUGGIE workspace: $project_name"
    echo "📝 Description: $description"
    if [[ -n "$tech_stack" ]]; then
        echo "🛠️  Tech Stack: $tech_stack"
    fi
    echo "🔧 Complexity: $complexity"
    echo "📁 Location: $project_dir"
    echo ""

    # Create project structure with AUGGIE workspace
    mkdir -p "$project_dir"/{specs,docs,src,tests}
    mkdir -p "$project_dir/.augment"
    mkdir -p "$project_dir/.augment/context"

    # Create project README
    cat > "$project_dir/README.md" << EOF
# $project_name

$description

## Tech Stack
${tech_stack:-"To be determined"}

## Specifications

This project uses Spec-Driven Development. Specifications are located in the \`specs/\` directory.

## Getting Started

1. Create your first specification:
   \`\`\`bash
   auggie-specify "$project_name" "Your feature description"
   \`\`\`

2. Generate implementation plan:
   \`\`\`bash
   auggie-plan "$project_name" "Your technical approach"
   \`\`\`

3. Create tasks:
   \`\`\`bash
   auggie-tasks "$project_name"
   \`\`\`

## Project Status

- Created: $(date)
- Status: Planning
- Features: 0
EOF

    # Create project metadata with AUGGIE workspace info
    cat > "$project_dir/.project-meta.json" << EOF
{
  "name": "$project_name",
  "description": "$description",
  "tech_stack": "$tech_stack",
  "complexity": "$complexity",
  "created": "$(date -Iseconds)",
  "status": "planning",
  "features": [],
  "augment_workspace": ".augment",
  "spec_kit_version": "enhanced-project-specific"
}
EOF

    # Create project-specific AUGGIE guidelines
    cat > "$project_dir/.augment/guidelines.md" << EOF
# $project_name - Project Planning Guidelines

**Project**: $project_name
**Description**: $description
**Tech Stack**: $tech_stack
**Complexity**: $complexity
**Created**: $(date)

## Project Context

This is the AUGGIE workspace for planning the '$project_name' project.

### Context Materials
- All comprehensive planning documents should be placed in \`.augment/context/\`
- Reference PRDs, market research, user personas, technical constraints
- Use these materials for informed specification generation

### Planning Focus
- **Implementation planning only** - not concept planning
- **Professional specifications** based on comprehensive input documents
- **Never vibe coding** - always reference context materials
- **Project-specific context** - never reference other projects

### Execution Context
- All AUGGIE commands should be executed FROM this project directory
- Use project-specific tasks and context materials
- Maintain isolation from other projects

### Workflow
1. Populate \`.augment/context/\` with comprehensive planning documents
2. Use auggie-scope-spec for pragmatic scope definition
3. Use auggie-design-spec for visual design systems
4. Use auggie-ux-spec for user experience flows
5. Use auggie-specify for technical specifications
6. Use auggie-plan for implementation planning
7. Use auggie-tasks for detailed task breakdown
8. Export complete specification package for development handoff

---
*Auto-generated for project: $project_name*
EOF

    # Create initial context README
    cat > "$project_dir/.augment/context/README.md" << EOF
# Context Materials for $project_name

This directory should contain comprehensive planning documents that inform specification generation:

## Expected Documents
- **PRD (Product Requirements Document)**: Detailed product requirements and business objectives
- **Market Research**: Competitive analysis and market positioning
- **User Personas**: Target user profiles and journey maps
- **Technical Constraints**: Architecture requirements and technical limitations
- **Business Requirements**: Success metrics and business objectives

## Usage
These documents will be automatically referenced by AUGGIE when generating specifications.
Ensure all materials are comprehensive and well-structured for optimal specification quality.

## Instructions
1. Add your comprehensive planning documents to this directory
2. Use clear, descriptive filenames (e.g., \`prd.md\`, \`user-personas.md\`, \`technical-constraints.md\`)
3. Ensure documents are in markdown format for optimal AUGGIE analysis
4. These materials will be used for professional implementation planning

---
*Context directory for project: $project_name*
EOF

    echo "✅ Project '$project_name' created successfully with AUGGIE workspace!"
    echo ""
    echo "📋 Next Steps:"
    echo "   1. 📚 Add comprehensive planning documents to: $project_dir/.augment/context/"
    echo "      - PRD, market research, user personas, technical constraints, etc."
    echo "   2. 🎯 Request intelligent specification planning:"
    echo "      - \"Analyze context and create specification task list for $project_name\""
    echo "   3. 🚀 Execute parallel specification generation using shared task list"
    echo ""
    echo "💡 The orchestrator will analyze your context and determine which specifications are needed."
}

# AUGGIE-List-Projects: List all projects
auggie-list-projects() {
    local projects_dir=$(get_projects_dir)

    if [[ ! -d "$projects_dir" ]]; then
        echo "📁 No projects directory found. Create your first project with:"
        echo "   auggie-new-project \"project-name\" \"description\""
        return 0
    fi

    echo "📋 Available Projects:"
    echo ""

    local found_projects=false
    for project_path in "$projects_dir"/*; do
        if [[ -d "$project_path" ]]; then
            found_projects=true
            local project_name=$(basename "$project_path")
            local meta_file="$project_path/.project-meta.json"

            if [[ -f "$meta_file" ]]; then
                local description=$(jq -r '.description // "No description"' "$meta_file" 2>/dev/null || echo "No description")
                local tech_stack=$(jq -r '.tech_stack // "Not specified"' "$meta_file" 2>/dev/null || echo "Not specified")
                local status=$(jq -r '.status // "unknown"' "$meta_file" 2>/dev/null || echo "unknown")

                echo "  🎯 $project_name"
                echo "     📝 $description"
                echo "     🛠️  Tech: $tech_stack"
                echo "     📊 Status: $status"
                echo ""
            else
                echo "  📁 $project_name (legacy project - no metadata)"
                echo ""
            fi
        fi
    done

    if [[ "$found_projects" == false ]]; then
        echo "   No projects found. Create your first project with:"
        echo "   auggie-new-project \"project-name\" \"description\""
    fi
}

# AUGGIE-Project-Status: Show detailed status of a specific project
auggie-project-status() {
    if [ $# -eq 0 ]; then
        echo "Usage: auggie-project-status \"project-name\""
        echo "Example: auggie-project-status \"task-manager\""
        return 1
    fi

    local project_name="$1"

    if ! validate_project "$project_name"; then
        return 1
    fi

    local project_dir=$(get_project_dir "$project_name")
    local meta_file="$project_dir/.project-meta.json"

    echo "📊 Project Status: $project_name"
    echo "=================================="
    echo ""

    if [[ -f "$meta_file" ]]; then
        local description=$(jq -r '.description' "$meta_file" 2>/dev/null)
        local tech_stack=$(jq -r '.tech_stack' "$meta_file" 2>/dev/null)
        local created=$(jq -r '.created' "$meta_file" 2>/dev/null)
        local status=$(jq -r '.status' "$meta_file" 2>/dev/null)

        echo "📝 Description: $description"
        echo "🛠️  Tech Stack: $tech_stack"
        echo "📅 Created: $created"
        echo "📊 Status: $status"
        echo ""
    fi

    # Count specifications
    local specs_count=$(find "$project_dir/specs" -name "spec.md" 2>/dev/null | wc -l)
    local plans_count=$(find "$project_dir/specs" -name "plan.md" 2>/dev/null | wc -l)
    local tasks_count=$(find "$project_dir/specs" -name "tasks.md" 2>/dev/null | wc -l)

    echo "📋 Specifications: $specs_count"
    echo "🏗️  Plans: $plans_count"
    echo "✅ Task Lists: $tasks_count"
    echo ""

    # Show recent specifications
    if [[ $specs_count -gt 0 ]]; then
        echo "🔍 Recent Specifications:"
        find "$project_dir/specs" -name "spec.md" -exec dirname {} \; | sort | tail -3 | while read spec_dir; do
            local feature_name=$(basename "$spec_dir")
            echo "   • $feature_name"
        done
        echo ""
    fi

    echo "🚀 Available commands for this project:"
    echo "   auggie-specify \"$project_name\" \"feature description\""
    echo "   auggie-plan \"$project_name\" \"technical details\""
    echo "   auggie-tasks \"$project_name\""
}

# ============================================================================
# SPECIFICATION COMMANDS (Updated for Multi-Project)
# ============================================================================

# AUGGIE-Specify: Create specifications using AUGGIE CLI
auggie-specify() {
    if [ $# -lt 2 ]; then
        echo "Usage: auggie-specify \"project-name\" \"Feature description\""
        echo "Example: auggie-specify \"task-manager\" \"Add user authentication with JWT tokens\""
        echo ""
        echo "💡 Available projects:"
        auggie-list-projects
        return 1
    fi

    local project_name="$1"
    local feature_description="${*:2}"

    if ! validate_project "$project_name"; then
        return 1
    fi

    local repo_root=$(get_repo_root)
    local project_dir=$(get_project_dir "$project_name")

    echo "🌱 Starting Spec-Driven Development with AUGGIE..."
    echo "🎯 Project: $project_name"
    echo "📝 Feature: $feature_description"
    echo ""

    # Execute AUGGIE from project directory to use project-specific context
    cd "$project_dir" && auggie --quiet --print "
    I need you to execute the /specify command for Spec-Driven Development.

    Load the command definition from ../../templates/commands/auggie/specify.md and follow its instructions exactly.

    PROJECT CONTEXT:
    - Project Name: $project_name
    - Project Directory: $project_dir (current working directory)
    - Feature Description: $feature_description
    - Context Materials: Available in .augment/context/ directory
    - Project Guidelines: Available in .augment/guidelines.md

    IMPORTANT: This specification is for the '$project_name' project, NOT for the Spec-Kit tool itself.

    Context Analysis:
    1. Read and analyze all comprehensive planning documents in .augment/context/
    2. Reference PRDs, market research, user personas, technical constraints
    3. Use project-specific guidelines from .augment/guidelines.md
    4. Focus on implementation planning based on comprehensive input documents
    5. Never use vibe coding - always reference context materials

    Generate professional specifications based on deep context analysis.
    Save specifications in specs/ directory structure.

    Execute the specify command now.
    "

    # Check for clarifications after spec creation
    auggie-check-clarifications "$project_name" "scope"
}

# AUGGIE-Plan: Create implementation plans using AUGGIE CLI
auggie-plan() {
    if [ $# -lt 2 ]; then
        echo "Usage: auggie-plan \"project-name\" \"Technical implementation details\""
        echo "Example: auggie-plan \"task-manager\" \"Use Express.js with PostgreSQL database and JWT authentication\""
        echo ""
        echo "💡 Available projects:"
        auggie-list-projects
        return 1
    fi

    local project_name="$1"
    local implementation_details="${*:2}"

    if ! validate_project "$project_name"; then
        return 1
    fi

    local repo_root=$(get_repo_root)
    local project_dir=$(get_project_dir "$project_name")

    echo "🏗️  Creating implementation plan with AUGGIE..."
    echo "🎯 Project: $project_name"
    echo "⚙️  Details: $implementation_details"
    echo ""

    # Execute AUGGIE from project directory to use project-specific context
    cd "$project_dir" && auggie --quiet --print "
    I need you to execute the /plan command for Spec-Driven Development.

    Load the command definition from ../../templates/commands/auggie/plan.md and follow its instructions exactly.

    PROJECT CONTEXT:
    - Project Name: $project_name
    - Project Directory: $project_dir (current working directory)
    - Implementation Details: $implementation_details
    - Context Materials: Available in .augment/context/ directory
    - Project Guidelines: Available in .augment/guidelines.md

    IMPORTANT: This plan is for the '$project_name' project, NOT for the Spec-Kit tool itself.

    Context Analysis:
    1. Read and analyze all comprehensive planning documents in .augment/context/
    2. Reference existing specifications in specs/ directory
    3. Use project-specific guidelines from .augment/guidelines.md
    4. Apply technical constraints from context materials
    5. Generate realistic implementation plans based on comprehensive input

    Create all required artifacts in specs/ directory structure.

    Execute the plan command now.
    "

    # Check for clarifications after plan creation
    auggie-check-clarifications "$project_name" "technical"
}

# AUGGIE-Tasks: Generate development tasks in native AUGGIE format with parallel execution support
auggie-tasks() {
    if [ $# -eq 0 ]; then
        echo "Usage: auggie-tasks \"project-name\" [additional-context]"
        echo "Example: auggie-tasks \"task-manager\" \"Focus on backend API first\""
        echo ""
        echo "💡 Available projects:"
        auggie-list-projects
        return 1
    fi

    local project_name="$1"
    local context_info="${*:2}"

    if ! validate_project "$project_name"; then
        return 1
    fi

    local repo_root=$(get_repo_root)
    local project_dir=$(get_project_dir "$project_name")

    echo "🚀 Generating development tasks in native AUGGIE format..."
    echo "🎯 Project: $project_name"
    if [ -n "$context_info" ]; then
        echo "📌 Context: $context_info"
    fi
    echo "⚡ Features: Parallel execution support, dependency management, conflict prevention"
    echo ""

    # Execute AUGGIE from project directory to use project-specific context
    cd "$project_dir" && auggie --quiet --print "
    I need you to generate comprehensive development tasks using the enhanced task generation system.

    Load the command definition from ../../templates/commands/auggie/enhanced-tasks.md and follow its instructions exactly.

    PROJECT CONTEXT:
    - Project Name: $project_name
    - Project Directory: $project_dir (current working directory)
    - Development Focus: $context_info
    - Context Materials: Available in .augment/context/ directory
    - Project Guidelines: Available in .augment/guidelines.md
    - All Specifications: Available in specs/ directory

    CRITICAL REQUIREMENTS:
    1. **Generate Native AUGGIE Tasks**: Use add_tasks() format, NOT markdown checklists
    2. **Parallel Execution Support**: Mark tasks that can run simultaneously without conflicts
    3. **Dependency Management**: Create proper task dependencies to prevent conflicts
    4. **Context Integration**: Reference specific specification documents in each task
    5. **Conflict Prevention**: Ensure no two parallel tasks modify the same files

    ENHANCED TASK GENERATION PROCESS:
    1. **Analyze All Specifications**: Read every spec in specs/ directory for complete understanding
    2. **Extract Technology Stack**: Determine languages, frameworks, and architecture from specs
    3. **Identify Task Categories**: Setup, Database, API, Frontend, Testing, Security, etc.
    4. **Plan Dependencies**: Map which tasks must complete before others can start
    5. **Mark Parallel Safety**: Identify tasks that can run simultaneously without file conflicts
    6. **Create Native Format**: Generate tasks using AUGGIE's add_tasks() command format
    7. **Include Context References**: Link each task to relevant specification documents
    8. **Estimate Effort**: Provide realistic time estimates based on complexity

    PARALLEL EXECUTION STRATEGY:
    - **Phase 1**: Sequential setup tasks (project init, core config)
    - **Phase 2**: Parallel model/entity tasks (different files, no conflicts)
    - **Phase 3**: Parallel service layer tasks (independent business logic)
    - **Phase 4**: Parallel API/frontend tasks (different endpoints/components)
    - **Phase 5**: Parallel testing tasks (independent test suites)

    CONFLICT PREVENTION RULES:
    - Tasks modifying the same file: MUST be sequential (no parallel)
    - Tasks modifying different files: CAN be parallel
    - Database schema changes: MUST be sequential
    - Configuration file changes: MUST be sequential
    - Independent components/services: CAN be parallel

    OUTPUT FORMAT:
    Generate tasks using AUGGIE's native task management system:

    Use add_tasks() with this structure for each task:
    {
      \"name\": \"Task Name\",
      \"description\": \"Detailed description with file paths and context references\",
      \"state\": \"NOT_STARTED\",
      \"parent_task_id\": \"parent-id\" (if subtask),
      \"after_task_id\": \"dependency-id\" (if sequential dependency)
    }

    IMPORTANT:
    - Create a complete development task list that enables multiple AUGGIE agents to work in parallel
    - Ensure tasks have sufficient detail and context for autonomous execution
    - Include specific file paths, context references, and implementation guidance
    - Plan for optimal parallel execution while preventing conflicts

    Execute the enhanced task generation now.
    "

    # Check for clarifications after task creation
    auggie-check-clarifications "$project_name" "development-tasks"

    echo ""
    echo "✅ Enhanced development tasks generated successfully!"
    echo ""
    echo "🎯 Task Features:"
    echo "   ✅ Native AUGGIE format with add_tasks() commands"
    echo "   ✅ Parallel execution support with conflict prevention"
    echo "   ✅ Comprehensive dependency management"
    echo "   ✅ Context references to all specifications"
    echo "   ✅ Realistic effort estimates and file-level planning"
    echo ""
    echo "🚀 Multiple AUGGIE agents can now coordinate development using:"
    echo "   📋 auggie view_tasklist  # View all development tasks"
    echo "   ⚡ auggie update_tasks   # Coordinate parallel execution"
    echo "   🎯 Context-aware task execution with specification references"
    echo ""
    echo "📁 Development workspace ready for export and AUGGIE coordination!"
}

# AUGGIE-Create-Dev-Workspace: Generate complete .augment/ workspace for development project
auggie-create-dev-workspace() {
    if [ $# -lt 2 ]; then
        echo "Usage: auggie-create-dev-workspace \"project-name\" \"target-directory\""
        echo "Example: auggie-create-dev-workspace \"task-manager\" \"/path/to/development/task-manager\""
        echo ""
        echo "💡 Available projects:"
        auggie-list-projects
        return 1
    fi

    local project_name="$1"
    local target_dir="$2"

    if ! validate_project "$project_name"; then
        return 1
    fi

    local repo_root=$(get_repo_root)
    local project_dir=$(get_project_dir "$project_name")

    echo "🏗️  Creating complete development workspace..."
    echo "🎯 Project: $project_name"
    echo "📁 Target: $target_dir"
    echo ""

    # Create target directory structure
    mkdir -p "$target_dir"
    mkdir -p "$target_dir/.augment"
    mkdir -p "$target_dir/.augment/context"
    mkdir -p "$target_dir/src"
    mkdir -p "$target_dir/tests"
    mkdir -p "$target_dir/docs"

    echo "📋 Copying specifications as context materials..."

    # Copy all specifications as context materials for development AUGGIEs
    if [ -d "$project_dir/specs" ]; then
        cp -r "$project_dir/specs"/* "$target_dir/.augment/context/" 2>/dev/null || true
    fi

    # Copy original context materials
    if [ -d "$project_dir/.augment/context" ]; then
        cp -r "$project_dir/.augment/context"/* "$target_dir/.augment/context/" 2>/dev/null || true
    fi

    # Create development-specific guidelines
    cat > "$target_dir/.augment/guidelines.md" << 'EOF'
# Development Project Guidelines

## Project Context
This is a development project created from comprehensive specifications generated by Spec-Kit.
All specifications and context materials are available in the `.augment/context/` directory.

## AUGGIE Development Coordination

### Task Management
- Use `auggie view_tasklist` to see all development tasks
- Use `auggie update_tasks` to coordinate with other AUGGIE agents
- Tasks are organized with proper dependencies and parallel execution support

### Context Materials
All specifications are available as context materials:
- `scope-spec.md` - Project scope and requirements
- `security-spec.md` - Security architecture and requirements
- `database-spec.md` - Database schema and data model
- `infrastructure-spec.md` - Deployment and infrastructure
- `monitoring-spec.md` - Monitoring and observability
- `api-spec.md` - API design and integration
- `testing-spec.md` - Testing strategy and requirements
- `operations-spec.md` - Operations and maintenance procedures

### Parallel Execution Guidelines
- **Setup Tasks**: Must be completed sequentially by one AUGGIE
- **Model Tasks**: Can be executed in parallel (different entities)
- **Service Tasks**: Can be executed in parallel (independent services)
- **API Tasks**: Can be executed in parallel (different endpoints)
- **Frontend Tasks**: Can be executed in parallel (different components)
- **Testing Tasks**: Can be executed in parallel (independent test suites)

### Conflict Prevention
- Never modify the same file simultaneously
- Check task dependencies before starting work
- Update task status to coordinate with other AUGGIEs
- Reference context materials for implementation guidance

### Quality Standards
- Follow TDD approach: write tests first
- Implement comprehensive error handling
- Include proper logging and monitoring
- Follow security best practices from specifications
- Maintain code quality and documentation standards

## Development Workflow
1. Review task list and dependencies
2. Claim tasks by updating status to IN_PROGRESS
3. Reference relevant context materials
4. Implement with proper testing
5. Update task status to COMPLETE
6. Coordinate with other AUGGIEs for dependent tasks
EOF

    # Create project README for development team
    cat > "$target_dir/README.md" << EOF
# $project_name - Development Project

This project was generated from comprehensive specifications created using Spec-Kit with AUGGIE integration.

## Quick Start

### For AUGGIE Agents
\`\`\`bash
# View all development tasks
auggie view_tasklist

# Start working on a task
auggie update_tasks --task-id="task-id" --state="IN_PROGRESS"

# View context materials
ls .augment/context/

# Complete a task
auggie update_tasks --task-id="task-id" --state="COMPLETE"
\`\`\`

### For Human Developers
\`\`\`bash
# Install dependencies (after setup tasks complete)
npm install

# Run tests
npm test

# Start development server
npm run dev
\`\`\`

## Project Structure
- \`.augment/\` - AUGGIE workspace with context materials and task management
- \`src/\` - Source code
- \`tests/\` - Test files
- \`docs/\` - Documentation

## Context Materials
All project specifications are available in \`.augment/context/\`:
- Complete scope, security, database, and API specifications
- Infrastructure and monitoring requirements
- Testing strategies and operational procedures

## Development Coordination
This project supports multiple AUGGIE agents working in parallel:
- Tasks are organized with proper dependencies
- Parallel execution is supported where safe
- Context materials provide comprehensive implementation guidance
- Task management prevents conflicts between agents

## Getting Started
1. Review the task list: \`auggie view_tasklist\`
2. Read relevant context materials in \`.augment/context/\`
3. Start with setup tasks (must be completed first)
4. Coordinate with other agents using task status updates
EOF

    echo "✅ Development workspace created successfully!"
    echo ""
    echo "📁 Workspace Structure:"
    echo "   $target_dir/"
    echo "   ├── .augment/"
    echo "   │   ├── context/          # All specifications as context materials"
    echo "   │   ├── tasks.json        # Native AUGGIE task management (created by auggie-tasks)"
    echo "   │   └── guidelines.md     # Development-specific guidelines"
    echo "   ├── src/                  # Source code directory"
    echo "   ├── tests/                # Test files directory"
    echo "   ├── docs/                 # Documentation directory"
    echo "   └── README.md             # Project setup instructions"
    echo ""
    echo "🎯 Next Steps:"
    echo "   1. cd \"$target_dir\""
    echo "   2. Run auggie-tasks to generate native AUGGIE task list"
    echo "   3. Deploy multiple AUGGIE agents for parallel development"
    echo "   4. Use 'auggie view_tasklist' to coordinate development"
    echo ""
    echo "🚀 Development workspace ready for AUGGIE coordination!"
}



# AUGGIE-Task-Sync: Sync task completion status between systems
auggie-task-sync() {
    local repo_root=$(get_repo_root)
    local tasks_file="$1"

    if [[ -z "$tasks_file" ]]; then
        tasks_file=$(find "$repo_root/specs" -name "tasks.md" -type f | head -1)
        if [[ -z "$tasks_file" ]]; then
            echo "❌ No tasks.md file found."
            return 1
        fi
    fi

    if [[ ! -f "$repo_root/auggie-task-integration.sh" ]]; then
        echo "❌ Task integration script not found."
        return 1
    fi

    echo "🔄 Syncing task status between Spec-Kit and Augment..."
    "$repo_root/auggie-task-integration.sh" sync "$tasks_file"
}

# AUGGIE-Status: Check the current SDD status
auggie-status() {
    local repo_root=$(get_repo_root)
    
    echo "📊 Checking Spec-Driven Development status..."
    echo ""
    
    cd "$repo_root" && auggie --print --quiet "
    Analyze the current state of this Spec-Driven Development project.
    
    Check for:
    1. Current branch and any active feature development
    2. Existing specifications in specs/ directory
    3. Implementation plans and their completion status
    4. Generated tasks and their progress
    5. Constitution compliance
    
    Provide a concise status report with next recommended actions.
    "
}

# AUGGIE-Help: Show available commands
auggie-help() {
    echo "🚀 Enhanced AUGGIE CLI Integration for Multi-Project Spec-Driven Development"
    echo ""
    echo "📁 Project Management Commands:"
    echo "  auggie-new-project \"name\" \"description\" [--tech-stack=react] - Create new project"
    echo "  auggie-list-projects                                           - List all projects"
    echo "  auggie-project-status \"project-name\"                          - Show project status"
    echo ""
    echo "📋 Core Specification Commands (require project context):"
    echo "  auggie-specify \"project-name\" \"Feature description\"         - Create technical specifications"
    echo "  auggie-plan \"project-name\" \"Implementation details\"         - Create implementation plans"
    echo "  auggie-tasks \"project-name\" [context]                        - Generate task breakdowns"
    echo ""
    echo "🎨 Design & UX Commands (require project context):"
    echo "  auggie-design-spec \"project-name\" \"Design description\"      - Create visual design specifications"
    echo "  auggie-ux-spec \"project-name\" \"UX flow description\"         - Create user experience specifications"
    echo "  auggie-component-design \"project-name\" \"Component desc\"     - Create component design specifications"
    echo ""
    echo "🛡️  Security Commands (require project context):"
    echo "  auggie-security-spec \"project-name\" \"Security focus\"        - Create comprehensive security specifications"
    echo ""
    echo "🗄️  Database Commands (require project context):"
    echo "  auggie-database-spec \"project-name\" \"Database focus\"        - Create comprehensive database specifications"
    echo ""
    echo "🏗️  Infrastructure Commands (require project context):"
    echo "  auggie-infrastructure-spec \"project-name\" \"Infrastructure focus\" - Create deployment and infrastructure specifications"
    echo ""
    echo "📊 Monitoring Commands (require project context):"
    echo "  auggie-monitoring-spec \"project-name\" \"Monitoring focus\"    - Create monitoring and observability specifications"
    echo ""
    echo "🔌 API Commands (require project context):"
    echo "  auggie-api-spec \"project-name\" \"API focus\"                  - Create API and integration specifications"
    echo ""
    echo "🧪 Testing Commands (require project context):"
    echo "  auggie-testing-spec \"project-name\" \"Testing focus\"          - Create comprehensive testing strategy specifications"
    echo ""
    echo "⚙️  Operations Commands (require project context):"
    echo "  auggie-operations-spec \"project-name\" \"Operations focus\"    - Create operations and maintenance specifications"
    echo ""
    echo "🎭 Orchestration Commands:"
    echo "  auggie-orchestrate \"project-name\" [context]                   - Create intelligent specification task list"
    echo ""
    echo "🚀 Development Task Commands:"
    echo "  auggie-tasks \"project-name\" [context]                         - Generate native AUGGIE development tasks with parallel execution"
    echo "  auggie-create-dev-workspace \"project-name\" \"/path/to/dev/\"   - Create complete development workspace"
    echo "  auggie-export-specs \"project-name\" \"/path/to/export/\"        - Export ready-to-use development workspace"
    echo ""
    echo "🎯 Scope Management Commands:"
    echo "  auggie-scope-spec \"project-name\" \"Feature\" [--complexity=simple|enterprise] - Create pragmatic scope specifications"
    echo ""
    echo "🔧 Task Management Commands:"
    echo "  auggie-status                                                  - Check project SDD status"
    echo ""
    echo "✅ Approval & Review Commands:"
    echo "  auggie-check-clarifications \"project-name\" \"spec-type\"       - Check for [NEEDS CLARIFICATION] items"
    echo "  auggie-approve-and-continue \"project-name\"                     - Approve after resolving clarifications"
    echo "  auggie-review-milestone \"project-name\" \"milestone\"           - Review milestone (definition/technical/final)"
    echo "  auggie-approve-milestone \"project-name\" \"milestone\"          - Approve milestone after review"
    echo ""
    echo "ℹ️  Utility Commands:"
    echo "  auggie-help                                                    - Show this help"
    echo "  auggie-export-specs \"project-name\" \"/path/to/export/\"        - Export complete specification package"

    echo ""
    echo "🎭 Enhanced Orchestration Workflow (with Intelligent Planning & Parallel Execution):"
    echo ""
    echo "📋 Phase 1: Project Setup & Context (Orchestrator)"
    echo "  1. auggie-new-project \"enterprise-saas\" \"Multi-tenant SaaS platform\" --tech-stack=react --complexity=enterprise"
    echo "     → Creates project structure with .augment/context/ directory and shared task workspace"
    echo "  2. Add comprehensive planning documents to projects/enterprise-saas/.augment/context/"
    echo "     → PRD, market research, user personas, technical constraints, compliance requirements"
    echo ""
    echo "🎯 Phase 2: Intelligent Specification Planning (Orchestrator)"
    echo "  3. auggie-orchestrate \"enterprise-saas\" \"Focus on SOC2 compliance and multi-tenant architecture\""
    echo "     → Analyzes context materials and creates intelligent specification task list"
    echo "     → Determines which specifications are needed based on project requirements"
    echo "     → Creates shared task list in .augment/tasks.json with dependencies and priorities"
    echo ""
    echo "🚀 Phase 3: Parallel Specification Generation (Multiple AUGGIEs)"
    echo "  4. Deploy multiple AUGGIE instances, each working from the shared task list:"
    echo "     → AUGGIE 1 (Security): auggie-security-spec \"enterprise-saas\" \"SOC2 compliance\""
    echo "     → AUGGIE 2 (Database): auggie-database-spec \"enterprise-saas\" \"Multi-tenant data model\""
    echo "     → AUGGIE 3 (Infrastructure): auggie-infrastructure-spec \"enterprise-saas\" \"K8s deployment\""
    echo "     → AUGGIE 4 (API): auggie-api-spec \"enterprise-saas\" \"RESTful API with tenant isolation\""
    echo "     → AUGGIE 5 (Testing): auggie-testing-spec \"enterprise-saas\" \"Load testing strategy\""
    echo "     → All AUGGIEs reference the same context materials and update shared task progress"
    echo ""
    echo "✅ Phase 4: Development Task Generation & Export (Orchestrator)"
    echo "  5. auggie-review-milestone \"enterprise-saas\" \"specifications\"  # Review all specifications"
    echo "  6. auggie-specify \"enterprise-saas\" \"Core platform functionality\""
    echo "  7. auggie-plan \"enterprise-saas\" \"Multi-tenant architecture with microservices\""
    echo "  8. auggie-tasks \"enterprise-saas\" \"Focus on backend API and database first\""
    echo "     → Creates native AUGGIE task format with dependency management and parallel execution"
    echo "  9. auggie-export-specs \"enterprise-saas\" \"/path/to/development/\""
    echo "     → Creates complete development workspace with .augment/ structure and task coordination"
    echo ""
    echo "🚀 Phase 5: Multi-AUGGIE Development (Development Team)"
    echo "  10. Deploy multiple development AUGGIEs in exported workspace:"
    echo "      → AUGGIE 1 (Setup): Sequential foundation tasks"
    echo "      → AUGGIE 2 (Database): Parallel model and schema tasks"
    echo "      → AUGGIE 3 (API): Parallel service and endpoint tasks"
    echo "      → AUGGIE 4 (Frontend): Parallel component tasks"
    echo "      → AUGGIE 5 (Testing): Parallel test suite tasks"
    echo "      → All coordinate using: auggie view_tasklist, auggie update_tasks"
    echo ""
    echo "⚡ Benefits: 80% planning reduction + 75% development reduction = 95% overall time reduction!"
    echo ""
    echo "💡 Key Benefits:"
    echo "  • Project-specific AUGGIE workspaces with isolated context"
    echo "  • Professional implementation planning based on comprehensive input documents"
    echo "  • Context-aware specification generation using PRDs and research materials"
    echo "  • Never vibe coding - always reference comprehensive planning documents"
    echo "  • Multi-project architecture prevents cross-contamination"
    echo "  • Language agnostic - Python Spec-Kit can plan any tech stack"
    echo ""
    echo "For complete documentation, see README.md"
}

# AUGGIE-Security-Spec: Create comprehensive security specifications
auggie-security-spec() {
    if [ $# -lt 2 ]; then
        echo "Usage: auggie-security-spec \"project-name\" \"Security focus area\""
        echo "Example: auggie-security-spec \"task-manager\" \"User data protection and authentication\""
        echo ""
        echo "💡 Available projects:"
        auggie-list-projects
        return 1
    fi

    local project_name="$1"
    local security_focus="${*:2}"

    if ! validate_project "$project_name"; then
        return 1
    fi

    local repo_root=$(get_repo_root)
    local project_dir=$(get_project_dir "$project_name")

    echo "🛡️  Creating comprehensive security specification with AUGGIE..."
    echo "🎯 Project: $project_name"
    echo "🔒 Security Focus: $security_focus"
    echo ""

    cd "$project_dir" && auggie --quiet --print "
    I need you to create a comprehensive security specification for the '$project_name' project.

    Load the command definition from ../../templates/commands/auggie/security-spec.md and follow its instructions exactly.

    PROJECT CONTEXT:
    - Project Name: $project_name
    - Project Directory: $project_dir (current working directory)
    - Security Focus: $security_focus
    - Context Materials: Available in .augment/context/ directory
    - Project Guidelines: Available in .augment/guidelines.md
    - Security Guidelines: Available in ../../templates/security-guidelines.md

    IMPORTANT: Create security specifications for the '$project_name' project, NOT for the Spec-Kit tool itself.

    Context Analysis:
    1. Read and analyze comprehensive planning documents in .augment/context/
    2. Reference compliance requirements and technical constraints from context materials
    3. Use project-specific guidelines from .augment/guidelines.md
    4. Apply general security principles from ../../templates/security-guidelines.md
    5. Consider technology stack security characteristics from project metadata

    Generate:
    1. Security Architecture (authentication, authorization, data protection)
    2. Threat Modeling (assets, threat actors, attack vectors)
    3. Security Controls (preventive, detective, corrective)
    4. Compliance Requirements (GDPR, CCPA, industry-specific)
    5. Security Testing Strategy (SAST, DAST, penetration testing)
    6. Implementation Roadmap (phased security implementation)
    7. Risk Assessment (high/medium/low risk items)
    8. Security Documentation Requirements

    Save specifications in specs/ directory structure.

    Execute the security specification command now.
    "

    # Check for clarifications after security spec creation
    auggie-check-clarifications "$project_name" "security"
}

# AUGGIE-Database-Spec: Create comprehensive database specifications
auggie-database-spec() {
    if [ $# -lt 2 ]; then
        echo "Usage: auggie-database-spec \"project-name\" \"Database focus area\""
        echo "Example: auggie-database-spec \"task-manager\" \"User management and task tracking data model\""
        echo ""
        echo "💡 Available projects:"
        auggie-list-projects
        return 1
    fi

    local project_name="$1"
    local database_focus="${*:2}"

    if ! validate_project "$project_name"; then
        return 1
    fi

    local repo_root=$(get_repo_root)
    local project_dir=$(get_project_dir "$project_name")

    echo "🗄️  Creating comprehensive database specification with AUGGIE..."
    echo "🎯 Project: $project_name"
    echo "📊 Database Focus: $database_focus"
    echo ""

    cd "$project_dir" && auggie --quiet --print "
    I need you to create a comprehensive database specification for the '$project_name' project.

    Load the command definition from ../../templates/commands/auggie/database-spec.md and follow its instructions exactly.

    PROJECT CONTEXT:
    - Project Name: $project_name
    - Project Directory: $project_dir (current working directory)
    - Database Focus: $database_focus
    - Context Materials: Available in .augment/context/ directory
    - Project Guidelines: Available in .augment/guidelines.md
    - Existing Specifications: Available in specs/ directory

    IMPORTANT: Create database specifications for the '$project_name' project, NOT for the Spec-Kit tool itself.

    CRITICAL GOAL: Prevent migration hell by planning the complete data architecture upfront.

    Context Analysis:
    1. Read and analyze ALL existing specifications (scope, design, UX, security, technical)
    2. Extract ALL data requirements from business requirements in .augment/context/
    3. Analyze user personas and workflows for data patterns
    4. Consider technical constraints and performance requirements
    5. Plan for compliance requirements (GDPR, audit trails, etc.)

    Generate Complete Database Architecture:
    1. **Business Domain Analysis**: All entities, relationships, and business rules
    2. **Complete Schema Design**: All tables with ALL anticipated columns from the start
    3. **Relationship Planning**: All foreign keys, junction tables, and constraints
    4. **Performance Optimization**: Indexes, query patterns, and scalability planning
    5. **Migration Strategy**: Single comprehensive initial migration to prevent future schema conflicts
    6. **Data Integrity**: Constraints, validations, and business rule enforcement
    7. **Security Planning**: Row-level security, data privacy, and audit trails
    8. **Future-Proofing**: Anticipate future features and plan schema accordingly

    KEY PRINCIPLE: Design tables with ALL likely columns from the start, not just immediate needs.
    This prevents the '30 migrations' problem by comprehensive upfront planning.

    Save specifications in specs/ directory structure.

    Execute the database specification command now.
    "

    # Check for clarifications after database spec creation
    auggie-check-clarifications "$project_name" "database"
}

# AUGGIE-Infrastructure-Spec: Create comprehensive infrastructure and deployment specifications
auggie-infrastructure-spec() {
    if [ $# -lt 2 ]; then
        echo "Usage: auggie-infrastructure-spec \"project-name\" \"Infrastructure focus area\""
        echo "Example: auggie-infrastructure-spec \"task-manager\" \"Kubernetes deployment with auto-scaling\""
        echo ""
        echo "💡 Available projects:"
        auggie-list-projects
        return 1
    fi

    local project_name="$1"
    local infrastructure_focus="${*:2}"

    if ! validate_project "$project_name"; then
        return 1
    fi

    local repo_root=$(get_repo_root)
    local project_dir=$(get_project_dir "$project_name")

    echo "🏗️  Creating comprehensive infrastructure specification with AUGGIE..."
    echo "🎯 Project: $project_name"
    echo "🚀 Infrastructure Focus: $infrastructure_focus"
    echo ""

    cd "$project_dir" && auggie --quiet --print "
    I need you to create a comprehensive infrastructure and deployment specification for the '$project_name' project.

    Load the command definition from ../../templates/commands/auggie/infrastructure-spec.md and follow its instructions exactly.

    PROJECT CONTEXT:
    - Project Name: $project_name
    - Project Directory: $project_dir (current working directory)
    - Infrastructure Focus: $infrastructure_focus
    - Context Materials: Available in .augment/context/ directory
    - Project Guidelines: Available in .augment/guidelines.md
    - Existing Specifications: Available in specs/ directory

    IMPORTANT: Create infrastructure specifications for the '$project_name' project, NOT for the Spec-Kit tool itself.

    CRITICAL GOAL: Ensure production-ready deployment with proper scaling, monitoring, and operational procedures.

    Context Analysis:
    1. Read and analyze ALL existing specifications (scope, design, UX, security, database, technical)
    2. Extract performance and scaling requirements from technical specifications
    3. Consider security requirements for infrastructure configuration
    4. Analyze database requirements for infrastructure planning
    5. Review business requirements for availability and disaster recovery needs

    Generate Complete Infrastructure Architecture:
    1. **Deployment Architecture**: Container specifications, Kubernetes deployments, CI/CD pipelines
    2. **Environment Strategy**: Development, staging, production environment configurations
    3. **Health Checks & Monitoring**: Liveness/readiness probes, graceful shutdown procedures
    4. **Scaling & Performance**: Auto-scaling, load balancing, resource optimization
    5. **Security Configuration**: Network policies, SSL/TLS, secrets management
    6. **Backup & Recovery**: Automated backup procedures, disaster recovery plans
    7. **Configuration Management**: Environment variables, secrets, configuration as code

    KEY PRINCIPLE: Design infrastructure that can be deployed, scaled, and maintained in production.
    This prevents deployment failures, downtime, and operational issues.

    Save specifications in specs/ directory structure.

    Execute the infrastructure specification command now.
    "

    # Check for clarifications after infrastructure spec creation
    auggie-check-clarifications "$project_name" "infrastructure"
}

# AUGGIE-Monitoring-Spec: Create comprehensive monitoring and observability specifications
auggie-monitoring-spec() {
    if [ $# -lt 2 ]; then
        echo "Usage: auggie-monitoring-spec \"project-name\" \"Monitoring focus area\""
        echo "Example: auggie-monitoring-spec \"task-manager\" \"Application performance and error tracking\""
        echo ""
        echo "💡 Available projects:"
        auggie-list-projects
        return 1
    fi

    local project_name="$1"
    local monitoring_focus="${*:2}"

    if ! validate_project "$project_name"; then
        return 1
    fi

    local repo_root=$(get_repo_root)
    local project_dir=$(get_project_dir "$project_name")

    echo "📊 Creating comprehensive monitoring specification with AUGGIE..."
    echo "🎯 Project: $project_name"
    echo "📈 Monitoring Focus: $monitoring_focus"
    echo ""

    cd "$project_dir" && auggie --quiet --print "
    I need you to create a comprehensive monitoring and observability specification for the '$project_name' project.

    Load the command definition from ../../templates/commands/auggie/monitoring-spec.md and follow its instructions exactly.

    PROJECT CONTEXT:
    - Project Name: $project_name
    - Project Directory: $project_dir (current working directory)
    - Monitoring Focus: $monitoring_focus
    - Context Materials: Available in .augment/context/ directory
    - Project Guidelines: Available in .augment/guidelines.md
    - Existing Specifications: Available in specs/ directory

    IMPORTANT: Create monitoring specifications for the '$project_name' project, NOT for the Spec-Kit tool itself.

    CRITICAL GOAL: Ensure comprehensive observability with proper alerting, error tracking, and performance monitoring.

    Context Analysis:
    1. Read and analyze ALL existing specifications for monitoring requirements
    2. Extract performance requirements and SLA targets from technical specifications
    3. Consider security monitoring requirements from security specifications
    4. Analyze infrastructure requirements for monitoring integration
    5. Review business requirements for key performance indicators

    Generate Complete Monitoring Architecture:
    1. **Logging Strategy**: Structured logging, log aggregation, log analysis
    2. **Metrics & Monitoring**: Application metrics, infrastructure metrics, business metrics
    3. **Alerting Configuration**: Alert rules, notification channels, escalation procedures
    4. **Dashboard Configuration**: Monitoring dashboards, performance dashboards, business dashboards
    5. **Error Tracking**: Error monitoring, exception tracking, debugging tools
    6. **Performance Monitoring**: APM integration, performance tracking, bottleneck identification
    7. **Business Metrics**: KPI tracking, conversion metrics, user behavior analytics

    KEY PRINCIPLE: Design monitoring that provides actionable insights and enables quick issue resolution.
    This prevents production issues from going undetected and enables rapid troubleshooting.

    Save specifications in specs/ directory structure.

    Execute the monitoring specification command now.
    "

    # Check for clarifications after monitoring spec creation
    auggie-check-clarifications "$project_name" "monitoring"
}

# AUGGIE-API-Spec: Create comprehensive API and integration specifications
auggie-api-spec() {
    if [ $# -lt 2 ]; then
        echo "Usage: auggie-api-spec \"project-name\" \"API focus area\""
        echo "Example: auggie-api-spec \"task-manager\" \"REST API with rate limiting and caching\""
        echo ""
        echo "💡 Available projects:"
        auggie-list-projects
        return 1
    fi

    local project_name="$1"
    local api_focus="${*:2}"

    if ! validate_project "$project_name"; then
        return 1
    fi

    local repo_root=$(get_repo_root)
    local project_dir=$(get_project_dir "$project_name")

    echo "🔌 Creating comprehensive API specification with AUGGIE..."
    echo "🎯 Project: $project_name"
    echo "📡 API Focus: $api_focus"
    echo ""

    cd "$project_dir" && auggie --quiet --print "
    I need you to create a comprehensive API and integration specification for the '$project_name' project.

    Load the command definition from ../../templates/commands/auggie/api-spec.md and follow its instructions exactly.

    PROJECT CONTEXT:
    - Project Name: $project_name
    - Project Directory: $project_dir (current working directory)
    - API Focus: $api_focus
    - Context Materials: Available in .augment/context/ directory
    - Project Guidelines: Available in .augment/guidelines.md
    - Existing Specifications: Available in specs/ directory

    IMPORTANT: Create API specifications for the '$project_name' project, NOT for the Spec-Kit tool itself.

    CRITICAL GOAL: Ensure robust, scalable, and well-documented APIs with proper integrations and performance optimization.

    Context Analysis:
    1. Read and analyze ALL existing specifications for API requirements
    2. Extract performance and scaling requirements from technical specifications
    3. Consider security requirements for API authentication and authorization
    4. Analyze database requirements for API data access patterns
    5. Review business requirements for third-party integrations

    Generate Complete API Architecture:
    1. **API Design Standards**: RESTful design, GraphQL schemas, API versioning
    2. **Authentication & Authorization**: JWT, OAuth, API keys, role-based access
    3. **Rate Limiting & Throttling**: Request limits, quota management, abuse prevention
    4. **Caching Strategy**: Response caching, CDN integration, cache invalidation
    5. **Third-Party Integrations**: External APIs, webhooks, data synchronization
    6. **API Documentation**: OpenAPI specs, interactive documentation, SDK generation
    7. **Performance Optimization**: Response compression, pagination, query optimization

    KEY PRINCIPLE: Design APIs that are secure, performant, and developer-friendly.
    This prevents API abuse, performance issues, and integration problems.

    Save specifications in specs/ directory structure.

    Execute the API specification command now.
    "

    # Check for clarifications after API spec creation
    auggie-check-clarifications "$project_name" "api"
}

# AUGGIE-Testing-Spec: Create comprehensive testing strategy specifications
auggie-testing-spec() {
    if [ $# -lt 2 ]; then
        echo "Usage: auggie-testing-spec \"project-name\" \"Testing focus area\""
        echo "Example: auggie-testing-spec \"task-manager\" \"Load testing and performance validation\""
        echo ""
        echo "💡 Available projects:"
        auggie-list-projects
        return 1
    fi

    local project_name="$1"
    local testing_focus="${*:2}"

    if ! validate_project "$project_name"; then
        return 1
    fi

    local repo_root=$(get_repo_root)
    local project_dir=$(get_project_dir "$project_name")

    echo "🧪 Creating comprehensive testing specification with AUGGIE..."
    echo "🎯 Project: $project_name"
    echo "🔬 Testing Focus: $testing_focus"
    echo ""

    cd "$project_dir" && auggie --quiet --print "
    I need you to create a comprehensive testing strategy specification for the '$project_name' project.

    Load the command definition from ../../templates/commands/auggie/testing-spec.md and follow its instructions exactly.

    PROJECT CONTEXT:
    - Project Name: $project_name
    - Project Directory: $project_dir (current working directory)
    - Testing Focus: $testing_focus
    - Context Materials: Available in .augment/context/ directory
    - Project Guidelines: Available in .augment/guidelines.md
    - Existing Specifications: Available in specs/ directory

    IMPORTANT: Create testing specifications for the '$project_name' project, NOT for the Spec-Kit tool itself.

    CRITICAL GOAL: Ensure comprehensive testing coverage with proper performance, security, and reliability validation.

    Context Analysis:
    1. Read and analyze ALL existing specifications for testing requirements
    2. Extract performance targets and quality requirements from technical specifications
    3. Consider security testing requirements from security specifications
    4. Analyze API testing requirements from API specifications
    5. Review business requirements for acceptance criteria and user scenarios

    Generate Complete Testing Strategy:
    1. **Testing Pyramid**: Unit tests, integration tests, end-to-end tests, manual tests
    2. **Performance Testing**: Load testing, stress testing, endurance testing, spike testing
    3. **Security Testing**: Vulnerability scanning, penetration testing, security audits
    4. **Compatibility Testing**: Cross-browser, mobile, accessibility, internationalization
    5. **API Testing**: Contract testing, integration testing, performance testing
    6. **Test Automation**: CI/CD integration, automated test execution, reporting
    7. **Quality Gates**: Coverage thresholds, performance benchmarks, security standards

    KEY PRINCIPLE: Design testing that ensures quality, performance, and reliability.
    This prevents bugs, performance issues, and security vulnerabilities in production.

    Save specifications in specs/ directory structure.

    Execute the testing specification command now.
    "

    # Check for clarifications after testing spec creation
    auggie-check-clarifications "$project_name" "testing"
}

# AUGGIE-Operations-Spec: Create comprehensive operations and maintenance specifications
auggie-operations-spec() {
    if [ $# -lt 2 ]; then
        echo "Usage: auggie-operations-spec \"project-name\" \"Operations focus area\""
        echo "Example: auggie-operations-spec \"task-manager\" \"24/7 support with incident response procedures\""
        echo ""
        echo "💡 Available projects:"
        auggie-list-projects
        return 1
    fi

    local project_name="$1"
    local operations_focus="${*:2}"

    if ! validate_project "$project_name"; then
        return 1
    fi

    local repo_root=$(get_repo_root)
    local project_dir=$(get_project_dir "$project_name")

    echo "⚙️  Creating comprehensive operations specification with AUGGIE..."
    echo "🎯 Project: $project_name"
    echo "🔧 Operations Focus: $operations_focus"
    echo ""

    cd "$project_dir" && auggie --quiet --print "
    I need you to create a comprehensive operations and maintenance specification for the '$project_name' project.

    Load the command definition from ../../templates/commands/auggie/operations-spec.md and follow its instructions exactly.

    PROJECT CONTEXT:
    - Project Name: $project_name
    - Project Directory: $project_dir (current working directory)
    - Operations Focus: $operations_focus
    - Context Materials: Available in .augment/context/ directory
    - Project Guidelines: Available in .augment/guidelines.md
    - Existing Specifications: Available in specs/ directory

    IMPORTANT: Create operations specifications for the '$project_name' project, NOT for the Spec-Kit tool itself.

    CRITICAL GOAL: Ensure comprehensive operational procedures with proper incident response, maintenance, and support documentation.

    Context Analysis:
    1. Read and analyze ALL existing specifications for operational requirements
    2. Extract SLA requirements and availability targets from business requirements
    3. Consider infrastructure requirements for maintenance procedures
    4. Analyze monitoring requirements for incident response integration
    5. Review security requirements for incident handling procedures

    Generate Complete Operations Framework:
    1. **Incident Response**: Classification, procedures, escalation matrix, post-mortem processes
    2. **Backup & Recovery**: Backup strategies, recovery procedures, RTO/RPO definitions
    3. **Maintenance Procedures**: Scheduled maintenance, emergency procedures, change management
    4. **Support Documentation**: Runbooks, troubleshooting guides, knowledge base
    5. **Monitoring Integration**: Operational metrics, alert procedures, dashboard requirements
    6. **Change Management**: Deployment procedures, rollback plans, approval workflows
    7. **Team Procedures**: On-call schedules, escalation procedures, communication plans

    KEY PRINCIPLE: Design operations that ensure reliable, maintainable, and supportable systems.
    This prevents operational issues, reduces downtime, and enables effective support.

    Save specifications in specs/ directory structure.

    Execute the operations specification command now.
    "

    # Check for clarifications after operations spec creation
    auggie-check-clarifications "$project_name" "operations"
}

# AUGGIE-Orchestrate: Intelligent specification planning with shared task management
auggie-orchestrate() {
    if [ $# -lt 1 ]; then
        echo "Usage: auggie-orchestrate \"project-name\" [additional-context]"
        echo "Example: auggie-orchestrate \"enterprise-saas\" \"Focus on SOC2 compliance and multi-tenant architecture\""
        echo ""
        echo "💡 Available projects:"
        auggie-list-projects
        return 1
    fi

    local project_name="$1"
    local additional_context="${*:2}"

    if ! validate_project "$project_name"; then
        return 1
    fi

    local repo_root=$(get_repo_root)
    local project_dir=$(get_project_dir "$project_name")

    echo "🎭 Creating intelligent specification plan with AUGGIE orchestrator..."
    echo "🎯 Project: $project_name"
    echo "📋 Additional Context: $additional_context"
    echo ""

    cd "$project_dir" && auggie --quiet --print "
    I need you to act as the AUGGIE Orchestrator and create an intelligent specification planning task list for the '$project_name' project.

    ORCHESTRATOR ROLE:
    You are the intelligent orchestrator that analyzes project context and determines which specifications are actually needed, creating a shared task list that multiple AUGGIE instances will execute in parallel.

    PROJECT CONTEXT:
    - Project Name: $project_name
    - Project Directory: $project_dir (current working directory)
    - Additional Context: $additional_context
    - Context Materials: Available in .augment/context/ directory
    - Project Guidelines: Available in .augment/guidelines.md
    - Project Metadata: Available in .project-meta.json

    CRITICAL ANALYSIS REQUIRED:
    1. **Read ALL context materials** in .augment/context/ directory
    2. **Analyze project complexity** from .project-meta.json
    3. **Extract requirements** from PRD, technical constraints, compliance needs
    4. **Identify integration needs** from business requirements
    5. **Determine operational requirements** from support and SLA needs

    SPECIFICATION SELECTION LOGIC:
    Based on context analysis, determine which specifications are needed:

    ALWAYS REQUIRED:
    - auggie-scope-spec (foundational)
    - auggie-security-spec (security is non-negotiable)

    CONDITIONALLY REQUIRED (analyze context to decide):
    - auggie-database-spec (if data storage/persistence needed)
    - auggie-infrastructure-spec (if cloud deployment/scaling mentioned)
    - auggie-monitoring-spec (if SLA requirements/uptime mentioned)
    - auggie-api-spec (if APIs/integrations/third-party services mentioned)
    - auggie-testing-spec (if performance requirements/load testing mentioned)
    - auggie-operations-spec (if 24/7 support/incident response mentioned)
    - auggie-design-spec (if custom UI/branding/design system mentioned)
    - auggie-ux-spec (if complex user flows/UX research mentioned)

    CREATE SHARED TASK LIST:
    Generate a comprehensive task list using AUGGIE's native task management format with:

    1. **Task Structure**: Each specification as a separate task
    2. **Dependencies**: Proper task dependencies (scope first, then parallel execution)
    3. **Priorities**: Critical, High, Medium based on project needs
    4. **Justification**: Why each specification is included/excluded
    5. **Execution Order**: Logical sequence with parallel opportunities

    TASK LIST FORMAT:
    Use add_tasks() to create the specification planning tasks with:
    - Clear task names and descriptions
    - Proper dependencies between specifications
    - Priority levels based on project criticality
    - Justification for inclusion in task descriptions

    EXAMPLE TASK STRUCTURE:
    - Task 1: Create Scope Specification (no dependencies, critical priority)
    - Task 2-N: Create other specifications (depend on scope, various priorities)
    - Include ONLY specifications that are justified by context analysis

    IMPORTANT PRINCIPLES:
    - Practice what we preach: Use professional task management
    - No wasted effort: Only include needed specifications
    - Clear justification: Explain why each specification is required
    - Proper sequencing: Ensure logical dependencies
    - Parallel execution: Enable multiple AUGGIEs to work simultaneously

    Execute the orchestration analysis and create the shared specification task list now.
    "

    echo ""
    echo "✅ Intelligent specification plan created!"
    echo "📋 View the task list: auggie view_tasklist"
    echo "🚀 Multiple AUGGIEs can now execute specifications in parallel using the shared task list"
    echo ""
    echo "💡 Next: Deploy multiple AUGGIE instances to execute the planned specifications"
}

# Enhanced AUGGIE Commands for Complete Project Development

# AUGGIE-Design-Spec: Create comprehensive design specifications
auggie-design-spec() {
    if [ $# -lt 2 ]; then
        echo "Usage: auggie-design-spec \"project-name\" \"Design description\""
        echo "Example: auggie-design-spec \"task-manager\" \"Modern SaaS dashboard with clean aesthetics\""
        echo ""
        echo "💡 Available projects:"
        auggie-list-projects
        return 1
    fi

    local project_name="$1"
    local design_description="${*:2}"

    if ! validate_project "$project_name"; then
        return 1
    fi

    local repo_root=$(get_repo_root)
    local project_dir=$(get_project_dir "$project_name")

    echo "🎨 Creating comprehensive design specification with AUGGIE..."
    echo "🎯 Project: $project_name"
    echo "📝 Design: $design_description"
    echo ""

    cd "$project_dir" && auggie --quiet --print "
    I need you to create a comprehensive design specification for the '$project_name' project.

    Load the command definition from ../../templates/commands/auggie/design-spec.md and follow its instructions exactly.

    PROJECT CONTEXT:
    - Project Name: $project_name
    - Project Directory: $project_dir (current working directory)
    - Design Description: $design_description
    - Context Materials: Available in .augment/context/ directory
    - Project Guidelines: Available in .augment/guidelines.md

    IMPORTANT: Create design specifications for the '$project_name' project, NOT for the Spec-Kit tool itself.

    Context Analysis:
    1. Read and analyze comprehensive planning documents in .augment/context/
    2. Reference user personas and brand requirements from context materials
    3. Use project-specific guidelines from .augment/guidelines.md
    4. Apply design constraints from technical requirements

    Generate:
    1. Visual Design System (colors, typography, spacing, components)
    2. Layout Wireframes (component placement and hierarchy)
    3. Responsive Breakpoints (mobile-first design specifications)
    4. Accessibility Requirements (WCAG 2.1 AA compliance)
    5. Brand Guidelines (visual identity and voice)

    Save specifications in specs/ directory structure.

    Execute the design specification command now.
    "

    # Check for clarifications after design spec creation
    auggie-check-clarifications "$project_name" "design"
}

# AUGGIE-UX-Spec: Create user experience flow specifications
auggie-ux-spec() {
    if [ $# -lt 2 ]; then
        echo "Usage: auggie-ux-spec \"project-name\" \"UX flow description\""
        echo "Example: auggie-ux-spec \"task-manager\" \"User onboarding with progressive disclosure\""
        echo ""
        echo "💡 Available projects:"
        auggie-list-projects
        return 1
    fi

    local project_name="$1"
    local ux_description="${*:2}"

    if ! validate_project "$project_name"; then
        return 1
    fi

    local repo_root=$(get_repo_root)
    local project_dir=$(get_project_dir "$project_name")

    echo "🧭 Creating comprehensive UX specification with AUGGIE..."
    echo "🎯 Project: $project_name"
    echo "📝 UX Flow: $ux_description"
    echo ""

    cd "$project_dir" && auggie --quiet --print "
    I need you to create a comprehensive UX specification for the '$project_name' project.

    Load the command definition from ../../templates/commands/auggie/ux-spec.md and follow its instructions exactly.

    PROJECT CONTEXT:
    - Project Name: $project_name
    - Project Directory: $project_dir (current working directory)
    - UX Description: $ux_description
    - Context Materials: Available in .augment/context/ directory
    - Project Guidelines: Available in .augment/guidelines.md

    IMPORTANT: Create UX specifications for the '$project_name' project, NOT for the Spec-Kit tool itself.

    Context Analysis:
    1. Read and analyze user personas and journey maps from .augment/context/
    2. Reference business requirements and success metrics from context materials
    3. Use project-specific guidelines from .augment/guidelines.md
    4. Apply UX constraints from technical and design specifications

    Generate:
    1. User Journey Maps (step-by-step flows with decision points)
    2. Interaction Specifications (hover, focus, loading states)
    3. Error State Handling (user-friendly messages and recovery)
    4. Micro-interaction Details (animations, transitions, feedback)
    5. Content Guidelines (copy, placeholders, empty states)

    Save specifications in specs/ directory structure.

    Execute the UX specification command now.
    "

    # Check for clarifications after UX spec creation
    auggie-check-clarifications "$project_name" "ux"
}

# AUGGIE-Component-Design: Create detailed component design specifications
auggie-component-design() {
    if [ $# -lt 2 ]; then
        echo "Usage: auggie-component-design \"project-name\" \"Component description\""
        echo "Example: auggie-component-design \"task-manager\" \"Data table with filtering and pagination\""
        echo ""
        echo "💡 Available projects:"
        auggie-list-projects
        return 1
    fi

    local project_name="$1"
    local component_description="${*:2}"

    if ! validate_project "$project_name"; then
        return 1
    fi

    local repo_root=$(get_repo_root)
    local project_dir=$(get_project_dir "$project_name")

    echo "🧩 Creating component design specification with AUGGIE..."
    echo "🎯 Project: $project_name"
    echo "📝 Component: $component_description"
    echo ""

    cd "$repo_root" && auggie --print "
    I need you to create a detailed component design specification for the '$project_name' project.

    Load the command definition from templates/commands/auggie/component-design.md and follow its instructions exactly.

    PROJECT CONTEXT:
    - Project Name: $project_name
    - Project Directory: $project_dir
    - Component Description: $component_description

    IMPORTANT: Create component specifications for the '$project_name' project, NOT for the Spec-Kit tool itself.

    Generate:
    1. Visual Component Specs (styling, states, variants)
    2. Interaction Behavior (click, hover, focus, disabled states)
    3. Content Guidelines (text, placeholders, error messages)
    4. Responsive Behavior (adaptation across screen sizes)
    5. Animation Specifications (timing, easing, duration)

    Use your context engine to:
    - Analyze existing component patterns in the '$project_name' project
    - Ensure consistency with design system
    - Create reusable, maintainable components
    - Apply accessibility best practices
    - Save specifications in $project_dir/specs/ directory structure

    Execute the component design specification command now.
    "
}

# AUGGIE-Scope-Spec: Create pragmatic scope specifications with complexity control
auggie-scope-spec() {
    local complexity="simple"
    local project_name=""
    local description=""

    # Parse arguments - first argument must be project name
    if [ $# -eq 0 ]; then
        echo "Usage: auggie-scope-spec \"project-name\" \"Feature description\" [--complexity=simple|enterprise]"
        echo "Example: auggie-scope-spec \"task-manager\" \"User management\" --complexity=simple"
        echo ""
        echo "💡 Available projects:"
        auggie-list-projects
        return 1
    fi

    project_name="$1"
    shift

    # Parse remaining arguments with improved logic
    local description_parts=()
    while [[ $# -gt 0 ]]; do
        case $1 in
            --complexity=*)
                local complexity_value="${1#*=}"
                # Validate complexity value
                if [[ "$complexity_value" == "simple" || "$complexity_value" == "enterprise" ]]; then
                    complexity="$complexity_value"
                else
                    echo "❌ Error: Invalid complexity value '$complexity_value'"
                    echo "Valid values: simple, enterprise"
                    return 1
                fi
                shift
                ;;
            --complexity)
                # Handle --complexity as separate argument
                if [ $# -lt 2 ]; then
                    echo "❌ Error: --complexity requires a value"
                    return 1
                fi
                shift
                local complexity_value="$1"
                if [[ "$complexity_value" == "simple" || "$complexity_value" == "enterprise" ]]; then
                    complexity="$complexity_value"
                else
                    echo "❌ Error: Invalid complexity value '$complexity_value'"
                    echo "Valid values: simple, enterprise"
                    return 1
                fi
                shift
                ;;
            --*)
                echo "❌ Error: Unknown option '$1'"
                echo "Usage: auggie-scope-spec \"project-name\" \"Feature description\" [--complexity=simple|enterprise]"
                return 1
                ;;
            *)
                # Add to description parts
                description_parts+=("$1")
                shift
                ;;
        esac
    done

    # Join description parts
    if [ ${#description_parts[@]} -eq 0 ]; then
        echo "❌ Error: Feature description is required"
        echo "Usage: auggie-scope-spec \"project-name\" \"Feature description\" [--complexity=simple|enterprise]"
        echo "Example: auggie-scope-spec \"task-manager\" \"User management\" --complexity=simple"
        return 1
    fi

    # Join description parts with spaces
    description=$(IFS=' '; echo "${description_parts[*]}")
    description=$(echo "$description" | xargs) # trim whitespace

    if ! validate_project "$project_name"; then
        return 1
    fi

    local repo_root=$(get_repo_root)
    local project_dir=$(get_project_dir "$project_name")
    description=$(echo "$description" | xargs) # trim whitespace

    echo "🎯 Creating pragmatic scope specification with AUGGIE..."
    echo "🎯 Project: $project_name"
    echo "📝 Feature: $description"
    echo "🔧 Complexity: $complexity"
    echo ""

    cd "$project_dir" && auggie --quiet --print "
    I need you to create a pragmatic scope specification for the '$project_name' project.

    PROJECT CONTEXT:
    - Project Name: $project_name
    - Project Directory: $project_dir (current working directory)
    - Feature Description: $description
    - Complexity Level: $complexity
    - Context Materials: Available in .augment/context/ directory
    - Project Guidelines: Available in .augment/guidelines.md

    IMPORTANT: Create scope specifications for the '$project_name' project, NOT for the Spec-Kit tool itself.

    Load the command definition from ../../templates/commands/auggie/scope-spec.md and follow its instructions exactly.

    Context Analysis:
    1. Read and analyze comprehensive planning documents in .augment/context/
    2. Reference PRD and business requirements from context materials
    3. Use project-specific guidelines from .augment/guidelines.md
    4. Apply technical constraints and complexity level

    For complexity level '$complexity':
    - Simple: Basic CRUD, standard patterns, essential features only
    - Enterprise: Advanced features, complex validation, full feature set

    Generate:
    1. Core Requirements (MVP features)
    2. Future Enhancements (post-MVP features)
    3. Explicitly NOT Included (scope boundaries)
    4. Technology Pragmatism (appropriate tech choices)
    5. Maintenance Considerations (long-term sustainability)

    Save specifications in specs/ directory structure.

    Execute the scope specification command now.
    "

    # Check for clarifications after spec creation
    auggie-check-clarifications "$project_name" "scope"
}


# AUGGIE-Export-Specs: Export complete development workspace with native AUGGIE task coordination
auggie-export-specs() {
    if [ $# -lt 2 ]; then
        echo "Usage: auggie-export-specs \"project-name\" \"/path/to/export/location/\""
        echo "Example: auggie-export-specs \"task-manager\" \"/Users/dev/handoff/\""
        echo ""
        echo "🚀 Creates enhanced development workspace with:"
        echo "   ✅ Native AUGGIE task management with parallel execution"
        echo "   ✅ All specifications as context materials"
        echo "   ✅ Multi-agent orchestration tools and coordination"
        echo "   ✅ Portable AUGGIE commands for continued specification work"
        echo "   ✅ Comprehensive development guidelines and workflows"
        return 1
    fi

    local project_name="$1"
    local export_path="$2"
    local project_dir=$(get_project_dir "$project_name")

    if ! validate_project "$project_name"; then
        return 1
    fi

    # Ensure export path exists
    mkdir -p "$export_path"
    local development_project_dir="$export_path/${project_name}"

    echo "🚀 Exporting enhanced development workspace with multi-agent coordination..."
    echo "🎯 Project: $project_name"
    echo "📁 Development workspace: $development_project_dir"
    echo "⚡ Features: Multi-agent orchestration, portable AUGGIE commands, enhanced workflows"
    echo ""

    # Create complete development workspace using our generator
    echo "🏗️  Creating development workspace structure..."
    auggie-create-dev-workspace "$project_name" "$development_project_dir"

    # Copy orchestrator tools for multi-agent coordination
    echo ""
    echo "🔧 Installing orchestrator tools for multi-agent coordination..."
    mkdir -p "$development_project_dir/.augment/orchestrator"
    mkdir -p "$development_project_dir/.augment/commands"
    mkdir -p "$development_project_dir/.augment/workflows"

    # Copy multi-agent orchestration tools
    if [ -f "$repo_root/multi-auggie-orchestrator.py" ]; then
        cp "$repo_root/multi-auggie-orchestrator.py" "$development_project_dir/.augment/orchestrator/"
    fi
    if [ -f "$repo_root/multi-auggie.sh" ]; then
        cp "$repo_root/multi-auggie.sh" "$development_project_dir/.augment/orchestrator/"
        chmod +x "$development_project_dir/.augment/orchestrator/multi-auggie.sh"
    fi

    # Copy AUGGIE command templates for continued specification work
    if [ -d "$repo_root/templates/commands/auggie" ]; then
        cp -r "$repo_root/templates/commands/auggie" "$development_project_dir/.augment/commands/"
    fi

    # Create portable AUGGIE command wrappers
    cat > "$development_project_dir/.augment/commands/auggie-specify.sh" << 'AUGGIE_CMD_EOF'
#!/bin/bash
# Portable AUGGIE specify command for exported project
cd "$(dirname "$0")/../.."
auggie --quiet --print "
Load the command definition from .augment/commands/auggie/specify.md and follow its instructions exactly.
Context: $*
"
AUGGIE_CMD_EOF
    chmod +x "$development_project_dir/.augment/commands/auggie-specify.sh"

    cat > "$development_project_dir/.augment/commands/auggie-plan.sh" << 'AUGGIE_CMD_EOF'
#!/bin/bash
# Portable AUGGIE plan command for exported project
cd "$(dirname "$0")/../.."
auggie --quiet --print "
Load the command definition from .augment/commands/auggie/plan.md and follow its instructions exactly.
Context: $*
"
AUGGIE_CMD_EOF
    chmod +x "$development_project_dir/.augment/commands/auggie-plan.sh"

    cat > "$development_project_dir/.augment/commands/auggie-tasks.sh" << 'AUGGIE_CMD_EOF'
#!/bin/bash
# Portable AUGGIE tasks command for exported project
cd "$(dirname "$0")/../.."
auggie --quiet --print "
Load the command definition from .augment/commands/auggie/enhanced-tasks.md and follow its instructions exactly.
Generate tasks in native AUGGIE format using add_tasks() commands.
Context: $*
"
AUGGIE_CMD_EOF
    chmod +x "$development_project_dir/.augment/commands/auggie-tasks.sh"

    # Create development workflow scripts
    cat > "$development_project_dir/.augment/workflows/setup-development.sh" << 'WORKFLOW_EOF'
#!/bin/bash
# Development environment setup workflow
echo "🚀 Setting up development environment..."

# Install dependencies based on technology stack
if [ -f "package.json" ]; then
    echo "📦 Installing Node.js dependencies..."
    npm install
elif [ -f "requirements.txt" ]; then
    echo "🐍 Installing Python dependencies..."
    pip install -r requirements.txt
elif [ -f "Cargo.toml" ]; then
    echo "🦀 Installing Rust dependencies..."
    cargo build
fi

echo "✅ Development environment ready!"
WORKFLOW_EOF
    chmod +x "$development_project_dir/.augment/workflows/setup-development.sh"

    # Generate native AUGGIE development tasks
    echo ""
    echo "📋 Generating native AUGGIE development tasks..."
    cd "$development_project_dir" && auggie --quiet --print "
    I need you to generate comprehensive development tasks for the '$project_name' project using the enhanced task generation system.

    Load the command definition from .augment/commands/auggie/enhanced-tasks.md and follow its instructions exactly.

    PROJECT CONTEXT:
    - Project Name: $project_name
    - Development Directory: $development_project_dir (current working directory)
    - Context Materials: Available in .augment/context/ directory (all specifications)
    - Development Guidelines: Available in .augment/guidelines.md

    TASK GENERATION REQUIREMENTS:
    1. **Native AUGGIE Format**: Use add_tasks() to create proper task management structure
    2. **Parallel Execution**: Mark tasks that can run simultaneously without conflicts
    3. **Dependency Management**: Create proper task dependencies and execution order
    4. **Context Integration**: Reference specific specification documents in each task
    5. **Conflict Prevention**: Ensure no file-level conflicts between parallel tasks

    ANALYSIS PROCESS:
    1. Read ALL specifications in .augment/context/ directory
    2. Extract technology stack, architecture, and requirements
    3. Plan task categories: Setup, Database, API, Frontend, Testing, Security
    4. Identify dependencies and parallel execution opportunities
    5. Create comprehensive task list with proper coordination

    PARALLEL EXECUTION STRATEGY:
    - Setup tasks: Sequential (foundation)
    - Model/Entity tasks: Parallel (different files)
    - Service layer tasks: Parallel (independent services)
    - API endpoint tasks: Parallel (different routes)
    - Frontend component tasks: Parallel (different components)
    - Testing tasks: Parallel (independent test suites)

    Generate the complete development task list now using add_tasks() format.
    "

    # Create enhanced development guidelines using our template
    echo ""
    echo "📖 Creating enhanced development guidelines..."

    # Get project metadata for template substitution
    local tech_stack="Unknown"
    local architecture_type="Standard"
    local complexity_level="Simple"

    if [ -f "$project_dir/.project-meta.json" ]; then
        tech_stack=$(jq -r '.tech_stack // "Unknown"' "$project_dir/.project-meta.json")
        complexity_level=$(jq -r '.complexity // "Simple"' "$project_dir/.project-meta.json")
    fi

    # Create development guidelines from template
    sed -e "s/{PROJECT_NAME}/$project_name/g" \
        -e "s/{TECH_STACK}/$tech_stack/g" \
        -e "s/{ARCHITECTURE_TYPE}/$architecture_type/g" \
        -e "s/{COMPLEXITY_LEVEL}/$complexity_level/g" \
        -e "s/{TECH_SPECIFIC_GUIDELINES}/Technology-specific guidelines will be added based on your stack/g" \
        "$repo_root/templates/development-guidelines-template.md" > "$development_project_dir/DEVELOPMENT-README.md"

    # Create orchestrator guide from template
    cp "$repo_root/templates/orchestrator-guide-template.md" "$development_project_dir/ORCHESTRATOR-GUIDE.md"

    # Create development coordination documentation
    cat > "$development_project_dir/DEVELOPMENT-COORDINATION.md" << EOF
# Development Coordination Guide

## AUGGIE Multi-Agent Development

This project is designed for multiple AUGGIE agents to work in parallel during development.

### Quick Start for AUGGIE Agents

\`\`\`bash
# 1. View all development tasks
auggie view_tasklist

# 2. Claim a task (prevents conflicts)
auggie update_tasks --task-id="setup-001" --state="IN_PROGRESS"

# 3. Reference context materials
cat .augment/context/database-spec.md  # For database tasks
cat .augment/context/api-spec.md       # For API tasks
cat .augment/context/security-spec.md  # For security tasks

# 4. Complete task and update status
auggie update_tasks --task-id="setup-001" --state="COMPLETE"
\`\`\`

### Parallel Execution Guidelines

#### Phase 1: Sequential Setup (1 AUGGIE)
- Project initialization
- Core configuration
- Database setup
- Testing framework setup

#### Phase 2: Parallel Development (3-5 AUGGIEs)
- **AUGGIE 1**: Database models and entities
- **AUGGIE 2**: Service layer and business logic
- **AUGGIE 3**: API endpoints and controllers
- **AUGGIE 4**: Frontend components (if applicable)
- **AUGGIE 5**: Testing suites

#### Phase 3: Integration & Polish (2-3 AUGGIEs)
- Integration testing
- Performance optimization
- Documentation
- Final testing and validation

### Conflict Prevention

#### File-Level Conflicts
- **Same File**: Only one AUGGIE can modify a file at a time
- **Different Files**: Multiple AUGGIEs can work in parallel
- **Configuration Files**: Sequential modification only

#### Task Dependencies
- Check task dependencies before starting work
- Update task status to coordinate with other AUGGIEs
- Use \`auggie view_tasklist\` to see current status

#### Communication Protocol
1. **Claim Task**: Update status to IN_PROGRESS
2. **Work**: Implement with proper testing
3. **Complete**: Update status to COMPLETE
4. **Notify**: Dependent tasks can now start

### Multi-Agent Orchestration

#### Using the Orchestrator
\`\`\`bash
# Initialize multi-agent workspace
./.augment/orchestrator/multi-auggie.sh init

# Assign tasks to specialized agents
./.augment/orchestrator/multi-auggie.sh assign

# Execute tasks in parallel
./.augment/orchestrator/multi-auggie.sh orchestrate

# Monitor progress
./.augment/orchestrator/multi-auggie.sh status
\`\`\`

#### Available AUGGIE Commands
\`\`\`bash
# Continue specification work
./.augment/commands/auggie-specify.sh "additional feature"
./.augment/commands/auggie-plan.sh "implementation details"
./.augment/commands/auggie-tasks.sh "new requirements"
\`\`\`

### Context Materials Reference

All specifications are available in \`.augment/context/\`:
- \`scope-spec.md\` - Project requirements and boundaries
- \`database-spec.md\` - Data models and schema
- \`api-spec.md\` - API design and endpoints
- \`security-spec.md\` - Security requirements
- \`infrastructure-spec.md\` - Deployment and infrastructure
- \`testing-spec.md\` - Testing strategies
- \`monitoring-spec.md\` - Monitoring and observability

### Quality Standards
- Follow TDD: Write tests first
- Reference specifications for implementation details
- Include proper error handling and logging
- Maintain code quality and documentation
- Coordinate with other AUGGIEs through task status updates

### Troubleshooting
- **Task Conflicts**: Check \`auggie view_tasklist\` for status
- **Missing Context**: Review \`.augment/context/\` materials
- **Dependencies**: Ensure prerequisite tasks are complete
- **File Conflicts**: Coordinate file modifications through task status
EOF

    # Create agent configuration for orchestrator
    cat > "$development_project_dir/.augment/orchestrator/agent-configs.json" << EOF
{
  "agents": [
    {
      "id": "setup",
      "name": "Setup Specialist",
      "specialization": "setup",
      "description": "Handles project initialization, dependencies, and tooling setup"
    },
    {
      "id": "database",
      "name": "Database Specialist",
      "specialization": "database",
      "description": "Manages schema, models, migrations, and data access layer"
    },
    {
      "id": "api",
      "name": "API Specialist",
      "specialization": "api",
      "description": "Develops endpoints, services, middleware, and business logic"
    },
    {
      "id": "frontend",
      "name": "Frontend Specialist",
      "specialization": "frontend",
      "description": "Creates components, pages, styling, and user interactions"
    },
    {
      "id": "testing",
      "name": "Testing Specialist",
      "specialization": "testing",
      "description": "Implements unit tests, integration tests, and E2E testing"
    },
    {
      "id": "security",
      "name": "Security Specialist",
      "specialization": "security",
      "description": "Handles authentication, authorization, and security measures"
    }
  ],
  "coordination": {
    "max_parallel_agents": 4,
    "conflict_detection": true,
    "dependency_enforcement": true,
    "progress_synchronization": true
  }
}
EOF

    # Create technology-specific setup instructions
    local tech_stack=$(python3 -c "
import json, sys
try:
    with open('$project_dir/.project-meta.json', 'r') as f:
        data = json.load(f)
        print(data.get('tech_stack', 'unknown'))
except:
    print('unknown')
" 2>/dev/null || echo "unknown")

    case "$tech_stack" in
        "react"|"vue"|"angular")
            cat > "$development_project_dir/SETUP.md" << 'EOF'
# Development Setup Instructions

## Prerequisites
- Node.js 18+ and npm/yarn
- Git
- AUGGIE CLI

## Quick Start
```bash
# 1. Install dependencies (after setup tasks complete)
npm install

# 2. Start development server
npm run dev

# 3. Run tests
npm test

# 4. For AUGGIE agents
auggie view_tasklist  # See all development tasks
```

## AUGGIE Development Workflow
1. Review task list and claim tasks
2. Reference context materials in .augment/context/
3. Implement with proper testing
4. Update task status for coordination
EOF
            ;;
        "python"|"django"|"flask")
            cat > "$development_project_dir/SETUP.md" << 'EOF'
# Development Setup Instructions

## Prerequisites
- Python 3.9+ and pip
- Virtual environment (venv/conda)
- Git
- AUGGIE CLI

## Quick Start
```bash
# 1. Create virtual environment
python -m venv venv
source venv/bin/activate  # or venv\Scripts\activate on Windows

# 2. Install dependencies (after setup tasks complete)
pip install -r requirements.txt

# 3. Run development server
python manage.py runserver  # Django
# or
flask run  # Flask

# 4. Run tests
pytest

# 5. For AUGGIE agents
auggie view_tasklist  # See all development tasks
```

## AUGGIE Development Workflow
1. Review task list and claim tasks
2. Reference context materials in .augment/context/
3. Implement with proper testing
4. Update task status for coordination
EOF
            ;;
        *)
            cat > "$development_project_dir/SETUP.md" << 'EOF'
# Development Setup Instructions

## Prerequisites
- Development environment for the chosen technology stack
- Git
- AUGGIE CLI

## Quick Start
```bash
# 1. Install dependencies (after setup tasks complete)
# Follow technology-specific installation instructions

# 2. Start development environment
# Follow technology-specific startup instructions

# 3. Run tests
# Follow technology-specific testing instructions

# 4. For AUGGIE agents
auggie view_tasklist  # See all development tasks
```

## AUGGIE Development Workflow
1. Review task list and claim tasks
2. Reference context materials in .augment/context/
3. Implement with proper testing
4. Update task status for coordination
EOF
            ;;
    esac

    echo ""
    echo "✅ Enhanced development workspace exported successfully!"
    echo ""
    echo "📁 Enhanced Development Workspace Structure:"
    echo "   $development_project_dir/"
    echo "   ├── .augment/"
    echo "   │   ├── context/              # All specifications as context materials"
    echo "   │   ├── tasks.json            # Native AUGGIE task management"
    echo "   │   ├── guidelines.md         # Development guidelines"
    echo "   │   ├── orchestrator/         # Multi-agent coordination tools"
    echo "   │   │   ├── multi-auggie.sh   # Orchestration script"
    echo "   │   │   ├── multi-auggie-orchestrator.py # Python orchestrator"
    echo "   │   │   └── agent-configs.json # Agent specialization configs"
    echo "   │   ├── commands/             # Portable AUGGIE commands"
    echo "   │   │   ├── auggie-specify.sh # Continue specification work"
    echo "   │   │   ├── auggie-plan.sh    # Implementation planning"
    echo "   │   │   ├── auggie-tasks.sh   # Task generation"
    echo "   │   │   └── auggie/           # Command templates"
    echo "   │   └── workflows/            # Development workflows"
    echo "   │       └── setup-development.sh # Environment setup"
    echo "   ├── src/                      # Source code directory"
    echo "   ├── tests/                    # Test files directory"
    echo "   ├── docs/                     # Documentation directory"
    echo "   ├── README.md                 # Project overview"
    echo "   ├── DEVELOPMENT-README.md     # AUGGIE agent instructions"
    echo "   ├── ORCHESTRATOR-GUIDE.md     # Multi-agent coordination guide"
    echo "   ├── SETUP.md                  # Technology-specific setup"
    echo "   └── DEVELOPMENT-COORDINATION.md # Quick coordination reference"
    echo ""
    echo "🚀 Ready for Enhanced Multi-AUGGIE Development:"
    echo "   ✅ Native AUGGIE task management with parallel execution"
    echo "   ✅ Complete context materials from all specifications"
    echo "   ✅ Multi-agent orchestration tools and coordination"
    echo "   ✅ Portable AUGGIE commands for continued specification work"
    echo "   ✅ Dependency management and conflict prevention"
    echo "   ✅ Comprehensive development guidelines and workflows"
    echo ""
    echo "🎯 Next Steps:"
    echo "   1. cd \"$development_project_dir\""
    echo "   2. Review DEVELOPMENT-COORDINATION.md"
    echo "   3. Deploy multiple AUGGIE agents:"
    echo "      → AUGGIE 1: Setup and infrastructure tasks"
    echo "      → AUGGIE 2: Database and model tasks"
    echo "      → AUGGIE 3: API and service tasks"
    echo "      → AUGGIE 4: Frontend component tasks"
    echo "      → AUGGIE 5: Testing and validation tasks"
    echo "   4. Use 'auggie view_tasklist' to coordinate development"
    echo ""
    echo "⚡ Force Multiplier Effect: 5 AUGGIEs working in parallel!"

    # Create comprehensive project README for the exported workspace
    cat > "$development_project_dir/PROJECT-OVERVIEW.md" << EOF
# $project_name - Complete Specification Package

**Generated:** $(date)
**Spec-Kit Version:** Enhanced Multi-Project Architecture

## Project Summary
$(if [ -f "$project_dir/.project-meta.json" ]; then
    python3 -c "import json; data=json.load(open('$project_dir/.project-meta.json')); print(data.get('description', 'No description available'))" 2>/dev/null || echo "Complete specifications for the $project_name project."
else
    echo "Complete specifications for the $project_name project."
fi)

## Specification Package Contents

### Core Specifications
- **Scope Specification**: Project boundaries and requirements
- **Design Specification**: Visual design system and components
- **UX Specification**: User experience flows and interactions
- **Technical Specification**: Architecture and implementation details
- **Implementation Plan**: Development approach and strategy
- **Development Tasks**: Detailed task breakdown for implementation

### Context Materials
- **Context Directory**: Original planning documents (PRD, research, personas, etc.)
- **Project Guidelines**: AUGGIE-specific planning guidelines and constraints
- **Project Metadata**: Technical stack and complexity information

### Usage Instructions
1. Review context materials to understand project background
2. Review all specifications in order
3. Ensure all [NEEDS CLARIFICATION] items have been resolved
4. Use development-tasks.md as your implementation roadmap
5. Follow the technical specifications for architecture decisions
6. Reference context materials for business requirements and constraints

### Quality Assurance
✅ All specifications reviewed and approved
✅ No unresolved [NEEDS CLARIFICATION] items
✅ Complete specification package ready for development

---
*Generated by Spec-Kit AUGGIE Integration*
EOF

    echo "✅ Enhanced development workspace exported successfully!"
    echo "📊 Complete workspace with orchestrator tools created"
    echo "📁 Location: $development_project_dir"
    echo ""
    echo "🎉 Ready for multi-agent parallel development!"
}

# ============================================================================
# SMART APPROVAL GATE SYSTEM
# ============================================================================

# Check for [NEEDS CLARIFICATION] items in specifications
auggie-check-clarifications() {
    if [ $# -lt 2 ]; then
        echo "Usage: auggie-check-clarifications \"project-name\" \"spec-type\""
        return 1
    fi

    local project_name="$1"
    local spec_type="$2"
    local project_dir=$(get_project_dir "$project_name")

    # Find the most recent spec file of the given type
    local spec_file=""
    case "$spec_type" in
        "scope")
            spec_file=$(find "$project_dir/specs" -name "*scope*.md" -o -name "*spec.md" | head -1)
            ;;
        "design")
            spec_file=$(find "$project_dir/specs" -name "*design*.md" | head -1)
            ;;
        "ux")
            spec_file=$(find "$project_dir/specs" -name "*ux*.md" | head -1)
            ;;
        "technical")
            spec_file=$(find "$project_dir/specs" -name "*plan*.md" -o -name "*technical*.md" | head -1)
            ;;
        "tasks")
            spec_file=$(find "$project_dir/specs" -name "*tasks*.md" | head -1)
            ;;
        *)
            # Generic search for any spec file
            spec_file=$(find "$project_dir/specs" -name "*.md" | head -1)
            ;;
    esac

    if [ -z "$spec_file" ] || [ ! -f "$spec_file" ]; then
        echo "⚠️  No $spec_type specification file found for project '$project_name'"
        return 0
    fi

    # Count NEEDS CLARIFICATION items
    local clarifications=$(grep -c "NEEDS CLARIFICATION" "$spec_file" 2>/dev/null || echo "0")

    if [ "$clarifications" -gt 0 ]; then
        echo ""
        echo "⚠️  $clarifications items need clarification in $(basename "$spec_file")"
        echo ""
        echo "📋 Review Required Items:"
        grep -n "NEEDS CLARIFICATION" "$spec_file" | sed 's/^/  Line /' | head -10
        if [ "$clarifications" -gt 10 ]; then
            echo "  ... and $((clarifications - 10)) more items"
        fi
        echo ""
        echo "🔄 Please review and resolve these items before continuing."
        echo "   Edit file: $spec_file"
        echo "   Then run: auggie-approve-and-continue \"$project_name\""
        echo ""
        return 1
    fi

    echo "✅ No clarifications needed in $spec_type specification"
    return 0
}

# Approve and continue after resolving clarifications
auggie-approve-and-continue() {
    if [ $# -lt 1 ]; then
        echo "Usage: auggie-approve-and-continue \"project-name\""
        return 1
    fi

    local project_name="$1"
    local project_dir=$(get_project_dir "$project_name")

    # Check all specification files for remaining clarifications
    local total_clarifications=0
    local files_with_clarifications=()

    while IFS= read -r -d '' spec_file; do
        local clarifications=$(grep -c "NEEDS CLARIFICATION" "$spec_file" 2>/dev/null || echo "0")
        if [ "$clarifications" -gt 0 ]; then
            total_clarifications=$((total_clarifications + clarifications))
            files_with_clarifications+=("$(basename "$spec_file"): $clarifications items")
        fi
    done < <(find "$project_dir/specs" -name "*.md" -print0 2>/dev/null)

    if [ "$total_clarifications" -gt 0 ]; then
        echo "❌ Still $total_clarifications unresolved clarifications found:"
        printf '  %s\n' "${files_with_clarifications[@]}"
        echo ""
        echo "Please resolve all [NEEDS CLARIFICATION] items before continuing."
        return 1
    fi

    echo "✅ All clarifications resolved! Ready to continue with next phase."
    return 0
}

# Review milestone - batch review at major checkpoints
auggie-review-milestone() {
    if [ $# -lt 2 ]; then
        echo "Usage: auggie-review-milestone \"project-name\" \"milestone\""
        echo "Milestones: definition, technical, final"
        return 1
    fi

    local project_name="$1"
    local milestone="$2"
    local project_dir=$(get_project_dir "$project_name")

    echo "🎯 Reviewing $milestone milestone for project '$project_name'"
    echo ""

    local files_to_check=()
    case "$milestone" in
        "definition")
            files_to_check=("scope" "design" "ux")
            echo "📋 Definition Phase Review: Scope, Design, and UX specifications"
            ;;
        "technical")
            files_to_check=("technical" "plan")
            echo "🏗️  Technical Phase Review: Architecture and implementation planning"
            ;;
        "final")
            files_to_check=("tasks")
            echo "🚀 Final Phase Review: Development tasks and export readiness"
            ;;
        *)
            echo "❌ Unknown milestone: $milestone"
            echo "Available milestones: definition, technical, final"
            return 1
            ;;
    esac

    local total_clarifications=0
    local milestone_issues=()

    for spec_type in "${files_to_check[@]}"; do
        local spec_files=()
        case "$spec_type" in
            "scope")
                mapfile -t spec_files < <(find "$project_dir/specs" -name "*scope*.md" -o -name "*spec.md" 2>/dev/null)
                ;;
            "design")
                mapfile -t spec_files < <(find "$project_dir/specs" -name "*design*.md" 2>/dev/null)
                ;;
            "ux")
                mapfile -t spec_files < <(find "$project_dir/specs" -name "*ux*.md" 2>/dev/null)
                ;;
            "technical"|"plan")
                mapfile -t spec_files < <(find "$project_dir/specs" -name "*plan*.md" -o -name "*technical*.md" 2>/dev/null)
                ;;
            "tasks")
                mapfile -t spec_files < <(find "$project_dir/specs" -name "*tasks*.md" 2>/dev/null)
                ;;
        esac

        for spec_file in "${spec_files[@]}"; do
            if [ -f "$spec_file" ]; then
                local clarifications=$(grep -c "NEEDS CLARIFICATION" "$spec_file" 2>/dev/null || echo "0")
                if [ "$clarifications" -gt 0 ]; then
                    total_clarifications=$((total_clarifications + clarifications))
                    milestone_issues+=("$(basename "$spec_file"): $clarifications items")
                fi
            fi
        done
    done

    if [ "$total_clarifications" -gt 0 ]; then
        echo "⚠️  $total_clarifications items need clarification in $milestone phase:"
        printf '  %s\n' "${milestone_issues[@]}"
        echo ""
        echo "🔄 Please resolve all clarifications before milestone approval."
        echo "   Then run: auggie-approve-milestone \"$project_name\" \"$milestone\""
        return 1
    fi

    echo "✅ $milestone milestone review complete - no clarifications needed!"
    echo "🎉 Ready to proceed to next phase."
    return 0
}

# Approve milestone after review
auggie-approve-milestone() {
    if [ $# -lt 2 ]; then
        echo "Usage: auggie-approve-milestone \"project-name\" \"milestone\""
        return 1
    fi

    local project_name="$1"
    local milestone="$2"

    # Re-run milestone check to ensure everything is resolved
    if auggie-review-milestone "$project_name" "$milestone"; then
        echo ""
        echo "🎯 $milestone milestone approved for project '$project_name'"
        echo "✅ Proceeding to next development phase..."
        return 0
    else
        return 1
    fi
}

echo "✅ Enhanced AUGGIE CLI integration with multi-project support loaded."
echo "💡 Type 'auggie-help' for available commands or 'auggie-new-project' to get started."
