---
name: auggie-specify
description: "Start a new feature by creating a specification and feature branch using AUGGIE CLI. This is the first step in the Spec-Driven Development lifecycle."
---

Start a new feature by creating a specification and feature branch using AUGGIE CLI.

This is the first step in the Spec-Driven Development lifecycle.

Given the feature description provided as an argument, do this:

1. Run the script `scripts/create-new-feature.sh --json "{ARGS}"` from repo root and parse its JSON output for BRANCH_NAME and SPEC_FILE. All file paths must be absolute.

2. Load `templates/spec-template.md` to understand required sections.

3. Use your context engine to analyze:
   - The existing codebase patterns and architecture
   - Similar features that have been implemented
   - The project's constitution and constraints
   - Dependencies and integration points

4. Write the specification to SPEC_FILE using the template structure, replacing placeholders with concrete details derived from:
   - The feature description (arguments)
   - Your understanding of the codebase
   - Organizational constraints from constitution
   - Best practices from similar implementations

5. Ensure the specification includes:
   - Clear user stories with acceptance criteria
   - Functional and non-functional requirements
   - Integration points with existing systems
   - Success metrics and validation criteria
   - Technical constraints and dependencies

6. Report completion with branch name, spec file path, and readiness for the next phase.

**AUGGIE Advantages:**
- Leverage your context engine for better understanding of existing patterns
- Use codebase knowledge to create more realistic specifications
- Apply organizational constraints automatically
- Generate specifications that align with existing architecture

Note: The script creates and checks out the new branch and initializes the spec file before writing.
