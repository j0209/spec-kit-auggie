#!/bin/bash
# AUGGIE Task Integration Script
# Integrates Spec-Kit generated tasks with Augment's task management system

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(pwd)"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log() {
    echo -e "${BLUE}[INTEGRATION]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

usage() {
    echo "AUGGIE Task Integration"
    echo ""
    echo "Integrates Spec-Kit generated tasks with Augment's task management system"
    echo ""
    echo "Usage: $0 <command> [options]"
    echo ""
    echo "Commands:"
    echo "  import <tasks.md>       Import Spec-Kit tasks into Augment"
    echo "  sync <tasks.md>         Sync task status between systems"
    echo "  status <tasks.md>       Show integration status"
    echo "  generate-commands       Generate Augment task commands"
    echo ""
    echo "Examples:"
    echo "  $0 import specs/001-feature/tasks.md"
    echo "  $0 sync specs/001-feature/tasks.md"
    echo "  $0 status specs/001-feature/tasks.md"
}

check_dependencies() {
    log "Checking dependencies..."
    
    if ! command -v python3 &> /dev/null; then
        error "Python3 not found"
        exit 1
    fi
    
    if ! command -v auggie &> /dev/null; then
        error "AUGGIE CLI not found. Install with: npm install -g @augmentcode/auggie"
        exit 1
    fi
    
    if [[ ! -f "$SCRIPT_DIR/spec-kit-augment-bridge.py" ]]; then
        error "Bridge script not found: $SCRIPT_DIR/spec-kit-augment-bridge.py"
        exit 1
    fi
    
    success "All dependencies found"
}

import_tasks() {
    local tasks_file="$1"
    
    if [[ ! -f "$tasks_file" ]]; then
        error "Tasks file not found: $tasks_file"
        exit 1
    fi
    
    log "Importing tasks from $tasks_file into Augment task management..."
    
    # Generate the integration commands
    local commands_file="/tmp/augment_task_commands.txt"
    python3 "$SCRIPT_DIR/spec-kit-augment-bridge.py" "$tasks_file" --commands > "$commands_file"
    
    if [[ ! -s "$commands_file" ]]; then
        error "Failed to generate task commands"
        exit 1
    fi
    
    log "Generated task import commands:"
    echo ""
    cat "$commands_file"
    echo ""
    
    # Create an AUGGIE command to execute the task imports
    local integration_prompt="
I need you to import Spec-Kit generated tasks into Augment's task management system.

Here are the tasks that need to be imported:

$(cat "$commands_file")

Please execute these commands to create the task structure in Augment's task management system. 

Use the following tools in sequence:
1. Use add_tasks() to create the root tasks (phases)
2. Use add_tasks() to create the subtasks with proper parent relationships
3. Use view_tasklist() to confirm the tasks were created correctly

Make sure to:
- Create tasks in the correct hierarchical order (phases first, then subtasks)
- Maintain the dependency relationships from the original Spec-Kit tasks
- Use descriptive names and detailed descriptions
- Set appropriate initial states (NOT_STARTED for new tasks)

After importing, provide a summary of what was created.
"
    
    log "Executing task import via AUGGIE..."
    echo "$integration_prompt" | auggie --print
    
    success "Task import completed! Use 'view_tasklist' to see the imported tasks."
    
    # Clean up
    rm -f "$commands_file"
}

sync_tasks() {
    local tasks_file="$1"
    
    if [[ ! -f "$tasks_file" ]]; then
        error "Tasks file not found: $tasks_file"
        exit 1
    fi
    
    log "Syncing task status between Spec-Kit and Augment..."
    
    # Read the current tasks.md to see which tasks are completed
    local completed_tasks=$(grep -E "^\s*- \[x\]" "$tasks_file" | sed -E 's/.*\[(x)\] (T[0-9]+).*/\2/' || true)
    
    if [[ -n "$completed_tasks" ]]; then
        log "Found completed tasks in Spec-Kit:"
        echo "$completed_tasks"
        
        # Generate sync command
        local sync_prompt="
I need to sync task completion status between Spec-Kit and Augment's task management system.

The following Spec-Kit tasks are marked as completed:
$completed_tasks

Please:
1. Use view_tasklist() to see the current task status in Augment
2. Use update_tasks() to mark the corresponding tasks as COMPLETE
3. Provide a summary of what was updated

Make sure to match the Spec-Kit task IDs (like T001, T002) with the corresponding Augment tasks.
"
        
        echo "$sync_prompt" | auggie --print
        success "Task synchronization completed!"
    else
        log "No completed tasks found in Spec-Kit"
    fi
}

show_status() {
    local tasks_file="$1"
    
    if [[ ! -f "$tasks_file" ]]; then
        error "Tasks file not found: $tasks_file"
        exit 1
    fi
    
    log "Integration Status for $tasks_file"
    echo "=================================="
    
    # Count tasks in Spec-Kit
    local total_tasks=$(grep -c "^\s*- \[ \]" "$tasks_file" || echo "0")
    local completed_tasks=$(grep -c "^\s*- \[x\]" "$tasks_file" || echo "0")
    local pending_tasks=$((total_tasks - completed_tasks))
    
    echo "Spec-Kit Tasks:"
    echo "  Total: $total_tasks"
    echo "  Completed: $completed_tasks"
    echo "  Pending: $pending_tasks"
    echo ""
    
    # Check if bridge file exists
    local bridge_file="$SCRIPT_DIR/spec-kit-augment-bridge.py"
    if [[ -f "$bridge_file" ]]; then
        echo "✅ Integration bridge available"
    else
        echo "❌ Integration bridge missing"
    fi
    
    # Check if AUGGIE is available
    if command -v auggie &> /dev/null; then
        echo "✅ AUGGIE CLI available"
    else
        echo "❌ AUGGIE CLI not found"
    fi
    
    echo ""
    echo "To import tasks into Augment:"
    echo "  $0 import $tasks_file"
    echo ""
    echo "To sync completed tasks:"
    echo "  $0 sync $tasks_file"
}

generate_commands() {
    local tasks_file="$1"
    
    if [[ ! -f "$tasks_file" ]]; then
        error "Tasks file not found: $tasks_file"
        exit 1
    fi
    
    log "Generating Augment task management commands..."
    python3 "$SCRIPT_DIR/spec-kit-augment-bridge.py" "$tasks_file" --commands
}

# Main command handling
case "${1:-}" in
    "import")
        if [[ -z "$2" ]]; then
            error "Please specify a tasks.md file"
            usage
            exit 1
        fi
        check_dependencies
        import_tasks "$2"
        ;;
    "sync")
        if [[ -z "$2" ]]; then
            error "Please specify a tasks.md file"
            usage
            exit 1
        fi
        check_dependencies
        sync_tasks "$2"
        ;;
    "status")
        if [[ -z "$2" ]]; then
            error "Please specify a tasks.md file"
            usage
            exit 1
        fi
        show_status "$2"
        ;;
    "generate-commands")
        if [[ -z "$2" ]]; then
            error "Please specify a tasks.md file"
            usage
            exit 1
        fi
        check_dependencies
        generate_commands "$2"
        ;;
    *)
        usage
        exit 1
        ;;
esac
