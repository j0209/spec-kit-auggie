# Spec-Kit AUGGIE Integration Guidelines

**Project Type**: Pure Planning Tool (Python CLI)
**Purpose**: Generate comprehensive specifications for multiple projects
**Architecture**: Multi-project planning hub with AUGGIE integration

## Core Principles

### 1. Pure Planning Focus
- **NEVER implement project code** - this is a specification generation tool only
- **NEVER conflate** Spec-Kit with the projects being planned
- **ALWAYS maintain** clear separation between planning tool and target projects
- **EXPORT specifications** for development elsewhere, never develop here

### 2. Multi-Project Architecture
- Each planned project lives in `projects/project-name/` directory
- Each project has its own `specs/` directory with complete specifications
- Each project has `.project-meta.json` with metadata
- **NEVER mix** different projects or conflate with Spec-Kit itself

### 3. Specification Quality Standards
- **Mark ambiguities** with `[NEEDS CLARIFICATION: specific question]`
- **Never guess** - if unclear, mark for clarification
- **Professional quality** - specifications must be production-ready
- **Complete coverage** - scope, design, UX, technical, tasks

## Technology Context

### Spec-Kit Framework (This Project)
- **Language**: Python 3.11+ with Typer CLI framework
- **Structure**: `src/specify_cli/` for core CLI, `templates/` for AUGGIE integration
- **Purpose**: Planning tool that generates specifications for other projects
- **Dependencies**: Python standard library, Typer, Rich for CLI interface

### Target Projects (Being Planned)
- **Any technology stack** - React, Vue, Node.js, Python, Rust, Go, etc.
- **Any architecture** - web apps, mobile apps, APIs, desktop applications
- **Any complexity** - simple CRUD to enterprise systems
- **Language agnostic** - Spec-Kit can plan any technology

## AUGGIE Integration Patterns

### 1. Command Structure
```bash
# Always require project context
auggie-specify "project-name" "feature description"
auggie-plan "project-name" "technical details"
auggie-tasks "project-name" "additional context"
```

### 2. Context Awareness
- **Load project metadata** from `.project-meta.json`
- **Analyze existing specs** in project directory
- **Understand technology stack** from previous planning
- **Maintain project isolation** - never cross-reference other projects

### 3. Approval Gates
- **Auto-check** for `[NEEDS CLARIFICATION]` after each specification
- **Milestone reviews** at definition, technical, and final phases
- **User approval required** before continuing to next phase
- **Export only** after all clarifications resolved

## Specification Templates

### 1. Scope Specification
- Core requirements (MVP features)
- Future enhancements (post-MVP)
- Explicitly NOT included (boundaries)
- Complexity level (simple vs enterprise)
- Technology pragmatism

### 2. Design Specification
- Visual design system (colors, typography, spacing)
- Component specifications (buttons, forms, navigation)
- Responsive breakpoints (mobile-first approach)
- Accessibility requirements (WCAG 2.1 AA)
- Brand guidelines

### 3. UX Specification
- User journey maps (step-by-step flows)
- Interaction specifications (hover, focus, loading states)
- Error state handling (user-friendly messages)
- Micro-interactions (animations, transitions)
- Content guidelines

### 4. Technical Specification
- Architecture decisions and rationale
- Technology stack with justification
- Data models and relationships
- API contracts and endpoints
- Performance and scalability considerations

### 5. Implementation Plan
- Development phases and milestones
- Dependency management strategy
- Testing approach and coverage
- Deployment and infrastructure
- Risk mitigation strategies

### 6. Development Tasks
- Detailed task breakdown (T001, T002, etc.)
- Parallel execution opportunities ([P] markers)
- Dependency relationships
- Effort estimates
- File paths and specific implementation details

## Quality Assurance

### 1. Specification Completeness
- All mandatory sections completed
- No `[NEEDS CLARIFICATION]` markers remain
- Requirements are testable and unambiguous
- Success criteria are measurable
- Dependencies and assumptions identified

### 2. Technical Accuracy
- Architecture aligns with project constraints
- Technology choices are appropriate for complexity
- Performance targets are realistic
- Security considerations addressed
- Maintenance implications considered

### 3. User Experience Focus
- User value clearly articulated
- Business needs addressed
- Non-technical stakeholder friendly
- Implementation details abstracted appropriately
- Focus on outcomes, not technology

## Common Patterns

### 1. Project Initialization
```bash
auggie-new-project "project-name" "description" --tech-stack=react
```

### 2. Complete Workflow
```bash
auggie-scope-spec "project-name" "feature" --complexity=simple
auggie-review-milestone "project-name" "definition"
auggie-design-spec "project-name" "modern interface"
auggie-ux-spec "project-name" "intuitive flows"
auggie-specify "project-name" "core functionality"
auggie-plan "project-name" "technical approach"
auggie-review-milestone "project-name" "technical"
auggie-tasks "project-name"
auggie-review-milestone "project-name" "final"
auggie-export-specs "project-name" "/path/to/handoff/"
```

### 3. Native Task Integration
```bash
auggie-full-workflow "project-name" "description"
# Creates AUGGIE native task list for planning workflow
# Use interactive mode: auggie -> /task
```

## Error Prevention

### 1. Context Confusion
- **Always specify project name** in commands
- **Never reference** other projects or Spec-Kit itself
- **Focus analysis** on the specific project directory
- **Validate project exists** before proceeding

### 2. Implementation Scope Creep
- **Specifications only** - never write actual project code
- **Export for handoff** - never implement in Spec-Kit
- **Planning focus** - architecture and approach, not implementation
- **Clear boundaries** - what's included vs excluded

### 3. Quality Issues
- **Mark uncertainties** with `[NEEDS CLARIFICATION]`
- **Require approval** at major milestones
- **Validate completeness** before export
- **Professional standards** - production-ready specifications

## Success Metrics

- **Zero conflation** between Spec-Kit and target projects
- **Complete specifications** with no unresolved clarifications
- **Professional quality** ready for development handoff
- **Clear project context** maintained throughout workflow
- **Efficient planning** using AUGGIE's native capabilities

---

*This file is automatically loaded by AUGGIE to provide context-aware assistance for the Spec-Kit project.*
