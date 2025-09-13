---
name: plan
description: "Plan how to implement the specified feature. This is the second step in the Spec-Driven Development lifecycle."
---

Plan how to implement the specified feature.

This is the second step in the Spec-Driven Development lifecycle.

Given the implementation details provided as an argument, do this:

1. **Determine Project Context and Setup**:
   - If a project name is provided in the arguments, use project-specific structure
   - Run `scripts/setup-plan.sh --json --project=PROJECT_NAME` from the repo root
   - If no project name provided, use legacy structure: `scripts/setup-plan.sh --json`
   - Parse JSON for FEATURE_SPEC, IMPL_PLAN, SPECS_DIR, BRANCH, and optionally PROJECT_NAME, PROJECT_DIR
   - All future file paths must be absolute.
2. Read and analyze the feature specification to understand:
   - The feature requirements and user stories
   - Functional and non-functional requirements
   - Success criteria and acceptance criteria
   - Any technical constraints or dependencies mentioned

3. Read the constitution at `/memory/constitution.md` to understand constitutional requirements.

4. Execute the implementation plan template:
   - Load `/templates/plan-template.md` (already copied to IMPL_PLAN path)
   - Set Input path to FEATURE_SPEC
   - Run the Execution Flow (main) function steps 1-10
   - The template is self-contained and executable
   - Follow error handling and gate checks as specified
   - Let the template guide artifact generation in $SPECS_DIR:
     * Phase 0 generates research.md
     * Phase 1 generates data-model.md, contracts/, quickstart.md
     * Phase 2 generates tasks.md
   - Incorporate user-provided details from arguments into Technical Context: {ARGS}
   - Update Progress Tracking as you complete each phase

5. **Project-Aware Planning** (if PROJECT_NAME is provided):
   - Focus planning on the specific project context, not the Spec-Kit framework
   - Analyze existing project architecture and patterns in PROJECT_DIR
   - Ensure implementation aligns with project's technology stack and conventions
   - Reference project-specific dependencies and constraints
   - Avoid conflating with other projects or sample implementations

6. Verify execution completed:
   - Check Progress Tracking shows all phases complete
   - Ensure all required artifacts were generated
   - Confirm no ERROR states in execution
   - Validate plans align with project context (if applicable)

7. Report results with branch name, file paths, generated artifacts, and project context (if applicable).

Use absolute paths with the repository root for all file operations to avoid path issues.
