---
name: auggie-plan
description: "Plan how to implement the specified feature using AUGGIE CLI. This is the second step in the Spec-Driven Development lifecycle."
---

Plan how to implement the specified feature using AUGGIE CLI.

This is the second step in the Spec-Driven Development lifecycle.

Given the implementation details provided as an argument, do this:

1. Run `scripts/setup-plan.sh --json` from the repo root and parse JSON for FEATURE_SPEC, IMPL_PLAN, SPECS_DIR, BRANCH. All future file paths must be absolute.

2. Use your context engine to analyze:
   - The feature specification requirements and user stories
   - Existing codebase architecture and patterns
   - Available libraries and frameworks in the project
   - Integration points and dependencies
   - Performance and scalability considerations

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

5. **AUGGIE-Enhanced Planning:**
   - Use codebase context to identify existing patterns to follow
   - Suggest reusable components and libraries already in the project
   - Identify potential conflicts with existing implementations
   - Recommend testing strategies based on existing test patterns
   - Consider performance implications based on current architecture

6. Verify execution completed:
   - Check Progress Tracking shows all phases complete
   - Ensure all required artifacts were generated
   - Confirm no ERROR states in execution
   - Validate plans align with existing codebase patterns

7. Report results with branch name, file paths, generated artifacts, and key architectural decisions.

**AUGGIE Advantages:**
- Deep codebase understanding for realistic planning
- Automatic identification of reusable components
- Architecture-aware implementation strategies
- Context-driven technology choices

Use absolute paths with the repository root for all file operations to avoid path issues.
