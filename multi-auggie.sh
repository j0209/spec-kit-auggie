#!/bin/bash
# Multi-AUGGIE Force Multiplier for Spec-Driven Development
# Orchestrates multiple AUGGIE instances working in parallel on different components

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(pwd)"
WORK_DIR="$PROJECT_ROOT/.multi-auggie"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Agent configurations
declare -A AGENTS=(
    ["frontend"]="Frontend Specialist:frontend,ui,react,vue,angular,css,html,javascript,typescript"
    ["backend"]="Backend Specialist:backend,api,server,node,python,java,go,rust,database"
    ["database"]="Database Specialist:database,sql,migration,schema,postgres,mysql,mongodb"
    ["testing"]="Testing Specialist:testing,test,spec,unit,integration,e2e,cypress,jest"
    ["devops"]="DevOps Specialist:devops,deployment,ci,cd,docker,kubernetes,infrastructure"
)

usage() {
    echo "Multi-AUGGIE Force Multiplier"
    echo ""
    echo "Usage: $0 <command> [options]"
    echo ""
    echo "Commands:"
    echo "  init <feature-path>     Initialize multi-agent workspace from spec"
    echo "  status                  Show status of all agents and tasks"
    echo "  assign                  Assign tasks to available agents"
    echo "  execute                 Execute assigned tasks in parallel"
    echo "  orchestrate             Full orchestration (assign + execute loop)"
    echo "  merge                   Merge completed work back to main project"
    echo "  cleanup                 Clean up workspace"
    echo ""
    echo "Options:"
    echo "  --agents <list>         Comma-separated list of agents to use"
    echo "                         Available: ${!AGENTS[@]}"
    echo "  --dry-run              Show what would be done without executing"
    echo "  --parallel <n>         Max parallel agents (default: 4)"
    echo ""
    echo "Examples:"
    echo "  $0 init specs/001-user-auth"
    echo "  $0 orchestrate --agents frontend,backend,database"
    echo "  $0 status"
}

log() {
    echo -e "${BLUE}[$(date +'%H:%M:%S')]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

check_dependencies() {
    log "Checking dependencies..."
    
    if ! command -v auggie &> /dev/null; then
        error "AUGGIE CLI not found. Install with: npm install -g @augmentcode/auggie"
        exit 1
    fi
    
    if ! command -v jq &> /dev/null; then
        error "jq not found. Install with: brew install jq (macOS) or apt-get install jq (Linux)"
        exit 1
    fi
    
    success "All dependencies found"
}

init_workspace() {
    local feature_path="$1"
    
    if [[ ! -d "$feature_path" ]]; then
        error "Feature path not found: $feature_path"
        exit 1
    fi
    
    log "Initializing multi-agent workspace for: $feature_path"
    
    # Create workspace
    mkdir -p "$WORK_DIR"
    
    # Copy specifications and context
    cp -r "$feature_path" "$WORK_DIR/specs/"
    
    if [[ -d "memory" ]]; then
        cp -r memory "$WORK_DIR/"
    fi
    
    if [[ -d "templates" ]]; then
        cp -r templates "$WORK_DIR/"
    fi
    
    # Parse tasks from tasks.md
    if [[ -f "$feature_path/tasks.md" ]]; then
        parse_tasks "$feature_path/tasks.md"
    else
        error "tasks.md not found in $feature_path"
        exit 1
    fi
    
    # Initialize agent workspaces
    for agent_id in "${!AGENTS[@]}"; do
        init_agent_workspace "$agent_id"
    done
    
    success "Workspace initialized at $WORK_DIR"
}

parse_tasks() {
    local tasks_file="$1"
    local tasks_json="$WORK_DIR/tasks.json"
    
    log "Parsing tasks from $tasks_file"
    
    # Simple parser for tasks.md format
    python3 << EOF
import re
import json
import sys

tasks = []
current_task = None

with open('$tasks_file', 'r') as f:
    content = f.read()

# Split by task headers
task_sections = re.split(r'^### (T\d+):', content, flags=re.MULTILINE)

for i in range(1, len(task_sections), 2):
    task_id = task_sections[i].strip()
    task_content = task_sections[i+1] if i+1 < len(task_sections) else ""
    
    # Extract task details
    description_match = re.search(r'\*\*Description:\*\*\s*(.+?)(?=\n\*\*|\n\n|\$)', task_content, re.DOTALL)
    files_match = re.search(r'\*\*Files:\*\*\s*(.+?)(?=\n\*\*|\n\n|\$)', task_content)
    component_match = re.search(r'\*\*Component:\*\*\s*(.+?)(?=\n\*\*|\n\n|\$)', task_content)
    deps_match = re.search(r'\*\*Dependencies:\*\*\s*(.+?)(?=\n\*\*|\n\n|\$)', task_content)
    
    task = {
        'id': task_id,
        'description': description_match.group(1).strip() if description_match else '',
        'component': component_match.group(1).strip() if component_match else 'general',
        'files': [f.strip() for f in files_match.group(1).split(',') if f.strip()] if files_match else [],
        'dependencies': [d.strip() for d in deps_match.group(1).split(',') if d.strip()] if deps_match else [],
        'parallel_safe': '[P]' in task_content,
        'status': 'pending',
        'assigned_agent': None
    }
    
    tasks.append(task)

with open('$tasks_json', 'w') as f:
    json.dump(tasks, f, indent=2)

print(f"Parsed {len(tasks)} tasks")
EOF
    
    success "Parsed $(jq length "$tasks_json") tasks"
}

init_agent_workspace() {
    local agent_id="$1"
    local agent_dir="$WORK_DIR/agents/$agent_id"
    
    mkdir -p "$agent_dir"
    
    # Copy shared context
    cp -r "$WORK_DIR/specs" "$agent_dir/"
    cp -r "$WORK_DIR/memory" "$agent_dir/" 2>/dev/null || true
    cp -r "$WORK_DIR/templates" "$agent_dir/" 2>/dev/null || true
    
    # Create agent-specific context
    local agent_info="${AGENTS[$agent_id]}"
    local agent_name="${agent_info%%:*}"
    local specializations="${agent_info##*:}"
    
    cat > "$agent_dir/AGENT_CONTEXT.md" << EOF
# Agent Context: $agent_name

## Specialization
You are the **$agent_name** in a multi-agent development team.

## Your Expertise
- Primary focus: $agent_id
- Keywords: ${specializations//,/, }

## Coordination Guidelines
1. Follow specifications in specs/ directory
2. Apply constitution from memory/constitution.md
3. Focus on your specialization area
4. Coordinate through shared specifications
5. Avoid conflicts with other agents' work areas

## Working Mode
- You are part of a parallel development team
- Other agents are working on different components simultaneously
- Ensure your work integrates well with the overall architecture
- Follow the established patterns and conventions

## Current Task
Your current task will be provided via command line context.
EOF
    
    # Initialize status
    echo '{"status": "idle", "current_task": null, "last_activity": null}' > "$agent_dir/status.json"
}

assign_tasks() {
    local tasks_json="$WORK_DIR/tasks.json"
    local dry_run="$1"
    
    log "Assigning tasks to agents..."
    
    # Simple assignment algorithm
    python3 << EOF
import json
import re

# Load tasks
with open('$tasks_json', 'r') as f:
    tasks = json.load(f)

# Agent specializations
agents = {
    'frontend': ['frontend', 'ui', 'react', 'vue', 'angular', 'css', 'html', 'javascript', 'typescript'],
    'backend': ['backend', 'api', 'server', 'node', 'python', 'java', 'go', 'rust'],
    'database': ['database', 'sql', 'migration', 'schema', 'postgres', 'mysql', 'mongodb'],
    'testing': ['testing', 'test', 'spec', 'unit', 'integration', 'e2e', 'cypress', 'jest'],
    'devops': ['devops', 'deployment', 'ci', 'cd', 'docker', 'kubernetes', 'infrastructure']
}

def score_agent_for_task(agent_id, task):
    score = 0
    keywords = agents[agent_id]
    
    # Check component match
    for keyword in keywords:
        if keyword in task['component'].lower():
            score += 10
        if keyword in task['description'].lower():
            score += 5
    
    return score

def can_assign_task(task, tasks):
    # Check dependencies
    for dep_id in task['dependencies']:
        for other_task in tasks:
            if other_task['id'] == dep_id and other_task['status'] != 'completed':
                return False
    
    # Check file conflicts (if not parallel safe)
    if not task['parallel_safe']:
        for other_task in tasks:
            if (other_task['status'] == 'assigned' and 
                set(task['files']) & set(other_task['files'])):
                return False
    
    return True

# Assign tasks
assignments = []
for task in tasks:
    if task['status'] == 'pending' and can_assign_task(task, tasks):
        # Find best agent
        best_agent = None
        best_score = -1
        
        for agent_id in agents.keys():
            score = score_agent_for_task(agent_id, task)
            if score > best_score:
                best_score = score
                best_agent = agent_id
        
        if best_agent:
            task['status'] = 'assigned'
            task['assigned_agent'] = best_agent
            assignments.append((task['id'], best_agent, task['description']))

# Save updated tasks
with open('$tasks_json', 'w') as f:
    json.dump(tasks, f, indent=2)

# Print assignments
for task_id, agent, description in assignments:
    print(f"✓ {task_id} → {agent}: {description[:60]}...")

print(f"\nAssigned {len(assignments)} tasks")
EOF
}

execute_tasks() {
    local dry_run="$1"
    local max_parallel="${2:-4}"
    
    log "Executing assigned tasks (max parallel: $max_parallel)"
    
    # Get assigned tasks
    local assigned_tasks=$(jq -r '.[] | select(.status == "assigned") | "\(.id):\(.assigned_agent)"' "$WORK_DIR/tasks.json")
    
    if [[ -z "$assigned_tasks" ]]; then
        warn "No tasks assigned for execution"
        return
    fi
    
    # Execute tasks in parallel
    local pids=()
    local count=0
    
    while IFS=':' read -r task_id agent_id; do
        if [[ $count -ge $max_parallel ]]; then
            # Wait for one to complete
            wait -n
            ((count--))
        fi
        
        execute_single_task "$task_id" "$agent_id" "$dry_run" &
        pids+=($!)
        ((count++))
        
    done <<< "$assigned_tasks"
    
    # Wait for all to complete
    for pid in "${pids[@]}"; do
        wait "$pid"
    done
    
    success "All assigned tasks completed"
}

execute_single_task() {
    local task_id="$1"
    local agent_id="$2"
    local dry_run="$3"
    
    local agent_dir="$WORK_DIR/agents/$agent_id"
    local task_info=$(jq -r ".[] | select(.id == \"$task_id\")" "$WORK_DIR/tasks.json")
    local description=$(echo "$task_info" | jq -r '.description')
    
    log "${PURPLE}[$agent_id]${NC} Starting task $task_id"
    
    if [[ "$dry_run" == "true" ]]; then
        echo "  Would execute: $description"
        return
    fi
    
    # Update task status
    jq "(.[] | select(.id == \"$task_id\") | .status) = \"in_progress\"" "$WORK_DIR/tasks.json" > "$WORK_DIR/tasks.json.tmp"
    mv "$WORK_DIR/tasks.json.tmp" "$WORK_DIR/tasks.json"
    
    # Build AUGGIE command
    local context="You are working on task $task_id: $description. Follow the specifications and your agent context."
    
    # Execute AUGGIE
    cd "$agent_dir"
    if auggie --print "$context" > "output_$task_id.txt" 2>&1; then
        # Mark as completed
        jq "(.[] | select(.id == \"$task_id\") | .status) = \"completed\"" "$WORK_DIR/tasks.json" > "$WORK_DIR/tasks.json.tmp"
        mv "$WORK_DIR/tasks.json.tmp" "$WORK_DIR/tasks.json"
        success "${PURPLE}[$agent_id]${NC} Completed task $task_id"
    else
        # Mark as failed
        jq "(.[] | select(.id == \"$task_id\") | .status) = \"failed\"" "$WORK_DIR/tasks.json" > "$WORK_DIR/tasks.json.tmp"
        mv "$WORK_DIR/tasks.json.tmp" "$WORK_DIR/tasks.json"
        error "${PURPLE}[$agent_id]${NC} Failed task $task_id"
    fi
}

show_status() {
    if [[ ! -f "$WORK_DIR/tasks.json" ]]; then
        error "No workspace found. Run 'init' first."
        exit 1
    fi
    
    echo -e "${CYAN}Multi-AUGGIE Status Report${NC}"
    echo "=========================="
    
    # Task summary
    local total=$(jq length "$WORK_DIR/tasks.json")
    local pending=$(jq '[.[] | select(.status == "pending")] | length' "$WORK_DIR/tasks.json")
    local assigned=$(jq '[.[] | select(.status == "assigned")] | length' "$WORK_DIR/tasks.json")
    local in_progress=$(jq '[.[] | select(.status == "in_progress")] | length' "$WORK_DIR/tasks.json")
    local completed=$(jq '[.[] | select(.status == "completed")] | length' "$WORK_DIR/tasks.json")
    local failed=$(jq '[.[] | select(.status == "failed")] | length' "$WORK_DIR/tasks.json")
    
    echo "Tasks: $total total, $pending pending, $assigned assigned, $in_progress in progress, $completed completed, $failed failed"
    echo ""
    
    # Agent status
    echo "Agent Status:"
    for agent_id in "${!AGENTS[@]}"; do
        local agent_tasks=$(jq -r "[.[] | select(.assigned_agent == \"$agent_id\")] | length" "$WORK_DIR/tasks.json")
        local agent_name="${AGENTS[$agent_id]%%:*}"
        echo "  $agent_name: $agent_tasks tasks"
    done
}

# Main command handling
case "${1:-}" in
    "init")
        check_dependencies
        init_workspace "$2"
        ;;
    "assign")
        assign_tasks "${2:-false}"
        ;;
    "execute")
        execute_tasks "${2:-false}" "${3:-4}"
        ;;
    "orchestrate")
        check_dependencies
        log "Starting full orchestration..."
        while true; do
            assign_tasks false
            execute_tasks false 4
            
            # Check if done
            local remaining=$(jq '[.[] | select(.status == "pending" or .status == "assigned")] | length' "$WORK_DIR/tasks.json")
            if [[ $remaining -eq 0 ]]; then
                success "🎉 All tasks completed!"
                break
            fi
            
            sleep 2
        done
        ;;
    "status")
        show_status
        ;;
    "cleanup")
        rm -rf "$WORK_DIR"
        success "Workspace cleaned up"
        ;;
    *)
        usage
        exit 1
        ;;
esac
