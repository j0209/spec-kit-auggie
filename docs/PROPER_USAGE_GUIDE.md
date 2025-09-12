# Spec-Kit + AUGGIE: Proper Usage Guide

**Critical**: This guide explains the **correct way** to use Spec-Kit with AUGGIE integration after discovering that direct AUGGIE prompts produce inferior results.

## 🚨 **The Critical Discovery**

### **What We Learned**
- **❌ Direct AUGGIE prompts** produce generic, template-like specifications
- **✅ Spec-Kit integration** produces professional, context-aware specifications
- **The difference is revolutionary** - proper integration creates enterprise-grade results

### **Why Context Matters**
When AUGGIE has full Spec-Kit context, it:
- ✅ **Analyzes existing codebase** patterns and architecture
- ✅ **Reads project constitution** for constraints and standards
- ✅ **Follows exact templates** instead of generic AI patterns
- ✅ **Handles ambiguity professionally** with [NEEDS CLARIFICATION] markers
- ✅ **Creates domain-specific solutions** not generic applications

## 🎯 **Always Use These Commands**

### **✅ CORRECT Workflow**

#### 1. Load Integration
```bash
# Always start with this
source templates/auggie-commands.sh
```

#### 2. Generate Specification
```bash
# ✅ CORRECT: Uses Spec-Kit templates and codebase context
auggie-specify "Your feature description here"
```

**What This Does:**
- Loads `templates/commands/auggie/specify.md` command definition
- Runs `scripts/create-new-feature.sh` to create proper branch
- Uses `codebase-retrieval` to understand existing architecture
- Reads `memory/constitution.md` for project constraints
- Follows `templates/spec-template.md` structure exactly
- Marks ambiguities with [NEEDS CLARIFICATION] instead of guessing

#### 3. Create Implementation Plan
```bash
# ✅ CORRECT: Context-aware technical planning
auggie-plan "Your technical stack and architecture decisions"
```

#### 4. Generate Tasks
```bash
# ✅ CORRECT: Creates realistic, executable tasks
auggie-tasks
```

#### 5. Execute Tasks with Context
```bash
# ✅ CORRECT: Provides full Spec-Kit context to AUGGIE
./execute-task.sh T001
```

### **❌ NEVER Do This (Wrong Approach)**

#### Direct AUGGIE Prompts
```bash
# ❌ WRONG: Bypasses all Spec-Kit context
auggie --print "Generate a specification for..."
auggie --print "Create implementation plan for..."
auggie --print "Generate tasks for..."
```

**Why This Fails:**
- No codebase awareness
- No template structure
- No constitution compliance
- Generic assumptions instead of clarifications
- No domain context

## 📊 **Quality Comparison**

| Aspect | Direct AUGGIE (❌) | Spec-Kit Integration (✅) |
|--------|-------------------|--------------------------|
| **Template Structure** | Generic AI format | Exact Spec-Kit template |
| **Codebase Awareness** | None | Full analysis |
| **Ambiguity Handling** | Makes assumptions | [NEEDS CLARIFICATION] |
| **Domain Context** | Generic app | Project-specific |
| **Professional Quality** | AI-generated feel | Enterprise-grade |
| **Constitution Compliance** | Ignored | Built-in |
| **Branch Management** | Manual | Automated |

## 🔧 **Enhanced Task Execution**

### **The execute-task.sh Script**
```bash
#!/bin/bash
# Enhanced AUGGIE Task Execution Script
# Provides full Spec-Kit context to AUGGIE for proper task execution

TASK_ID="$1"
TASK_LINE=$(grep "^- \[ \] $TASK_ID" "$TASKS_FILE")
TASK_DESC=$(echo "$TASK_LINE" | sed 's/^- \[ \] [T0-9]* \[P\]* //')

PROMPT="Execute Spec-Kit Task: $TASK_ID

TASK DESCRIPTION:
$TASK_DESC

CONTEXT FILES TO REFERENCE:
1. Feature Specification: specs/*/spec.md
2. Implementation Plan: specs/*/plan.md  
3. Project Constitution: memory/constitution.md
4. Full Task List: specs/*/tasks.md

REQUIREMENTS:
- Follow the specifications in the context files above
- Apply constitution standards
- Use exact file paths and structure from plan.md
- Ensure implementation matches feature requirements
- Mark task complete only after verification

Please execute this task with full context awareness."

auggie --print "$PROMPT"
```

### **Why Enhanced Execution Works**
- ✅ **Full Context**: AUGGIE gets spec.md, plan.md, constitution.md, tasks.md
- ✅ **Task-Specific**: Exact requirements and file paths
- ✅ **Domain Aware**: Understands project context, not generic
- ✅ **Professional Standards**: Constitution compliance built-in

## 🎉 **Results You Can Expect**

### **With Proper Integration**
- **Professional specifications** that stakeholders can approve
- **Context-aware implementations** that fit existing architecture
- **Proper ambiguity handling** with explicit clarification requests
- **Domain-specific solutions** not generic applications
- **Enterprise-grade quality** that rivals consulting practices

### **Success Indicators**
- ✅ Specifications include execution flow tracking
- ✅ [NEEDS CLARIFICATION] markers instead of assumptions
- ✅ Business-focused requirements (no technical details)
- ✅ Proper template structure and validation
- ✅ Codebase-aware entity definitions

## 🚀 **Next Steps**

1. **Always use the integration commands** - never bypass with direct prompts
2. **Load context first** - `source templates/auggie-commands.sh`
3. **Follow the workflow** - specify → plan → tasks → execute
4. **Use enhanced execution** - `./execute-task.sh` for task implementation
5. **Verify quality** - check for professional markers and context awareness

**Remember**: The integration is the key to professional results. Direct AUGGIE prompts will always produce inferior specifications compared to proper Spec-Kit integration.
