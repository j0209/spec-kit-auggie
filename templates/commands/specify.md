---
name: specify
description: "Start a new feature by creating a specification and feature branch. This is the first step in the Spec-Driven Development lifecycle."
---

Start a new feature by creating a specification and feature branch.

This is the first step in the Spec-Driven Development lifecycle.

Given the feature description provided as an argument, do this:

1. **Determine Project Context**:
   - If a project name is provided in the arguments, use project-specific structure
   - Run the script `scripts/create-new-feature.sh --json --project=PROJECT_NAME "{FEATURE_DESCRIPTION}"` from repo root
   - If no project name provided, use legacy structure: `scripts/create-new-feature.sh --json "{ARGS}"`
   - Parse JSON output for BRANCH_NAME, SPEC_FILE, and optionally PROJECT_NAME, PROJECT_DIR

2. Load `templates/spec-template.md` to understand required sections.

3. Write the specification to SPEC_FILE using the template structure, replacing placeholders with concrete details derived from the feature description (arguments) while preserving section order and headings.

4. **Project-Aware Specification**:
   - If working within a project context, focus specifications on that specific project
   - Reference existing project architecture and patterns from PROJECT_DIR
   - Ensure specifications align with project's technology stack and conventions
   - Avoid conflating with other projects or the Spec-Kit framework itself

5. Report completion with branch name, spec file path, project context (if applicable), and readiness for the next phase.

Note: The script creates and checks out the new branch and initializes the spec file before writing.
