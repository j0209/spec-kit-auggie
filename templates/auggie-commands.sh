#!/bin/bash
# AUGGIE CLI Integration for Spec-Driven Development
# Source this file to enable auggie-specify, auggie-plan, and auggie-tasks commands

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
    echo "🌱 AUGGIE CLI Integration for Spec-Driven Development"
    echo ""
    echo "Available commands:"
    echo "  auggie-specify \"description\"  - Create feature specifications"
    echo "  auggie-plan \"tech details\"    - Create implementation plans"
    echo "  auggie-tasks [context]         - Generate executable tasks"
    echo "  auggie-task-import [file]      - Import tasks into Augment task management"
    echo "  auggie-task-sync [file]        - Sync task completion status"
    echo "  auggie-status                  - Check project SDD status"
    echo "  auggie-help                    - Show this help"
    echo ""
    echo "Workflow:"
    echo "  1. auggie-specify \"Add user login feature\""
    echo "  2. auggie-plan \"Use JWT with Express and PostgreSQL\""
    echo "  3. auggie-tasks"
    echo "  4. Implement the generated tasks"
    echo ""
    echo "For more information, see AUGGIE.md"
}

echo "✅ AUGGIE CLI integration loaded. Type 'auggie-help' for available commands."
