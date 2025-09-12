#!/usr/bin/env python3
"""
Spec-Kit to Augment Task Management Bridge

This script converts Spec-Kit generated tasks.md files into Augment's 
task management system format, enabling seamless integration between
specification-driven development and Augment's task tracking.
"""

import re
import json
import uuid
from pathlib import Path
from typing import Dict, List, Optional, Tuple
from dataclasses import dataclass, asdict

@dataclass
class AugmentTask:
    """Represents a task in Augment's task management system."""
    task_id: str
    name: str
    description: str
    state: str = "NOT_STARTED"  # NOT_STARTED, IN_PROGRESS, CANCELLED, COMPLETE
    parent_task_id: Optional[str] = None
    dependencies: List[str] = None
    
    def __post_init__(self):
        if self.dependencies is None:
            self.dependencies = []

class SpecKitTaskParser:
    """Parses Spec-Kit tasks.md files and converts them to Augment task format."""
    
    def __init__(self):
        self.tasks: Dict[str, AugmentTask] = {}
        self.task_hierarchy: Dict[str, List[str]] = {}
        self.dependencies: Dict[str, List[str]] = {}
        
    def parse_tasks_file(self, tasks_file: Path) -> Dict[str, AugmentTask]:
        """Parse a Spec-Kit tasks.md file and return Augment tasks."""
        if not tasks_file.exists():
            raise FileNotFoundError(f"Tasks file not found: {tasks_file}")
            
        content = tasks_file.read_text()
        
        # Extract feature name from the file
        feature_name = self._extract_feature_name(content)
        
        # Parse phases and tasks
        self._parse_phases_and_tasks(content, feature_name)
        
        # Parse dependencies
        self._parse_dependencies(content)
        
        # Apply dependencies to tasks
        self._apply_dependencies()
        
        return self.tasks
    
    def _extract_feature_name(self, content: str) -> str:
        """Extract feature name from the tasks.md header."""
        match = re.search(r'^# Tasks: (.+)$', content, re.MULTILINE)
        if match:
            return match.group(1).strip()
        return "Unknown Feature"
    
    def _parse_phases_and_tasks(self, content: str, feature_name: str) -> None:
        """Parse phases and individual tasks from the content."""
        lines = content.split('\n')
        current_phase = None
        current_phase_id = None
        
        for line in lines:
            line = line.strip()
            
            # Phase headers (## Phase X.Y: Name)
            phase_match = re.match(r'^## Phase (\d+\.\d+): (.+)$', line)
            if phase_match:
                phase_num = phase_match.group(1)
                phase_name = phase_match.group(2)
                current_phase = f"Phase {phase_num}: {phase_name}"
                current_phase_id = str(uuid.uuid4())
                
                # Create phase task
                self.tasks[current_phase_id] = AugmentTask(
                    task_id=current_phase_id,
                    name=current_phase,
                    description=f"Complete all tasks in {current_phase}",
                    state="NOT_STARTED"
                )
                continue
            
            # Individual tasks (- [ ] T001 Description)
            task_match = re.match(r'^- \[ \] (T\d+)(?:\s+\[P\])?\s+(.+)$', line)
            if task_match and current_phase_id:
                task_id = task_match.group(1)
                task_description = task_match.group(2)
                parallel_safe = '[P]' in line
                
                # Generate UUID for Augment
                augment_task_id = str(uuid.uuid4())
                
                # Extract file paths from description
                files = self._extract_file_paths(task_description)
                
                # Create detailed description
                detailed_description = self._create_detailed_description(
                    task_id, task_description, files, parallel_safe
                )
                
                # Create task
                self.tasks[augment_task_id] = AugmentTask(
                    task_id=augment_task_id,
                    name=f"{task_id}: {task_description[:50]}...",
                    description=detailed_description,
                    state="NOT_STARTED",
                    parent_task_id=current_phase_id
                )
                
                # Store mapping for dependency resolution
                self.task_hierarchy[task_id] = augment_task_id
    
    def _extract_file_paths(self, description: str) -> List[str]:
        """Extract file paths from task description."""
        # Look for common file path patterns
        file_patterns = [
            r'(?:in|at)\s+([a-zA-Z0-9_/.-]+\.[a-zA-Z0-9]+)',  # in src/models/user.py
            r'([a-zA-Z0-9_/.-]+/[a-zA-Z0-9_.-]+)',  # src/models/user
            r'`([^`]+\.[a-zA-Z0-9]+)`',  # `file.py`
        ]
        
        files = []
        for pattern in file_patterns:
            matches = re.findall(pattern, description)
            files.extend(matches)
        
        return list(set(files))  # Remove duplicates
    
    def _create_detailed_description(self, task_id: str, description: str, 
                                   files: List[str], parallel_safe: bool) -> str:
        """Create a detailed description for the Augment task."""
        details = [
            f"**Spec-Kit Task ID:** {task_id}",
            f"**Description:** {description}",
        ]
        
        if files:
            details.append(f"**Files to modify:** {', '.join(files)}")
        
        if parallel_safe:
            details.append("**Parallel Safe:** ✅ Can run in parallel with other [P] tasks")
        else:
            details.append("**Parallel Safe:** ❌ Must run sequentially")
        
        details.append("")
        details.append("**Implementation Notes:**")
        details.append("- Follow the specifications in specs/ directory")
        details.append("- Apply constitution from memory/constitution.md")
        details.append("- Ensure tests pass before marking complete")
        details.append("- Commit changes after completion")
        
        return "\n".join(details)
    
    def _parse_dependencies(self, content: str) -> None:
        """Parse the Dependencies section to understand task relationships."""
        # Find the Dependencies section
        deps_match = re.search(r'^## Dependencies\s*\n(.*?)(?=^##|\Z)', 
                              content, re.MULTILINE | re.DOTALL)
        
        if not deps_match:
            return
        
        deps_content = deps_match.group(1)
        
        # Parse dependency lines
        for line in deps_content.split('\n'):
            line = line.strip()
            if not line or line.startswith('#'):
                continue
            
            # Pattern: "T008 blocks T009, T015"
            blocks_match = re.match(r'^(T\d+) blocks (.+)$', line)
            if blocks_match:
                blocker = blocks_match.group(1)
                blocked_tasks = [t.strip() for t in blocks_match.group(2).split(',')]
                
                for blocked_task in blocked_tasks:
                    if blocked_task not in self.dependencies:
                        self.dependencies[blocked_task] = []
                    self.dependencies[blocked_task].append(blocker)
                continue
            
            # Pattern: "Tests (T004-T007) before implementation (T008-T014)"
            before_match = re.match(r'^(.+) before (.+)$', line)
            if before_match:
                prereq_desc = before_match.group(1)
                dependent_desc = before_match.group(2)
                
                # Extract task ranges
                prereq_tasks = self._extract_task_range(prereq_desc)
                dependent_tasks = self._extract_task_range(dependent_desc)
                
                # Add dependencies
                for dep_task in dependent_tasks:
                    if dep_task not in self.dependencies:
                        self.dependencies[dep_task] = []
                    self.dependencies[dep_task].extend(prereq_tasks)
    
    def _extract_task_range(self, text: str) -> List[str]:
        """Extract task IDs from text like 'Tests (T004-T007)' or 'T008, T009'."""
        tasks = []
        
        # Range pattern: T004-T007
        range_matches = re.findall(r'T(\d+)-T(\d+)', text)
        for start_num, end_num in range_matches:
            start = int(start_num)
            end = int(end_num)
            for i in range(start, end + 1):
                tasks.append(f"T{i:03d}")
        
        # Individual task pattern: T008
        individual_matches = re.findall(r'T(\d+)', text)
        for task_num in individual_matches:
            task_id = f"T{int(task_num):03d}"
            if task_id not in tasks:  # Avoid duplicates from ranges
                tasks.append(task_id)
        
        return tasks
    
    def _apply_dependencies(self) -> None:
        """Apply parsed dependencies to the Augment tasks."""
        for spec_task_id, prereq_list in self.dependencies.items():
            if spec_task_id in self.task_hierarchy:
                augment_task_id = self.task_hierarchy[spec_task_id]
                task = self.tasks[augment_task_id]
                
                # Convert spec task IDs to Augment task IDs
                augment_prereqs = []
                for prereq_spec_id in prereq_list:
                    if prereq_spec_id in self.task_hierarchy:
                        augment_prereqs.append(self.task_hierarchy[prereq_spec_id])
                
                task.dependencies = augment_prereqs

def convert_spec_kit_to_augment(tasks_file: Path, output_file: Optional[Path] = None) -> str:
    """Convert a Spec-Kit tasks.md file to Augment task format."""
    parser = SpecKitTaskParser()
    tasks = parser.parse_tasks_file(tasks_file)
    
    # Convert to the format expected by Augment's task management
    task_list = []
    root_tasks = []
    
    for task in tasks.values():
        task_dict = {
            "task_id": task.task_id,
            "name": task.name,
            "description": task.description,
            "state": task.state,
            "dependencies": task.dependencies
        }
        
        if task.parent_task_id:
            task_dict["parent_task_id"] = task.parent_task_id
        else:
            root_tasks.append(task.task_id)
        
        task_list.append(task_dict)
    
    # Create the final structure
    augment_format = {
        "tasks": task_list,
        "root_tasks": root_tasks,
        "metadata": {
            "source": "spec-kit",
            "source_file": str(tasks_file),
            "generated_at": "2025-09-11T16:30:00Z",
            "total_tasks": len(task_list)
        }
    }
    
    # Save to file if specified
    if output_file:
        output_file.write_text(json.dumps(augment_format, indent=2))
        print(f"✅ Converted {len(task_list)} tasks to Augment format: {output_file}")
    
    return json.dumps(augment_format, indent=2)

def generate_augment_task_commands(tasks_file: Path) -> str:
    """Generate the actual Augment task management commands to create the tasks."""
    parser = SpecKitTaskParser()
    tasks = parser.parse_tasks_file(tasks_file)
    
    commands = []
    commands.append("# Augment Task Management Commands")
    commands.append("# Run these commands to import Spec-Kit tasks into Augment")
    commands.append("")
    
    # First, create root tasks (phases)
    root_tasks = [t for t in tasks.values() if t.parent_task_id is None]
    for task in root_tasks:
        cmd = f'add_tasks([{{"name": "{task.name}", "description": "{task.description}"}}])'
        commands.append(cmd)
    
    commands.append("")
    commands.append("# Then create subtasks")
    
    # Then create subtasks
    subtasks = [t for t in tasks.values() if t.parent_task_id is not None]
    for task in subtasks:
        # Find parent task name for reference
        parent_task = tasks.get(task.parent_task_id)
        parent_name = parent_task.name if parent_task else "Unknown Parent"
        
        cmd = f'add_tasks([{{"name": "{task.name}", "description": "{task.description}", "parent_task_id": "PARENT_ID_FOR_{parent_name}"}}])'
        commands.append(f"# Parent: {parent_name}")
        commands.append(cmd)
        commands.append("")
    
    return "\n".join(commands)

# CLI interface
if __name__ == "__main__":
    import sys
    
    if len(sys.argv) < 2:
        print("Usage: python spec-kit-augment-bridge.py <tasks.md> [output.json]")
        print("       python spec-kit-augment-bridge.py <tasks.md> --commands")
        sys.exit(1)
    
    tasks_file = Path(sys.argv[1])
    
    if len(sys.argv) > 2 and sys.argv[2] == "--commands":
        # Generate Augment commands
        commands = generate_augment_task_commands(tasks_file)
        print(commands)
    else:
        # Convert to JSON format
        output_file = Path(sys.argv[2]) if len(sys.argv) > 2 else None
        result = convert_spec_kit_to_augment(tasks_file, output_file)
        
        if not output_file:
            print(result)
