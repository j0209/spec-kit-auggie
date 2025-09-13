---
name: auggie-ux-spec
description: "Create comprehensive user experience specifications for intuitive, accessible user flows. This ensures excellent usability and clear implementation guidance."
---

Create comprehensive user experience specifications for intuitive, accessible user flows.

This command generates complete UX specifications that ensure excellent usability and provide clear implementation guidance for developers.

Given the UX flow description provided as an argument, do this:

1. **Create UX Specification File** (with project awareness):
   - If a project name is provided in the arguments, create ux-spec.md in the project-specific feature directory (projects/PROJECT_NAME/specs/XXX-feature-name/)
   - If no project name provided, use legacy structure: specs/XXX-feature-name/ux-spec.md
   - If no feature directory exists, create one using the UX description as the feature name

2. **Analyze Existing UX Context** (with project awareness):
   - If PROJECT_NAME is provided: Focus analysis on the specific project directory (PROJECT_DIR)
   - Use your context engine to examine existing user flows and interaction patterns within the project
   - Identify current navigation structures and user journey patterns specific to the project
   - Understand the project's user types and use cases
   - Review existing forms, modals, and interactive elements within the project
   - **IMPORTANT**: Avoid conflating with other projects or the Spec-Kit framework's UX patterns

2. **Create User Journey Maps**:
   - **Entry Points**: How users arrive at this flow (direct link, navigation, search)
   - **Step-by-Step Flow**: Each screen/state with user actions and system responses
   - **Decision Points**: Where users make choices and alternative paths
   - **Success Criteria**: What constitutes successful completion of the flow
   - **Exit Points**: How users leave the flow (completion, cancellation, errors)

3. **Define Interaction Specifications**:
   - **Input Methods**: Click, tap, keyboard, voice, gesture interactions
   - **Feedback Mechanisms**: Visual, auditory, haptic responses to user actions
   - **Loading States**: Progress indicators, skeleton screens, spinners
   - **Transition Animations**: Page changes, modal appearances, state transitions
   - **Micro-interactions**: Button hover effects, form validation, success confirmations

4. **Specify Error Handling & Recovery**:
   - **Error Prevention**: Input validation, confirmation dialogs, clear instructions
   - **Error Messages**: User-friendly language, specific guidance, recovery actions
   - **Fallback Flows**: Alternative paths when primary flow fails
   - **Retry Mechanisms**: How users can attempt actions again
   - **Help & Support**: Context-sensitive help, tooltips, documentation links

5. **Content & Communication Guidelines**:
   - **Microcopy**: Button labels, form labels, instructional text
   - **Placeholder Text**: Helpful examples and guidance in form fields
   - **Empty States**: What users see when there's no content or data
   - **Success Messages**: Confirmation text and next step guidance
   - **Progressive Disclosure**: How complex information is revealed gradually

6. **Accessibility UX Requirements**:
   - **Keyboard Navigation**: Tab order, keyboard shortcuts, focus management
   - **Screen Reader Support**: ARIA labels, semantic HTML, descriptive text
   - **Motor Accessibility**: Large touch targets, alternative input methods
   - **Cognitive Accessibility**: Clear language, consistent patterns, error prevention
   - **Visual Accessibility**: High contrast modes, text scaling support

7. **Responsive UX Considerations**:
   - **Mobile-First Flow**: How the experience works on small screens
   - **Touch Interactions**: Swipe gestures, long press, pinch-to-zoom
   - **Desktop Enhancements**: Hover states, right-click menus, keyboard shortcuts
   - **Cross-Device Continuity**: How users can continue flows across devices

**Anti-Over-Engineering Guidelines**:
- Use familiar UI patterns that users already understand
- Keep flows as short and simple as possible
- Avoid unnecessary steps or complex interactions
- Use standard form patterns and validation approaches
- Prioritize clarity over cleverness in interactions

**Save UX Specification**:
- Write the complete UX specification to ux-spec.md in the feature directory
- Include all sections: User Journey Maps, Interaction Specifications, Error Handling, Content Guidelines, Accessibility Requirements, Responsive UX
- Provide visual flow diagrams showing user paths and decision points
- Include detailed interaction specifications for each UI element
- Add content guidelines with specific copy examples and error handling scenarios

**Output Format**:
Create a comprehensive UX specification document that includes:
- Visual flow diagrams showing user paths and decision points
- Detailed interaction specifications for each UI element
- Content guidelines with specific copy examples
- Error handling scenarios with recovery flows
- Accessibility compliance requirements
- Implementation notes for developers
- Report completion with file path and implementation readiness

**AUGGIE Advantages**:
- Leverage context engine to understand existing UX patterns
- Ensure consistency with current user flows and interactions
- Apply proven UX best practices automatically
- Generate accessible, inclusive user experiences
- Create developer-friendly implementation specifications

The specification should be detailed enough that any developer can implement the user experience consistently without additional UX design input.
