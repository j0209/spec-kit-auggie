# AUGGIE Agent Instructions for Spec-Driven Development

You are working in a **Spec-Driven Development (SDD)** environment where specifications drive implementation, not the other way around. This project uses the Specify framework to implement SDD methodology.

## Core SDD Principles

1. **Specifications are executable** - They directly generate working implementations
2. **Intent-driven development** - Focus on the "what" and "why" before the "how"
3. **Multi-step refinement** - Iterative improvement rather than one-shot generation
4. **Heavy reliance on AI** - Leverage advanced AI capabilities for specification interpretation

## Available Commands

This project provides three main commands for the SDD workflow:

### `auggie-specify` - Create Specifications
Start a new feature by creating a specification and feature branch. This is the first step in the SDD lifecycle.

**Usage:**
```bash
auggie-specify "Feature description here"
```

**What it does:**
- Creates a new feature branch
- Generates a comprehensive specification using templates
- Sets up the foundation for implementation planning

### `auggie-plan` - Create Implementation Plans  
Plan how to implement the specified feature. This is the second step in the SDD lifecycle.

**Usage:**
```bash
auggie-plan "Technical implementation details here"
```

**What it does:**
- Analyzes the feature specification
- Creates detailed implementation plans
- Generates technical artifacts (data models, contracts, etc.)
- Incorporates organizational constraints from constitution

### `auggie-tasks` - Generate Task Lists
Break down the plan into executable tasks. This is the third step in the SDD lifecycle.

**Usage:**
```bash
auggie-tasks "Additional context for task generation"
```

**What it does:**
- Analyzes implementation plans and artifacts
- Creates numbered, executable tasks
- Identifies parallel execution opportunities
- Provides clear dependency ordering

## Project Structure

- `memory/constitution.md` - Non-negotiable project principles and constraints
- `specs/` - Feature specifications and implementation plans
- `templates/` - Templates for specifications, plans, and tasks
- `scripts/` - Automation scripts for the SDD workflow

## Working with AUGGIE

Since you have access to Augment's powerful context engine, you can:

1. **Leverage full codebase context** - Use your understanding of the entire project
2. **Understand organizational constraints** - Read and apply the constitution
3. **Generate high-quality specifications** - Use your context awareness for better specs
4. **Create realistic implementation plans** - Base plans on actual codebase patterns
5. **Provide executable tasks** - Generate tasks that are immediately actionable

## Key Guidelines

1. **Always read the constitution** (`memory/constitution.md`) before making decisions
2. **Use absolute file paths** when working with scripts and templates
3. **Follow the SDD methodology** - Spec → Plan → Tasks → Implementation
4. **Leverage your context engine** - Use your understanding of the codebase
5. **Generate production-ready artifacts** - No placeholders or mock data

## Command Integration

The commands are implemented as shell functions that call you with specific prompts and templates. When a user runs `auggie-specify`, `auggie-plan`, or `auggie-tasks`, you'll receive structured prompts that guide you through the SDD process.

Your role is to be the intelligent agent that transforms high-level requirements into detailed, executable specifications and plans that can drive implementation.

Remember: In SDD, the specification is the primary artifact. Code is just its expression in a particular language and framework.
