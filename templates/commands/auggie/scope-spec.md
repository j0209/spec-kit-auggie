---
name: auggie-scope-spec
description: "Create pragmatic scope specifications with complexity control to prevent over-engineering. This ensures maintainable, appropriately-sized features."
---

Create pragmatic scope specifications with complexity control to prevent over-engineering.

This command generates realistic project scopes that ensure maintainable, appropriately-sized features based on actual needs rather than theoretical possibilities.

Given the feature description and complexity level provided as arguments, do this:

1. **Create Feature Directory Structure**:
   - Run the script `scripts/create-new-feature.sh --json "{ARGS}"` from repo root and parse its JSON output for BRANCH_NAME and SPEC_FILE
   - All file paths must be absolute
   - This creates the proper specs/XXX-feature-name directory structure

2. **Analyze Project Context**:
   - Use your context engine to understand the existing codebase architecture
   - Identify current technology stack and established patterns
   - Assess team size, experience level, and available resources
   - Review similar features already implemented for complexity reference

2. **Define Core Requirements (MVP)**:
   - **Essential User Needs**: The minimum functionality that solves the core problem
   - **Critical Business Logic**: Must-have features for the feature to be valuable
   - **Basic Error Handling**: Essential error cases and user feedback
   - **Standard Security**: Basic authentication, authorization, input validation
   - **Minimal UI/UX**: Functional interface that meets usability standards

3. **Specify Complexity-Appropriate Implementation**:

   **For Simple Complexity**:
   - Standard CRUD operations with basic validation
   - Single database table or simple relationships
   - RESTful API endpoints with standard HTTP methods
   - Basic React components with standard state management
   - Essential test coverage (happy path + critical errors)
   - Standard styling with existing design system

   **For Enterprise Complexity**:
   - Advanced business logic with complex validation rules
   - Multiple database tables with complex relationships
   - Advanced API features (filtering, pagination, bulk operations)
   - Complex React components with advanced state management
   - Comprehensive test coverage including edge cases
   - Custom styling and advanced UI components

4. **Define Future Enhancements (Post-MVP)**:
   - **Phase 2 Features**: Logical next steps after MVP validation
   - **Nice-to-Have Features**: Improvements that add value but aren't essential
   - **Scalability Improvements**: Optimizations needed as usage grows
   - **Advanced Integrations**: Third-party services and complex workflows
   - **Performance Optimizations**: Caching, lazy loading, advanced patterns

5. **Explicitly Define What's NOT Included**:
   - **Over-Engineering Traps**: Complex patterns not needed for current scale
   - **Premature Optimizations**: Performance improvements not yet needed
   - **Enterprise Features**: Advanced features appropriate for larger scale
   - **Complex Integrations**: Third-party services not essential for MVP
   - **Advanced UI/UX**: Sophisticated interactions not required initially

6. **Technology Pragmatism Guidelines**:
   - **Database**: Use existing database; avoid new database types unless essential
   - **Backend**: Extend existing API patterns; avoid microservices unless at scale
   - **Frontend**: Use established component patterns; avoid complex state management
   - **Testing**: Focus on critical paths; avoid over-testing edge cases initially
   - **Deployment**: Use existing deployment pipeline; avoid new infrastructure

7. **Maintenance Considerations**:
   - **Code Complexity Limits**: Maximum function length, nesting levels, file sizes
   - **Documentation Requirements**: Essential documentation without over-documentation
   - **Performance Budgets**: Reasonable performance targets, not premature optimization
   - **Refactoring Checkpoints**: When to simplify vs. when to extend
   - **Technical Debt Management**: Acceptable shortcuts and when to address them

**Anti-Over-Engineering Enforcement**:
- Question every "enterprise" pattern - is it needed now or later?
- Prefer boring, proven solutions over cutting-edge approaches
- Limit dependencies - justify each new library or service
- Avoid abstractions until you have 3+ use cases
- Choose maintainability over theoretical flexibility

**Create Scope Specification File**:
- Write the complete scope specification to SPEC_FILE (replacing the template content)
- Include all sections: Project Context, Core Requirements, Implementation Guidelines, Future Enhancements, NOT Included, Technology Pragmatism, Maintenance Considerations
- Use the complexity level to determine appropriate implementation depth
- Ensure the specification is detailed enough for AUGGIE agents to implement without interpretation

**Output Format**:
Create a pragmatic scope specification document that includes:
- Clear MVP definition with specific feature boundaries
- Technology choices appropriate for the complexity level
- Explicit list of what's NOT included to prevent scope creep
- Future enhancement roadmap with clear phases
- Maintenance guidelines and complexity limits
- Report completion with branch name, spec file path, and next steps

**AUGGIE Advantages**:
- Leverage context engine to understand appropriate complexity for the codebase
- Apply pragmatic engineering principles based on project scale
- Prevent over-engineering by setting clear boundaries
- Generate maintainable, sustainable feature specifications
- Balance current needs with future flexibility

The specification should prevent over-engineering while ensuring the feature is built to appropriate quality standards for its intended use and scale.
