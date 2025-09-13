---
name: auggie-specify
description: "Start a new feature by creating a specification and feature branch using AUGGIE CLI. This is the first step in the Spec-Driven Development lifecycle."
---

Start a new feature by creating a specification and feature branch using AUGGIE CLI.

This is the first step in the Spec-Driven Development lifecycle.

Given the feature description provided as an argument, do this:

1. **Determine Project Context and Create Feature**:
   - If a project name is provided in the arguments, use project-specific structure
   - Run the script `scripts/create-new-feature.sh --json --project=PROJECT_NAME "{FEATURE_DESCRIPTION}"` from repo root
   - If no project name provided, use legacy structure: `scripts/create-new-feature.sh --json "{ARGS}"`
   - Parse JSON output for BRANCH_NAME, SPEC_FILE, and optionally PROJECT_NAME, PROJECT_DIR
   - All file paths must be absolute.

2. Load `templates/spec-template.md` to understand required sections.

3. **Use your context engine to analyze** (with project awareness):
   - If PROJECT_NAME is provided: Focus analysis on the specific project directory (PROJECT_DIR)
   - The existing codebase patterns and architecture within the project context
   - Similar features that have been implemented in this specific project
   - The project's constitution and constraints from memory/constitution.md
   - Dependencies and integration points specific to this project
   - **IMPORTANT**: Avoid conflating with other projects or the Spec-Kit framework itself

4. **Write the specification to SPEC_FILE** using the template structure, replacing placeholders with concrete details derived from:
   - The feature description (arguments)
   - Your understanding of the project-specific codebase (if PROJECT_NAME provided)
   - Organizational constraints from constitution
   - Best practices from similar implementations within the same project
   - Project-specific technology stack and architectural patterns

5. **Ensure the specification includes** (with project awareness):
   - Clear user stories with acceptance criteria relevant to the project
   - Functional and non-functional requirements aligned with project goals
   - Integration points with existing systems within the project
   - Success metrics and validation criteria appropriate for the project
   - Technical constraints and dependencies specific to the project
   - **Project Context**: If PROJECT_NAME is provided, clearly indicate this is for that specific project

6. Report completion with branch name, spec file path, project context (if applicable), and readiness for the next phase.

**AUGGIE Advantages:**
- Leverage your context engine for better understanding of existing patterns
- Use codebase knowledge to create more realistic specifications
- Apply organizational constraints automatically
- Generate specifications that align with existing architecture

Note: The script creates and checks out the new branch and initializes the spec file before writing.
