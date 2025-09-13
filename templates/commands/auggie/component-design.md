---
name: auggie-component-design
description: "Create detailed component design specifications for reusable, consistent UI components. This ensures design system compliance and clear implementation guidance."
---

Create detailed component design specifications for reusable, consistent UI components.

This command generates complete component specifications that ensure design system compliance and provide clear implementation guidance for developers.

Given the component description provided as an argument, do this:

1. **Create Component Design File** (with project awareness):
   - If a project name is provided in the arguments, create component-design.md in the project-specific feature directory (projects/PROJECT_NAME/specs/XXX-feature-name/)
   - If no project name provided, use legacy structure: specs/XXX-feature-name/component-design.md
   - If no feature directory exists, create one using the component description as the feature name

2. **Analyze Existing Component Context** (with project awareness):
   - If PROJECT_NAME is provided: Focus analysis on the specific project directory (PROJECT_DIR)
   - Use your context engine to examine existing components and design patterns within the project
   - Identify current component library structure and naming conventions specific to the project
   - Understand the project's design system tokens and styling approach
   - Review similar components within the project for consistency and reusability opportunities
   - **IMPORTANT**: Avoid conflating with other projects or the Spec-Kit framework's component patterns

2. **Define Component Structure**:
   - **Component Name**: Clear, descriptive name following project conventions
   - **Purpose**: What problem this component solves and when to use it
   - **Variants**: Different versions (size, style, behavior variations)
   - **Props/Parameters**: All configurable options with types and defaults
   - **Composition**: How this component works with other components

3. **Specify Visual Design**:
   - **Default Appearance**: Base styling using design system tokens
   - **Size Variants**: Small, medium, large versions with specific dimensions
   - **Style Variants**: Primary, secondary, outline, ghost, danger variations
   - **Color Applications**: How design system colors are applied
   - **Typography**: Font sizes, weights, and spacing within the component

4. **Define Interactive States**:
   - **Default State**: Normal appearance and behavior
   - **Hover State**: Visual feedback on mouse over
   - **Focus State**: Keyboard navigation and accessibility indicators
   - **Active/Pressed State**: Visual feedback during interaction
   - **Disabled State**: Non-interactive appearance and behavior
   - **Loading State**: Progress indicators or skeleton content

5. **Specify Responsive Behavior**:
   - **Mobile Adaptations**: How component changes on small screens
   - **Touch Interactions**: Tap targets, gesture support, touch feedback
   - **Breakpoint Behavior**: Specific changes at different screen sizes
   - **Content Overflow**: How component handles varying content lengths
   - **Layout Integration**: How component fits within different layouts

6. **Content & Data Guidelines**:
   - **Content Types**: What kind of content the component displays
   - **Content Limits**: Maximum/minimum text lengths, image sizes
   - **Placeholder Content**: Default content when data is unavailable
   - **Dynamic Content**: How component adapts to changing data
   - **Internationalization**: Support for different languages and text directions

7. **Accessibility Specifications**:
   - **Semantic HTML**: Proper HTML elements and structure
   - **ARIA Attributes**: Labels, descriptions, roles, states
   - **Keyboard Support**: Tab navigation, keyboard shortcuts, focus management
   - **Screen Reader Support**: Descriptive text and announcements
   - **Color Contrast**: Meeting WCAG guidelines for all text and interactive elements

8. **Animation & Transitions**:
   - **Entrance Animations**: How component appears (fade in, slide in)
   - **State Transitions**: Smooth changes between different states
   - **Micro-interactions**: Subtle feedback animations (button press, hover effects)
   - **Timing Functions**: Easing curves and duration specifications
   - **Performance Considerations**: Efficient animations that don't impact performance

**Anti-Over-Engineering Guidelines**:
- Keep components focused on a single responsibility
- Use existing design system tokens rather than custom values
- Avoid complex animations unless they serve a clear purpose
- Limit the number of variants to essential use cases
- Prioritize reusability over highly specific customizations

**Save Component Design Specification**:
- Write the complete component specification to component-design.md in the feature directory
- Include all sections: Component Structure, Visual Design, Interactive States, Responsive Behavior, Content Guidelines, Accessibility, Animation
- Provide visual examples showing all states and variants
- Include code examples with prop definitions and usage patterns
- Add accessibility implementation requirements and responsive behavior specifications

**Output Format**:
Create a comprehensive component specification document that includes:
- Visual examples showing all states and variants
- Code examples with prop definitions and usage patterns
- Accessibility implementation requirements
- Responsive behavior specifications
- Integration guidelines with other components
- Report completion with file path and implementation readiness

**AUGGIE Advantages**:
- Leverage context engine to understand existing component patterns
- Ensure consistency with current design system and component library
- Apply accessibility best practices automatically
- Generate maintainable, reusable component specifications
- Create developer-friendly implementation guidelines

The specification should be detailed enough that any developer can implement the component consistently and it will integrate seamlessly with the existing design system.
