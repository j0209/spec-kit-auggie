#!/usr/bin/env python3
"""
SpecKit Task Manager
Simple utility to manage development tasks for the SpecKit project
"""

import json
import sys
from pathlib import Path
from datetime import datetime

def load_tasks():
    """Load tasks from tasks.json"""
    tasks_file = Path(__file__).parent / "tasks.json"
    if not tasks_file.exists():
        print("❌ tasks.json not found!")
        return None
    
    with open(tasks_file, 'r') as f:
        return json.load(f)

def save_tasks(data):
    """Save tasks to tasks.json"""
    tasks_file = Path(__file__).parent / "tasks.json"
    with open(tasks_file, 'w') as f:
        json.dump(data, f, indent=2)

def list_tasks():
    """List all tasks with their status"""
    data = load_tasks()
    if not data:
        return
    
    print(f"\n🚀 {data['project']} Development Tasks")
    print(f"📅 Created: {data['created']}")
    print(f"📊 Total: {data['summary']['total_tasks']} main tasks, {data['summary']['total_subtasks']} subtasks")
    print(f"⏱️  Estimated: {data['summary']['estimated_total_hours']} hours\n")
    
    for task in data['tasks']:
        status_icon = "✅" if task['status'] == 'completed' else "🔄" if task['status'] == 'in_progress' else "⭕"
        priority_icon = "🔥" if task['priority'] == 'high' else "📋"
        
        print(f"{status_icon} {priority_icon} {task['id']}: {task['name']}")
        print(f"   📝 {task['description'][:80]}...")
        
        # Show subtasks
        completed_subtasks = sum(1 for st in task['subtasks'] if st['status'] == 'completed')
        total_subtasks = len(task['subtasks'])
        print(f"   📊 Subtasks: {completed_subtasks}/{total_subtasks} completed")
        
        # Sort subtasks by execution order
        sorted_subtasks = sorted(task['subtasks'], key=lambda x: x.get('execution_order', 1))

        for subtask in sorted_subtasks:
            sub_icon = "✅" if subtask['status'] == 'completed' else "🔄" if subtask['status'] == 'in_progress' else "⭕"
            parallel_marker = "🔀" if subtask.get('parallel', False) else "➡️"
            deps = subtask.get('dependencies', [])
            dep_info = f" (deps: {', '.join(deps)})" if deps else ""
            print(f"      {sub_icon} {parallel_marker} {subtask['id']}: {subtask['name']}{dep_info}")
        print()

def start_task(task_id):
    """Mark a task as in progress"""
    data = load_tasks()
    if not data:
        return
    
    # Find and update task
    for task in data['tasks']:
        if task['id'] == task_id:
            task['status'] = 'in_progress'
            task['started_at'] = datetime.now().isoformat()
            save_tasks(data)
            print(f"✅ Started task {task_id}: {task['name']}")
            return
        
        # Check subtasks
        for subtask in task['subtasks']:
            if subtask['id'] == task_id:
                subtask['status'] = 'in_progress'
                subtask['started_at'] = datetime.now().isoformat()
                save_tasks(data)
                print(f"✅ Started subtask {task_id}: {subtask['name']}")
                return
    
    print(f"❌ Task {task_id} not found!")

def complete_task(task_id):
    """Mark a task as completed"""
    data = load_tasks()
    if not data:
        return
    
    # Find and update task
    for task in data['tasks']:
        if task['id'] == task_id:
            task['status'] = 'completed'
            task['completed_at'] = datetime.now().isoformat()
            save_tasks(data)
            print(f"🎉 Completed task {task_id}: {task['name']}")
            return
        
        # Check subtasks
        for subtask in task['subtasks']:
            if subtask['id'] == task_id:
                subtask['status'] = 'completed'
                subtask['completed_at'] = datetime.now().isoformat()
                save_tasks(data)
                print(f"🎉 Completed subtask {task_id}: {subtask['name']}")
                return
    
    print(f"❌ Task {task_id} not found!")

def show_execution_plan():
    """Show execution plan with parallel and sequential ordering"""
    data = load_tasks()
    if not data:
        return

    print(f"\n🎯 {data['project']} Execution Plan")
    print("=" * 50)

    for task in data['tasks']:
        print(f"\n📋 {task['id']}: {task['name']}")

        # Group subtasks by execution order
        order_groups = {}
        for subtask in task['subtasks']:
            order = subtask.get('execution_order', 1)
            if order not in order_groups:
                order_groups[order] = []
            order_groups[order].append(subtask)

        # Display by execution order
        for order in sorted(order_groups.keys()):
            print(f"\n   Phase {order}:")
            parallel_tasks = [st for st in order_groups[order] if st.get('parallel', False)]
            sequential_tasks = [st for st in order_groups[order] if not st.get('parallel', False)]

            if parallel_tasks:
                print("   🔀 Parallel execution (can run simultaneously):")
                for subtask in parallel_tasks:
                    deps = subtask.get('dependencies', [])
                    dep_info = f" (after: {', '.join(deps)})" if deps else ""
                    print(f"      • {subtask['id']}: {subtask['name']}{dep_info}")

            if sequential_tasks:
                print("   ➡️  Sequential execution:")
                for subtask in sequential_tasks:
                    deps = subtask.get('dependencies', [])
                    dep_info = f" (after: {', '.join(deps)})" if deps else ""
                    print(f"      • {subtask['id']}: {subtask['name']}{dep_info}")

def show_help():
    """Show help information"""
    print("""
🚀 SpecKit Task Manager

Usage:
    python .augment/task-manager.py [command] [args]

Commands:
    list                    List all tasks and their status
    plan                    Show execution plan with parallel/sequential ordering
    start <task-id>         Mark a task as in progress
    complete <task-id>      Mark a task as completed
    help                    Show this help message

Symbols:
    🔀 = Parallel execution (can run simultaneously)
    ➡️  = Sequential execution (must run in order)
    [P] = Parallel marker in task name

Examples:
    python .augment/task-manager.py list
    python .augment/task-manager.py plan
    python .augment/task-manager.py start SPEC-001-1
    python .augment/task-manager.py complete SPEC-001-1
""")

def main():
    if len(sys.argv) < 2:
        list_tasks()
        return
    
    command = sys.argv[1].lower()
    
    if command == 'list':
        list_tasks()
    elif command == 'plan':
        show_execution_plan()
    elif command == 'start' and len(sys.argv) > 2:
        start_task(sys.argv[2])
    elif command == 'complete' and len(sys.argv) > 2:
        complete_task(sys.argv[2])
    elif command == 'help':
        show_help()
    else:
        print("❌ Invalid command. Use 'help' for usage information.")

if __name__ == "__main__":
    main()
