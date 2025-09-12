---
name: auggie-tasks
description: "Break down the plan into executable tasks using AUGGIE CLI. This is the third step in the Spec-Driven Development lifecycle."
---

Break down the plan into executable tasks using AUGGIE CLI.

This is the third step in the Spec-Driven Development lifecycle.

Given the context provided as an argument, do this:

1. Run `scripts/check-task-prerequisites.sh --json` from repo root and parse FEATURE_DIR and AVAILABLE_DOCS list. All paths must be absolute.

2. Use your context engine to analyze:
   - Available design documents and their implications
   - Existing codebase patterns for similar implementations
   - Current testing strategies and frameworks
   - Development workflow and tooling
   - Team capabilities and constraints

3. Load and analyze available design documents:
   - Always read plan.md for tech stack and libraries
   - IF EXISTS: Read data-model.md for entities
   - IF EXISTS: Read contracts/ for API endpoints
   - IF EXISTS: Read research.md for technical decisions
   - IF EXISTS: Read quickstart.md for test scenarios

   Note: Not all projects have all documents. For example:
   - CLI tools might not have contracts/
   - Simple libraries might not need data-model.md
   - Generate tasks based on what's available

4. **AUGGIE-Enhanced Task Generation:**
   - Use codebase context to create realistic time estimates
   - Identify existing code that can be reused or extended
   - Suggest specific files and functions to modify
   - Recommend testing approaches based on existing patterns
   - Consider integration points with current systems

5. Generate tasks following the template:
   - Use `/templates/tasks-template.md` as the base
   - Replace example tasks with actual tasks based on:
     * **Setup tasks**: Project init, dependencies, linting (context-aware)
     * **Test tasks [P]**: One per contract, one per integration scenario
     * **Core tasks**: One per entity, service, CLI command, endpoint
     * **Integration tasks**: DB connections, middleware, logging
     * **Polish tasks [P]**: Unit tests, performance, docs

6. **Context-Aware Task Rules:**
   - Each contract file → contract test task marked [P]
   - Each entity in data-model → model creation task marked [P]
   - Each endpoint → implementation task (not parallel if shared files)
   - Each user story → integration test marked [P]
   - Different files = can be parallel [P]
   - Same file = sequential (no [P])
   - Consider existing file structure and patterns

7. Order tasks by dependencies and codebase constraints:
   - Setup before everything
   - Tests before implementation (TDD)
   - Models before services
   - Services before endpoints
   - Core before integration
   - Everything before polish
   - Consider existing dependency chains

8. Include parallel execution examples:
   - Group [P] tasks that can run together
   - Show actual commands for task execution
   - Consider team size and capabilities

9. Create FEATURE_DIR/tasks.md with:
   - Correct feature name from implementation plan
   - Numbered tasks (T001, T002, etc.)
   - Clear file paths for each task (based on existing structure)
   - Dependency notes with specific reasoning
   - Parallel execution guidance
   - Estimated effort based on codebase complexity

Context for task generation: {ARGS}

**AUGGIE Advantages:**
- Context-aware task sizing and complexity estimation
- Identification of reusable code and patterns
- Realistic dependency analysis based on actual codebase
- Integration-aware task ordering

The tasks.md should be immediately executable - each task must be specific enough that an LLM can complete it without additional context, leveraging your understanding of the existing codebase.

## Integration with Augment Task Management

After generating tasks.md, automatically integrate with Augment's official task management system:

1. **Convert to Augment Format**: Use the spec-kit-augment-bridge.py to convert tasks.md to Augment's task format
2. **Import into Task System**: Create structured tasks using Augment's task management tools
3. **Enable Progress Tracking**: Allow real-time progress tracking during development
4. **Maintain Synchronization**: Keep Spec-Kit tasks and Augment tasks in sync

**Integration Commands:**
```bash
# Convert Spec-Kit tasks to Augment format
python3 spec-kit-augment-bridge.py FEATURE_DIR/tasks.md --commands

# The bridge will generate add_tasks() commands that can be executed
# to import all tasks into Augment's task management system
```

**Benefits of Integration:**
- **Unified Task Management**: Single source of truth for all tasks
- **Progress Tracking**: Real-time status updates during development
- **Dependency Management**: Automatic handling of task dependencies
- **Hierarchical Organization**: Phases and subtasks properly structured
- **State Synchronization**: Tasks marked complete in both systems
