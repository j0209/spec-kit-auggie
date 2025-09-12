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

# AUGGIE-Specify: Create specifications using AUGGIE CLI
auggie-specify() {
    if [ $# -eq 0 ]; then
        echo "Usage: auggie-specify \"Feature description\""
        echo "Example: auggie-specify \"Add user authentication with JWT tokens\""
        return 1
    fi
    
    local repo_root=$(get_repo_root)
    local feature_description="$*"
    
    echo "🌱 Starting Spec-Driven Development with AUGGIE..."
    echo "📝 Feature: $feature_description"
    echo ""
    
    # Use AUGGIE CLI to execute the specify command
    cd "$repo_root" && auggie --print "
    I need you to execute the /specify command for Spec-Driven Development.
    
    Load the command definition from templates/commands/auggie/specify.md and follow its instructions exactly.
    
    Feature description: $feature_description
    
    Remember to:
    1. Use your context engine to understand the existing codebase
    2. Follow the SDD methodology from AUGGIE.md
    3. Apply organizational constraints from memory/constitution.md
    4. Generate production-ready specifications
    
    Execute the specify command now.
    "
}

# AUGGIE-Plan: Create implementation plans using AUGGIE CLI
auggie-plan() {
    if [ $# -eq 0 ]; then
        echo "Usage: auggie-plan \"Technical implementation details\""
        echo "Example: auggie-plan \"Use Express.js with PostgreSQL database and JWT authentication\""
        return 1
    fi
    
    local repo_root=$(get_repo_root)
    local implementation_details="$*"
    
    echo "🏗️  Creating implementation plan with AUGGIE..."
    echo "⚙️  Details: $implementation_details"
    echo ""
    
    # Use AUGGIE CLI to execute the plan command
    cd "$repo_root" && auggie --print "
    I need you to execute the /plan command for Spec-Driven Development.
    
    Load the command definition from templates/commands/auggie/plan.md and follow its instructions exactly.
    
    Implementation details: $implementation_details
    
    Remember to:
    1. Use your context engine to analyze existing architecture
    2. Read and apply the constitution constraints
    3. Generate realistic implementation plans
    4. Create all required artifacts
    
    Execute the plan command now.
    "
}

# AUGGIE-Tasks: Generate task lists using AUGGIE CLI
auggie-tasks() {
    local repo_root=$(get_repo_root)
    local context_info="$*"
    
    echo "📋 Generating executable tasks with AUGGIE..."
    if [ -n "$context_info" ]; then
        echo "📌 Context: $context_info"
    fi
    echo ""
    
    # Use AUGGIE CLI to execute the tasks command
    cd "$repo_root" && auggie --print "
    I need you to execute the /tasks command for Spec-Driven Development.
    
    Load the command definition from templates/commands/auggie/tasks.md and follow its instructions exactly.
    
    Additional context: $context_info
    
    Remember to:
    1. Use your context engine to understand existing patterns
    2. Create realistic, executable tasks
    3. Identify parallel execution opportunities
    4. Base estimates on actual codebase complexity
    
    Execute the tasks command now.
    "

    # Auto-import into Augment task management if integration is available
    local latest_tasks_file=$(find "$repo_root/specs" -name "tasks.md" -type f | head -1)
    if [[ -n "$latest_tasks_file" && -f "$repo_root/auggie-task-integration.sh" ]]; then
        echo ""
        echo "🔄 Auto-importing tasks into Augment task management..."
        "$repo_root/auggie-task-integration.sh" import "$latest_tasks_file"
        echo ""
        echo "✅ Tasks imported into Augment! Use 'auggie view_tasklist' to see them."
    fi

    echo ""
    echo "📋 Task generation completed!"
    echo ""
    echo "Next steps:"
    echo "  1. Review tasks: auggie 'view_tasklist'"
    echo "  2. Start implementing: auggie 'Implement task T001'"
    echo "  3. Track progress: auggie-status"
}

# AUGGIE-Task-Import: Import Spec-Kit tasks into Augment task management
auggie-task-import() {
    local repo_root=$(get_repo_root)
    local tasks_file="$1"

    if [[ -z "$tasks_file" ]]; then
        # Find the most recent tasks.md file
        tasks_file=$(find "$repo_root/specs" -name "tasks.md" -type f | head -1)
        if [[ -z "$tasks_file" ]]; then
            echo "❌ No tasks.md file found. Run auggie-tasks first."
            return 1
        fi
    fi

    if [[ ! -f "$repo_root/auggie-task-integration.sh" ]]; then
        echo "❌ Task integration script not found. Please ensure auggie-task-integration.sh is in the project root."
        return 1
    fi

    echo "📥 Importing Spec-Kit tasks into Augment task management..."
    "$repo_root/auggie-task-integration.sh" import "$tasks_file"
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
    echo "🚀 Enhanced AUGGIE CLI Integration for Complete Spec-Driven Development"
    echo ""
    echo "📋 Core Specification Commands:"
    echo "  auggie-specify \"Feature description\"     - Create technical specifications"
    echo "  auggie-plan \"Implementation details\"      - Create implementation plans"
    echo "  auggie-tasks                              - Generate task breakdowns"
    echo ""
    echo "🎨 Design & UX Commands:"
    echo "  auggie-design-spec \"Design description\"   - Create visual design specifications"
    echo "  auggie-ux-spec \"UX flow description\"      - Create user experience specifications"
    echo "  auggie-component-design \"Component desc\"  - Create component design specifications"
    echo ""
    echo "🎯 Project Management Commands:"
    echo "  auggie-scope-spec \"Feature\" [--complexity=simple|enterprise] - Create pragmatic scope specifications"
    echo ""
    echo "🔧 Task Management Commands:"
    echo "  auggie-task-import [file]                 - Import tasks into Augment task management"
    echo "  auggie-task-sync [file]                   - Sync task completion status"
    echo "  auggie-status                             - Check project SDD status"
    echo ""
    echo "ℹ️  Utility Commands:"
    echo "  auggie-help                               - Show this help"
    echo ""
    echo "🔄 Complete Workflow Example:"
    echo "  1. auggie-scope-spec \"User management\" --complexity=simple"
    echo "  2. auggie-design-spec \"Clean, modern user interface\""
    echo "  3. auggie-ux-spec \"Intuitive user onboarding flow\""
    echo "  4. auggie-specify \"User authentication with JWT tokens\""
    echo "  5. auggie-plan \"Use JWT with Express and PostgreSQL\""
    echo "  6. auggie-tasks"
    echo "  7. Execute tasks with AUGGIE agents"
    echo ""
    echo "For complete documentation, see README.md"
}

# Enhanced AUGGIE Commands for Complete Project Development

# AUGGIE-Design-Spec: Create comprehensive design specifications
auggie-design-spec() {
    if [ $# -eq 0 ]; then
        echo "Usage: auggie-design-spec \"Design description\""
        echo "Example: auggie-design-spec \"Modern SaaS dashboard with clean aesthetics\""
        return 1
    fi

    local repo_root=$(get_repo_root)
    local design_description="$*"

    echo "🎨 Creating comprehensive design specification with AUGGIE..."
    echo "📝 Design: $design_description"
    echo ""

    cd "$repo_root" && auggie --print "
    I need you to create a comprehensive design specification for: $design_description

    Load the command definition from templates/commands/auggie/design-spec.md and follow its instructions exactly.

    Generate:
    1. Visual Design System (colors, typography, spacing, components)
    2. Layout Wireframes (component placement and hierarchy)
    3. Responsive Breakpoints (mobile-first design specifications)
    4. Accessibility Requirements (WCAG 2.1 AA compliance)
    5. Brand Guidelines (visual identity and voice)

    Use your context engine to:
    - Analyze existing design patterns in the codebase
    - Ensure consistency with current visual elements
    - Apply modern design best practices
    - Create pragmatic, maintainable design specifications

    Execute the design specification command now.
    "
}

# AUGGIE-UX-Spec: Create user experience flow specifications
auggie-ux-spec() {
    if [ $# -eq 0 ]; then
        echo "Usage: auggie-ux-spec \"UX flow description\""
        echo "Example: auggie-ux-spec \"User onboarding with progressive disclosure\""
        return 1
    fi

    local repo_root=$(get_repo_root)
    local ux_description="$*"

    echo "🧭 Creating comprehensive UX specification with AUGGIE..."
    echo "📝 UX Flow: $ux_description"
    echo ""

    cd "$repo_root" && auggie --print "
    I need you to create a comprehensive UX specification for: $ux_description

    Load the command definition from templates/commands/auggie/ux-spec.md and follow its instructions exactly.

    Generate:
    1. User Journey Maps (step-by-step flows with decision points)
    2. Interaction Specifications (hover, focus, loading states)
    3. Error State Handling (user-friendly messages and recovery)
    4. Micro-interaction Details (animations, transitions, feedback)
    5. Content Guidelines (copy, placeholders, empty states)

    Use your context engine to:
    - Understand existing user flows and patterns
    - Ensure consistency with current UX patterns
    - Apply modern UX best practices
    - Create intuitive, accessible user experiences

    Execute the UX specification command now.
    "
}

# AUGGIE-Component-Design: Create detailed component design specifications
auggie-component-design() {
    if [ $# -eq 0 ]; then
        echo "Usage: auggie-component-design \"Component description\""
        echo "Example: auggie-component-design \"Data table with filtering and pagination\""
        return 1
    fi

    local repo_root=$(get_repo_root)
    local component_description="$*"

    echo "🧩 Creating component design specification with AUGGIE..."
    echo "📝 Component: $component_description"
    echo ""

    cd "$repo_root" && auggie --print "
    I need you to create a detailed component design specification for: $component_description

    Load the command definition from templates/commands/auggie/component-design.md and follow its instructions exactly.

    Generate:
    1. Visual Component Specs (styling, states, variants)
    2. Interaction Behavior (click, hover, focus, disabled states)
    3. Content Guidelines (text, placeholders, error messages)
    4. Responsive Behavior (adaptation across screen sizes)
    5. Animation Specifications (timing, easing, duration)

    Use your context engine to:
    - Analyze existing component patterns
    - Ensure consistency with design system
    - Create reusable, maintainable components
    - Apply accessibility best practices

    Execute the component design specification command now.
    "
}

# AUGGIE-Scope-Spec: Create pragmatic scope specifications with complexity control
auggie-scope-spec() {
    local complexity="simple"
    local description=""

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --complexity=*)
                complexity="${1#*=}"
                shift
                ;;
            *)
                description="$description $1"
                shift
                ;;
        esac
    done

    if [ -z "$description" ]; then
        echo "Usage: auggie-scope-spec \"Feature description\" [--complexity=simple|enterprise]"
        echo "Example: auggie-scope-spec \"User management\" --complexity=simple"
        return 1
    fi

    local repo_root=$(get_repo_root)
    description=$(echo "$description" | xargs) # trim whitespace

    echo "🎯 Creating pragmatic scope specification with AUGGIE..."
    echo "📝 Feature: $description"
    echo "🔧 Complexity: $complexity"
    echo ""

    cd "$repo_root" && auggie --print "
    I need you to create a pragmatic scope specification for: $description

    Complexity level: $complexity

    Load the command definition from templates/commands/auggie/scope-spec.md and follow its instructions exactly.

    For complexity level '$complexity':
    - Simple: Basic CRUD, standard patterns, essential features only
    - Enterprise: Advanced features, complex validation, full feature set

    Generate:
    1. Core Requirements (MVP features)
    2. Future Enhancements (post-MVP features)
    3. Explicitly NOT Included (scope boundaries)
    4. Technology Pragmatism (appropriate tech choices)
    5. Maintenance Considerations (long-term sustainability)

    Use your context engine to:
    - Understand existing architecture patterns
    - Avoid over-engineering
    - Create maintainable, pragmatic solutions
    - Apply appropriate complexity for the use case

    Execute the scope specification command now.
    "
}

echo "✅ Enhanced AUGGIE CLI integration loaded. Type 'auggie-help' for available commands."
