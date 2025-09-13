---
name: auggie-design-spec
description: "Create comprehensive visual design specifications for beautiful, consistent user interfaces. This ensures professional design quality and developer implementation clarity."
---

Create comprehensive visual design specifications for beautiful, consistent user interfaces.

This command generates complete design systems that ensure professional quality and clear implementation guidance for developers.

Given the design description provided as an argument, do this:

1. **Determine Project Context and Create Design Specification File**:
   - If a project name is provided in the arguments, create design-spec.md in the project-specific feature directory (projects/PROJECT_NAME/specs/XXX-feature-name/)
   - If no project name provided, use legacy structure: specs/XXX-feature-name/design-spec.md
   - If no feature directory exists, create one using the design description as the feature name

2. **Analyze Existing Design Context** (with project awareness):
   - If PROJECT_NAME is provided: Focus analysis on the specific project directory (PROJECT_DIR)
   - Use your context engine to examine existing CSS, design tokens, and UI components within the project
   - Identify current color schemes, typography, and spacing patterns specific to the project
   - Understand the project's visual identity and brand requirements
   - Review any existing design system or style guide within the project
   - **IMPORTANT**: Avoid conflating with other projects or the Spec-Kit framework's design patterns

2. **Generate Design System Specification**:
   - **Color Palette**: Primary, secondary, accent colors with hex codes and usage guidelines
   - **Typography Scale**: Font families, sizes, weights, line heights for headings and body text
   - **Spacing System**: Consistent spacing scale (4px, 8px, 16px, 24px, 32px, etc.)
   - **Component Tokens**: Button styles, form elements, cards, navigation elements
   - **Elevation/Shadows**: Box shadow specifications for depth and hierarchy

3. **Create Layout Specifications**:
   - **Grid System**: Column layouts, breakpoints, container widths
   - **Component Hierarchy**: Visual weight, sizing, and positioning guidelines
   - **Responsive Behavior**: How elements adapt across mobile, tablet, desktop
   - **Content Areas**: Header, sidebar, main content, footer specifications

4. **Define Interaction States**:
   - **Default States**: Normal appearance of all interactive elements
   - **Hover States**: Visual feedback for mouse interactions
   - **Focus States**: Keyboard navigation and accessibility indicators
   - **Active/Pressed States**: Click and touch feedback
   - **Disabled States**: Non-interactive element appearance

5. **Accessibility Design Requirements**:
   - **Color Contrast**: WCAG 2.1 AA compliance (4.5:1 for normal text, 3:1 for large text)
   - **Focus Indicators**: Clear, visible focus rings for keyboard navigation
   - **Touch Targets**: Minimum 44px touch targets for mobile
   - **Text Readability**: Appropriate font sizes and line spacing

6. **Create Implementation Guidelines**:
   - **CSS Custom Properties**: Define design tokens as CSS variables
   - **Component Classes**: BEM or utility-first class naming conventions
   - **Asset Requirements**: Icon specifications, image guidelines, logo usage
   - **Animation Guidelines**: Transition timing, easing functions, duration

**Anti-Over-Engineering Guidelines**:
- Keep the design system simple and focused on essential elements
- Use standard design patterns rather than custom solutions
- Prioritize consistency over creativity for maintainability
- Choose proven color palettes and typography combinations
- Avoid complex animations or interactions unless specifically needed

**Save Design Specification**:
- Write the complete design specification to design-spec.md in the feature directory
- Include all sections: Design System, Layout Specifications, Interaction States, Accessibility Requirements, Implementation Guidelines
- Provide visual examples and code snippets for each design element
- Include responsive design guidelines with specific breakpoints
- Add accessibility compliance checklist and asset requirements

**Output Format**:
Create a comprehensive design specification document that includes:
- Visual examples and code snippets for each design element
- Clear implementation instructions for developers
- Responsive design guidelines with specific breakpoints
- Accessibility compliance checklist
- Asset and resource requirements
- Report completion with file path and implementation readiness

**AUGGIE Advantages**:
- Leverage context engine to understand existing design patterns
- Ensure consistency with current codebase and visual elements
- Apply modern design best practices automatically
- Generate pragmatic, maintainable design specifications
- Create developer-friendly implementation guidelines

The specification should be detailed enough that any developer can implement the design consistently without additional design input.
