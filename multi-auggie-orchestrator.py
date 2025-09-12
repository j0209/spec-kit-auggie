#!/usr/bin/env python3
"""
Multi-AUGGIE Orchestrator for Parallel Spec-Driven Development

This orchestrator manages multiple AUGGIE CLI instances working in parallel
on different components of a project, all coordinated through shared specifications.
"""

import asyncio
import json
import os
import subprocess
import tempfile
import shutil
from pathlib import Path
from typing import Dict, List, Optional, Tuple
from dataclasses import dataclass
from enum import Enum

class TaskStatus(Enum):
    PENDING = "pending"
    ASSIGNED = "assigned"
    IN_PROGRESS = "in_progress"
    COMPLETED = "completed"
    FAILED = "failed"
    BLOCKED = "blocked"

@dataclass
class Task:
    id: str
    description: str
    component: str
    files: List[str]
    dependencies: List[str]
    parallel_safe: bool
    estimated_effort: int
    status: TaskStatus = TaskStatus.PENDING
    assigned_agent: Optional[str] = None
    output_path: Optional[str] = None

@dataclass
class AuggieAgent:
    id: str
    name: str
    specialization: str  # frontend, backend, database, testing, etc.
    working_dir: Path
    status: str = "idle"
    current_task: Optional[str] = None

class MultiAuggieOrchestrator:
    def __init__(self, project_root: Path, spec_dir: Path):
        self.project_root = project_root
        self.spec_dir = spec_dir
        self.agents: Dict[str, AuggieAgent] = {}
        self.tasks: Dict[str, Task] = {}
        self.shared_context = {}
        
    async def initialize_agents(self, agent_configs: List[Dict]) -> None:
        """Initialize multiple AUGGIE agents with different specializations."""
        for config in agent_configs:
            agent_id = config["id"]
            working_dir = self.project_root / f"work-{agent_id}"
            working_dir.mkdir(exist_ok=True)
            
            # Copy shared specifications to each agent's workspace
            await self._setup_agent_workspace(working_dir)
            
            agent = AuggieAgent(
                id=agent_id,
                name=config["name"],
                specialization=config["specialization"],
                working_dir=working_dir
            )
            self.agents[agent_id] = agent
            
    async def _setup_agent_workspace(self, working_dir: Path) -> None:
        """Setup workspace with shared specifications and context."""
        # Copy specifications
        if self.spec_dir.exists():
            shutil.copytree(self.spec_dir, working_dir / "specs", dirs_exist_ok=True)
        
        # Copy constitution and memory
        memory_dir = self.project_root / "memory"
        if memory_dir.exists():
            shutil.copytree(memory_dir, working_dir / "memory", dirs_exist_ok=True)
            
        # Copy templates
        templates_dir = self.project_root / "templates"
        if templates_dir.exists():
            shutil.copytree(templates_dir, working_dir / "templates", dirs_exist_ok=True)

    async def load_tasks_from_spec(self, tasks_file: Path) -> None:
        """Load and parse tasks from the generated tasks.md file."""
        if not tasks_file.exists():
            raise FileNotFoundError(f"Tasks file not found: {tasks_file}")
            
        # Parse tasks.md and extract structured task information
        # This would parse the markdown and create Task objects
        tasks_content = tasks_file.read_text()
        parsed_tasks = self._parse_tasks_markdown(tasks_content)
        
        for task_data in parsed_tasks:
            task = Task(**task_data)
            self.tasks[task.id] = task

    def _parse_tasks_markdown(self, content: str) -> List[Dict]:
        """Parse tasks.md markdown format into structured task data."""
        # Implementation would parse the specific format from spec-kit
        # This is a simplified version
        tasks = []
        lines = content.split('\n')
        
        current_task = None
        for line in lines:
            if line.startswith('### T'):  # Task header
                if current_task:
                    tasks.append(current_task)
                
                task_id = line.split()[1].rstrip(':')
                current_task = {
                    'id': task_id,
                    'description': '',
                    'component': 'general',
                    'files': [],
                    'dependencies': [],
                    'parallel_safe': '[P]' in line,
                    'estimated_effort': 1
                }
            elif current_task and line.strip():
                if line.startswith('**Description:**'):
                    current_task['description'] = line.replace('**Description:**', '').strip()
                elif line.startswith('**Files:**'):
                    files_str = line.replace('**Files:**', '').strip()
                    current_task['files'] = [f.strip() for f in files_str.split(',') if f.strip()]
                elif line.startswith('**Dependencies:**'):
                    deps_str = line.replace('**Dependencies:**', '').strip()
                    current_task['dependencies'] = [d.strip() for d in deps_str.split(',') if d.strip()]
                elif line.startswith('**Component:**'):
                    current_task['component'] = line.replace('**Component:**', '').strip()
        
        if current_task:
            tasks.append(current_task)
            
        return tasks

    async def assign_tasks(self) -> None:
        """Intelligently assign tasks to agents based on specialization and dependencies."""
        available_tasks = [t for t in self.tasks.values() if t.status == TaskStatus.PENDING]
        
        # Sort by dependencies and specialization match
        for task in available_tasks:
            best_agent = self._find_best_agent_for_task(task)
            if best_agent and self._can_assign_task(task):
                task.status = TaskStatus.ASSIGNED
                task.assigned_agent = best_agent.id
                best_agent.current_task = task.id
                print(f"Assigned task {task.id} to agent {best_agent.name}")

    def _find_best_agent_for_task(self, task: Task) -> Optional[AuggieAgent]:
        """Find the best agent for a task based on specialization and availability."""
        available_agents = [a for a in self.agents.values() if a.status == "idle"]
        
        if not available_agents:
            return None
            
        # Score agents based on specialization match
        scored_agents = []
        for agent in available_agents:
            score = 0
            if agent.specialization in task.component.lower():
                score += 10
            if agent.specialization in task.description.lower():
                score += 5
            scored_agents.append((score, agent))
        
        # Return highest scoring agent
        scored_agents.sort(key=lambda x: x[0], reverse=True)
        return scored_agents[0][1] if scored_agents else None

    def _can_assign_task(self, task: Task) -> bool:
        """Check if a task can be assigned (dependencies met, no conflicts)."""
        # Check dependencies
        for dep_id in task.dependencies:
            if dep_id in self.tasks:
                dep_task = self.tasks[dep_id]
                if dep_task.status != TaskStatus.COMPLETED:
                    return False
        
        # Check file conflicts
        if not task.parallel_safe:
            for other_task in self.tasks.values():
                if (other_task.status == TaskStatus.IN_PROGRESS and 
                    other_task.id != task.id and
                    set(task.files) & set(other_task.files)):
                    return False
        
        return True

    async def execute_task(self, agent: AuggieAgent, task: Task) -> bool:
        """Execute a task using the specified AUGGIE agent."""
        print(f"Agent {agent.name} starting task {task.id}: {task.description}")
        
        task.status = TaskStatus.IN_PROGRESS
        agent.status = "working"
        
        try:
            # Prepare the AUGGIE command with context
            command = self._build_auggie_command(agent, task)
            
            # Execute AUGGIE CLI
            result = await self._run_auggie_command(agent.working_dir, command)
            
            if result.returncode == 0:
                task.status = TaskStatus.COMPLETED
                task.output_path = str(agent.working_dir / "output")
                print(f"✅ Agent {agent.name} completed task {task.id}")
                
                # Merge results back to main project
                await self._merge_task_results(agent, task)
                return True
            else:
                task.status = TaskStatus.FAILED
                print(f"❌ Agent {agent.name} failed task {task.id}: {result.stderr}")
                return False
                
        except Exception as e:
            task.status = TaskStatus.FAILED
            print(f"❌ Agent {agent.name} error on task {task.id}: {e}")
            return False
        finally:
            agent.status = "idle"
            agent.current_task = None

    def _build_auggie_command(self, agent: AuggieAgent, task: Task) -> str:
        """Build the AUGGIE CLI command for the specific task."""
        context = f"""
        You are {agent.name}, specialized in {agent.specialization}.
        
        Task: {task.description}
        Component: {task.component}
        Files to work on: {', '.join(task.files)}
        
        Follow the specifications in specs/ directory.
        Apply the constitution from memory/constitution.md.
        
        Focus on your specialization: {agent.specialization}
        Coordinate with other agents through shared specifications.
        
        Implement this task: {task.description}
        """
        
        return f'auggie --print "{context}"'

    async def _run_auggie_command(self, working_dir: Path, command: str) -> subprocess.CompletedProcess:
        """Run AUGGIE CLI command in the agent's workspace."""
        process = await asyncio.create_subprocess_shell(
            command,
            cwd=working_dir,
            stdout=asyncio.subprocess.PIPE,
            stderr=asyncio.subprocess.PIPE
        )
        
        stdout, stderr = await process.communicate()
        
        return subprocess.CompletedProcess(
            args=command,
            returncode=process.returncode,
            stdout=stdout.decode(),
            stderr=stderr.decode()
        )

    async def _merge_task_results(self, agent: AuggieAgent, task: Task) -> None:
        """Merge completed task results back to the main project."""
        # Copy modified files back to main project
        for file_path in task.files:
            source = agent.working_dir / file_path
            target = self.project_root / file_path
            
            if source.exists():
                target.parent.mkdir(parents=True, exist_ok=True)
                shutil.copy2(source, target)
                print(f"📁 Merged {file_path} from agent {agent.name}")

    async def orchestrate(self) -> None:
        """Main orchestration loop."""
        print("🚀 Starting Multi-AUGGIE Orchestration")
        
        while True:
            # Assign new tasks
            await self.assign_tasks()
            
            # Execute tasks in parallel
            active_tasks = []
            for agent in self.agents.values():
                if agent.current_task:
                    task = self.tasks[agent.current_task]
                    if task.status == TaskStatus.ASSIGNED:
                        active_tasks.append(self.execute_task(agent, task))
            
            if active_tasks:
                # Wait for at least one task to complete
                done, pending = await asyncio.wait(active_tasks, return_when=asyncio.FIRST_COMPLETED)
                
                # Cancel remaining tasks for this iteration
                for task in pending:
                    task.cancel()
            
            # Check if all tasks are complete
            remaining_tasks = [t for t in self.tasks.values() 
                            if t.status not in [TaskStatus.COMPLETED, TaskStatus.FAILED]]
            
            if not remaining_tasks:
                print("🎉 All tasks completed!")
                break
                
            # Brief pause before next iteration
            await asyncio.sleep(1)

    def get_status_report(self) -> Dict:
        """Generate a status report of all agents and tasks."""
        return {
            "agents": {
                agent_id: {
                    "name": agent.name,
                    "specialization": agent.specialization,
                    "status": agent.status,
                    "current_task": agent.current_task
                }
                for agent_id, agent in self.agents.items()
            },
            "tasks": {
                task_id: {
                    "description": task.description,
                    "status": task.status.value,
                    "assigned_agent": task.assigned_agent,
                    "component": task.component
                }
                for task_id, task in self.tasks.items()
            }
        }

# Example usage
async def main():
    project_root = Path("/path/to/project")
    spec_dir = project_root / "specs" / "001-feature"
    
    orchestrator = MultiAuggieOrchestrator(project_root, spec_dir)
    
    # Define agent configurations
    agent_configs = [
        {"id": "frontend", "name": "Frontend Specialist", "specialization": "frontend"},
        {"id": "backend", "name": "Backend Specialist", "specialization": "backend"},
        {"id": "database", "name": "Database Specialist", "specialization": "database"},
        {"id": "testing", "name": "Testing Specialist", "specialization": "testing"}
    ]
    
    await orchestrator.initialize_agents(agent_configs)
    await orchestrator.load_tasks_from_spec(spec_dir / "tasks.md")
    await orchestrator.orchestrate()

if __name__ == "__main__":
    asyncio.run(main())
