---
name: auggie-plan
description: "Plan how to implement the specified feature using AUGGIE CLI. This is the second step in the Spec-Driven Development lifecycle."
---

Plan how to implement the specified feature using AUGGIE CLI.

This is the second step in the Spec-Driven Development lifecycle.

Given the implementation details provided as an argument, do this:

1. **Determine Project Context and Setup**:
   - If a project name is provided in the arguments, use project-specific structure
   - Run `scripts/setup-plan.sh --json --project=PROJECT_NAME` from the repo root
   - If no project name provided, use legacy structure: `scripts/setup-plan.sh --json`
   - Parse JSON for FEATURE_SPEC, IMPL_PLAN, SPECS_DIR, BRANCH, and optionally PROJECT_NAME, PROJECT_DIR
   - All future file paths must be absolute.

2. **Use your context engine to analyze** (with project awareness):
   - The feature specification requirements and user stories
   - If PROJECT_NAME is provided: Focus analysis on the specific project directory (PROJECT_DIR)
   - Existing codebase architecture and patterns within the project context
   - Available libraries and frameworks in the specific project
   - Integration points and dependencies within the project
   - Performance and scalability considerations for the project
   - **IMPORTANT**: Avoid conflating with other projects or the Spec-Kit framework itself

3. Read the constitution at `/memory/constitution.md` to understand constitutional requirements and apply them to your planning.

4. Execute the implementation plan template with AUGGIE enhancements:
   - Load `/templates/plan-template.md` (already copied to IMPL_PLAN path)
   - Set Input path to FEATURE_SPEC
   - Run the Execution Flow (main) function steps 1-10
   - The template is self-contained and executable
   - Follow error handling and gate checks as specified
   - Let the template guide artifact generation in $SPECS_DIR:
     * Phase 0 generates research.md (enhanced with codebase analysis)
     * Phase 1 generates data-model.md, contracts/, quickstart.md
     * Phase 2 generates tasks.md
   - Incorporate user-provided details from arguments into Technical Context: {ARGS}
   - Update Progress Tracking as you complete each phase

5. **AUGGIE-Enhanced Planning** (with project awareness):
   - If PROJECT_NAME is provided: Focus context analysis on the specific project directory
   - Use codebase context to identify existing patterns to follow within the project
   - Suggest reusable components and libraries already in the specific project
   - Identify potential conflicts with existing implementations in the project
   - Recommend testing strategies based on existing test patterns in the project
   - Consider performance implications based on the project's current architecture
   - Ensure planning aligns with the project's technology stack and conventions

6. Verify execution completed:
   - Check Progress Tracking shows all phases complete
   - Ensure all required artifacts were generated
   - Confirm no ERROR states in execution
   - Validate plans align with project-specific codebase patterns (if PROJECT_NAME provided)
   - Ensure no conflation with other projects or the Spec-Kit framework

7. Report results with branch name, file paths, generated artifacts, key architectural decisions, and project context (if applicable).

**AUGGIE Advantages:**
- Deep codebase understanding for realistic planning
- Automatic identification of reusable components
- Architecture-aware implementation strategies
- Context-driven technology choices

Use absolute paths with the repository root for all file operations to avoid path issues.
