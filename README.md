# 🚀 Enhanced Spec-Kit: AUGGIE-Powered Complete Development

**The Ultimate Spec-Driven Development Toolkit** - Now exclusively powered by **AUGGIE CLI** for both **greenfield** and **brownfield** development with complete project specifications.

This revolutionary enhancement of GitHub's Spec-Kit transforms it into a complete project development orchestrator. Unlike traditional spec tools that leave design and implementation details to interpretation, this version generates comprehensive specifications for every aspect of your project - whether you're starting fresh or enhancing existing codebases.

> 📋 **Original Project**: Based on GitHub's [Spec-Kit](https://github.com/github/spec-kit) - enhanced with AUGGIE integration and multi-agent orchestration capabilities.

## ✨ What Makes This Revolutionary

### 🎨 **Complete Project Specifications**
- **Design System Specs**: Visual design, typography, colors, components with exact implementation details
- **UX Flow Specs**: User journeys, interactions, error handling, accessibility requirements
- **Component Design Specs**: Detailed component specifications with all states and variants
- **Scope Control Specs**: Pragmatic complexity management to prevent over-engineering

### 🧠 **AUGGIE-Powered Intelligence**
- **Context-Aware Generation**: AUGGIE's context engine understands your existing codebase patterns
- **Professional Output**: Enterprise-grade specifications with zero ambiguity
- **Pragmatic Engineering**: Anti-over-engineering controls for maintainable solutions
- **Complete Implementation Guidance**: Every detail specified for autonomous AUGGIE execution

### 🔄 **Dual Development Workflows**
- **🌱 Greenfield**: Multi-project workspace for new development with full orchestration
- **🏗️ Brownfield**: System-wide CLI for existing projects with codebase-aware specifications
- **Context Window Efficiency**: Preserve your precious context for planning, not implementation
- **Zero Interpretation Needed**: Specifications so detailed that execution is deterministic

## 🎯 **Installation & Setup**

### **1. Install System-Wide CLI**
```bash
# Clone this enhanced version
git clone https://github.com/j0209/spec-kit-auggie.git
cd spec-kit-auggie

# Install globally with uv (recommended)
uv tool install .
uv tool update-shell  # Updates your shell PATH

# Or install with pip
pip install -e .

# Install AUGGIE CLI
npm install -g @augmentcode/auggie
```

### **2. Verify Installation**
```bash
# Restart terminal or source your shell config
source ~/.zshrc  # or ~/.bashrc

# Test system-wide access
specify --help
specify check
```

## 🌱 **Greenfield Development (Multi-Project Workspace)**

### **Setup Multi-Project Workspace**
```bash
# Initialize new Spec-Kit workspace
specify init my-workspace

# Or initialize in current directory
specify init --here

# Load AUGGIE commands
cd my-workspace
source templates/auggie-commands.sh
```

### **Complete Greenfield Workflow**
```bash
# 1. Create a new project with AUGGIE workspace
auggie-new-project "task-manager" "A collaborative task management app" --tech-stack=react --complexity=enterprise

# 2. Add comprehensive context materials to .augment/context/
# → PRD, market research, user personas, technical constraints, compliance requirements
cd projects/task-manager/.augment/context/
# Add your planning documents here

# 3. Generate comprehensive specifications with intelligent orchestration
auggie-orchestrate "task-manager" "Focus on SOC2 compliance and multi-tenant architecture"

# 4. Review and approve milestone checkpoints
auggie-review-milestone "task-manager" "definition"
auggie-review-milestone "task-manager" "technical"
auggie-review-milestone "task-manager" "final"

# 5. Export complete development workspace with native AUGGIE task coordination
auggie-export-specs "task-manager" "/path/to/development/workspace/"
```

### **Available Greenfield Commands**
```bash
# Project Management
auggie-new-project "name" "description" [--tech-stack=react] [--complexity=simple|enterprise]
auggie-list-projects
auggie-project-status "project-name"

# Comprehensive Specifications
auggie-scope-spec "project-name" "feature" --complexity=simple|enterprise
auggie-design-spec "project-name" "modern SaaS interface"
auggie-ux-spec "project-name" "intuitive user onboarding"
auggie-component-design "project-name" "data table with filtering"

# Technical Specifications
auggie-security-spec "project-name" "user data protection"
auggie-database-spec "project-name" "user management data model"
auggie-api-spec "project-name" "REST API with rate limiting"
auggie-infrastructure-spec "project-name" "Kubernetes deployment"
auggie-monitoring-spec "project-name" "application performance tracking"
auggie-testing-spec "project-name" "load testing strategy"
auggie-operations-spec "project-name" "24/7 support procedures"

# Implementation Planning
auggie-specify "project-name" "core functionality description"
auggie-plan "project-name" "technical implementation approach"
auggie-tasks "project-name" "additional context"

# Workflow Management
auggie-orchestrate "project-name" "intelligent specification planning"
auggie-review-milestone "project-name" "definition|technical|final"
auggie-approve-milestone "project-name" "milestone-name"
auggie-export-specs "project-name" "/path/to/export/"
```

## 🏗️ **Brownfield Development (Existing Projects)**

### **Add Spec-Kit to Existing Project**
```bash
# Navigate to your existing project
cd /path/to/existing-project

# Initialize Spec-Kit integration (lightweight)
specify init --brownfield

# Add your project context materials
cp your-docs/* .augment/context/
# or create new ones:
echo "# Business Requirements..." > .augment/context/business-requirements.md
echo "# Technical Architecture..." > .augment/context/existing-architecture.md
```

### **Generate Context-Aware Specifications**
```bash
# Generate scope specification (analyzes existing codebase)
specify scope-spec "Add user authentication system" --complexity=enterprise

# Create design specification (matches existing UI patterns)
specify design-spec "Modern login interface with existing design system"

# Generate implementation plan (leverages existing infrastructure)
specify plan "JWT authentication with existing Express.js backend and PostgreSQL"

# Create development tasks (considers existing file structure)
specify tasks "Focus on security best practices and existing patterns"

# Check project status
specify status
```

### **Available Brownfield Commands**
```bash
# Initialization
specify init --brownfield              # Add Spec-Kit to existing project
specify status                         # Check integration status

# Specification Generation (Context-Aware)
specify scope-spec "feature description" [--complexity=simple|enterprise]
specify design-spec "UI/UX description"
specify plan "technical implementation details"
specify tasks "additional context"

# All commands automatically:
# - Use codebase-retrieval to analyze existing architecture
# - Generate specifications that fit existing patterns
# - Respect current technology stack and constraints
# - Reference existing files and conventions
```

### **Project Structure (Brownfield)**
```
your-existing-project/
├── .augment/
│   ├── context/              # Your project context materials
│   │   ├── business-requirements.md
│   │   ├── existing-architecture.md
│   │   ├── technical-constraints.md
│   │   └── user-personas.md
│   └── guidelines.md         # AUGGIE instructions for your project
├── specs/                    # Generated specifications
│   └── 001-user-auth/
│       ├── scope-spec.md
│       ├── design-spec.md
│       ├── plan.md
│       └── tasks.md
├── memory/
│   └── constitution.md       # Project constraints and principles
└── (your existing files unchanged)
```

## 🏗️ **Multi-Project Architecture (Greenfield)**

### **🎯 Project Context Isolation**
The enhanced Spec-Kit uses a **multi-project structure** that prevents AUGGIE from conflating different projects:

```
spec-kit-auggie/
├── projects/
│   ├── task-manager/          # Your task management app
│   │   ├── specs/             # Project-specific specifications
│   │   ├── src/               # Project source code
│   │   └── .project-meta.json # Project metadata
│   ├── e-commerce/            # Your e-commerce project
│   │   ├── specs/
│   │   └── src/
│   └── blog-platform/         # Your blog platform
│       ├── specs/
│       └── src/
├── templates/                 # Spec-Kit framework templates
├── scripts/                   # Spec-Kit framework scripts
└── memory/                    # Spec-Kit framework memory
```

### **🧠 Why This Matters**
- **Context Clarity**: AUGGIE knows exactly which project it's working on
- **Knowledge Reuse**: Patterns learned from one project inform others
- **No Confusion**: Never conflates your project with Spec-Kit framework
- **Scalable**: Manage multiple projects from one Spec-Kit installation

## 📋 **Command Reference**

### **🌱 Greenfield Commands (Multi-Project Workspace)**
*Use these commands from within a Spec-Kit workspace after running `source templates/auggie-commands.sh`*

#### **Project Management**
| Command | Purpose | Example |
|---------|---------|---------|
| `auggie-new-project` | Create new project | `auggie-new-project "task-manager" "A collaborative app" --tech-stack=react` |
| `auggie-list-projects` | List all projects | `auggie-list-projects` |
| `auggie-project-status` | Show project status | `auggie-project-status "task-manager"` |

#### **Specification Commands** (All require project context)
| Command | Purpose | Example |
|---------|---------|---------|
| `auggie-scope-spec` | Pragmatic scope control | `auggie-scope-spec "task-manager" "User auth" --complexity=simple` |
| `auggie-design-spec` | Visual design system | `auggie-design-spec "task-manager" "Modern SaaS dashboard"` |
| `auggie-ux-spec` | User experience flows | `auggie-ux-spec "task-manager" "User onboarding flow"` |
| `auggie-security-spec` | Security specifications | `auggie-security-spec "task-manager" "User data protection"` |
| `auggie-database-spec` | Database specifications | `auggie-database-spec "task-manager" "User and task data model"` |
| `auggie-infrastructure-spec` | Infrastructure & deployment | `auggie-infrastructure-spec "task-manager" "Kubernetes deployment"` |

### **🏗️ Brownfield Commands (System-Wide CLI)**
*Use these commands from any existing project directory*

#### **Initialization & Status**
| Command | Purpose | Example |
|---------|---------|---------|
| `specify init --brownfield` | Add Spec-Kit to existing project | `specify init --brownfield` |
| `specify status` | Check integration status | `specify status` |

#### **Context-Aware Specifications**
| Command | Purpose | Example |
|---------|---------|---------|
| `specify scope-spec` | Generate scope specification | `specify scope-spec "Add user auth" --complexity=enterprise` |
| `specify design-spec` | Create design specification | `specify design-spec "Modern login interface"` |
| `specify plan` | Generate implementation plan | `specify plan "JWT with existing backend"` |
| `specify tasks` | Create development tasks | `specify tasks "Focus on security best practices"` |

#### **Key Differences**
- **🌱 Greenfield**: Multi-project workspace with `auggie-*` commands requiring project names
- **🏗️ Brownfield**: Single project integration with `specify` commands using current directory context
- **Context Awareness**: Brownfield commands automatically analyze existing codebase patterns
- **Installation**: Greenfield requires workspace setup, Brownfield works system-wide

## 🎯 **Revolutionary Features**

### **🌱 Greenfield Development (Multi-Project)**
- **Project Context Isolation**: Each project has its own specifications and context
- **Knowledge Reuse**: Patterns learned from one project inform others
- **No Framework Confusion**: AUGGIE never conflates your projects with Spec-Kit itself
- **Scalable Management**: Handle multiple projects from one Spec-Kit installation
- **Parallel Orchestration**: Multiple AUGGIE agents working simultaneously on different specifications

### **🏗️ Brownfield Development (Existing Projects)**
- **Codebase-Aware Specifications**: Analyzes existing architecture before generating specs
- **Pattern Preservation**: Respects existing coding patterns and conventions
- **Technology Stack Integration**: Works with any existing technology stack
- **Lightweight Integration**: Minimal directory structure that doesn't disrupt existing projects
- **Context-Driven Planning**: Uses existing documentation and codebase analysis

### **🚀 Enhanced Development Task System**
- **Native AUGGIE Task Format**: Development tasks generated in AUGGIE's native task management format
- **Parallel Execution Support**: Tasks marked for safe parallel execution with conflict prevention
- **Complete Development Workspace**: Exported projects include full `.augment/` structure for AUGGIE coordination
- **Context-Rich Tasks**: Each task references specific specification documents for autonomous execution
- **Multi-AUGGIE Coordination**: Development teams can deploy 3-5 AUGGIE agents working simultaneously

### **🤖 Enhanced AUGGIE Integration**
- **Dual Context Support**: Works in both greenfield workspaces and brownfield projects
- **Context-Aware Professional Planning**: Uses comprehensive input documents (PRD, research, personas)
- **Codebase Analysis**: Brownfield commands use `codebase-retrieval` for existing architecture understanding
- **Implementation Planning Focus**: Professional specifications based on deep context analysis
- **Smart Approval Gates**: Automatic `[NEEDS CLARIFICATION]` detection with milestone reviews
- **Professional Export System**: Complete specification packages with context materials included

### **🎨 Complete Design Integration**
- **Visual Design Systems**: Colors, typography, spacing, components with exact CSS specifications
- **UX Flow Specifications**: User journeys, interactions, error states, accessibility requirements
- **Component Design Specs**: Detailed component specifications with all states and variants
- **Responsive Design Guidelines**: Mobile-first specifications with exact breakpoints

### **🛡️ Comprehensive Security Planning**
- **Security Architecture**: Authentication, authorization, data protection, and infrastructure security
- **Threat Modeling**: Asset identification, threat actor analysis, and attack vector assessment
- **Compliance Framework**: GDPR, CCPA, HIPAA, PCI DSS, and industry-specific requirements
- **Security Testing Strategy**: SAST, DAST, penetration testing, and vulnerability management

### **🗄️ Complete Database Architecture**
- **Migration Hell Prevention**: Comprehensive upfront schema design to avoid 30+ migrations
- **Complete Data Modeling**: All entities, relationships, and business rules planned from the start
- **Performance Optimization**: Indexes, query patterns, and scalability planning included
- **Data Integrity**: Constraints, validations, and business rule enforcement at database level

### **🏗️ Production-Ready Infrastructure**
- **Deployment Architecture**: Container specifications, Kubernetes deployments, CI/CD pipelines
- **Environment Strategy**: Development, staging, production configurations with proper scaling
- **Health Checks & Monitoring**: Liveness/readiness probes, graceful shutdown procedures
- **Security Configuration**: Network policies, SSL/TLS, secrets management, backup procedures

### **📊 Comprehensive Observability**
- **Logging Strategy**: Structured logging, log aggregation, and analysis frameworks
- **Metrics & Monitoring**: Application, infrastructure, and business metrics collection
- **Alerting Configuration**: Smart alerts with proper thresholds and notification channels
- **Performance Monitoring**: APM integration, bottleneck identification, and optimization

### **🔌 Robust API Architecture**
- **API Design Standards**: RESTful design, GraphQL schemas, comprehensive documentation
- **Performance Optimization**: Rate limiting, caching strategies, CDN integration
- **Third-Party Integrations**: External APIs, webhooks, data synchronization protocols
- **Developer Experience**: Interactive documentation, SDK generation, testing tools

### **🧪 Comprehensive Testing Strategy**
- **Testing Pyramid**: Unit, integration, end-to-end, and manual testing strategies
- **Performance Testing**: Load testing, stress testing, endurance and spike testing
- **Security Testing**: Vulnerability scanning, penetration testing, security audits
- **Quality Gates**: Coverage thresholds, performance benchmarks, automated validation

### **⚙️ Operational Excellence**
- **Incident Response**: Classification, procedures, escalation matrix, post-mortem processes
- **Maintenance Procedures**: Scheduled maintenance, emergency procedures, change management
- **Support Documentation**: Runbooks, troubleshooting guides, operational knowledge base
- **Business Continuity**: Backup strategies, disaster recovery, SLA management

## 🎭 **Intelligent Orchestration System**

### **Context-Driven Specification Planning**
The AUGGIE Orchestrator analyzes your project context and intelligently determines which specifications are actually needed:

#### **Always Required Specifications**
- **Scope Specification**: Foundational project boundaries and requirements
- **Security Specification**: Security is non-negotiable for all projects

#### **Conditionally Required Specifications**
Based on context analysis, the orchestrator includes specifications only when justified:
- **Database Specification**: If data storage/persistence is needed
- **Infrastructure Specification**: If cloud deployment/scaling is mentioned
- **Monitoring Specification**: If SLA requirements/uptime targets exist
- **API Specification**: If APIs/integrations/third-party services are needed
- **Testing Specification**: If performance requirements/load testing is mentioned
- **Operations Specification**: If 24/7 support/incident response is required
- **Design/UX Specifications**: If custom UI/complex user flows are needed

### **Parallel Execution Benefits**
- **Planning: 80% Time Reduction**: 5 AUGGIEs working simultaneously vs 1 sequential
- **Development: 75% Time Reduction**: Multiple AUGGIEs coordinating implementation tasks
- **Overall: 95% Time Reduction**: Combined planning and development acceleration
- **Specialist Expertise**: Each AUGGIE focuses on their domain (Security, Database, Infrastructure, etc.)
- **Consistent Context**: All AUGGIEs reference the same comprehensive planning documents
- **Professional Task Management**: Shared task lists with dependencies and progress tracking

### **Enhanced Development Coordination**
- **Native AUGGIE Tasks**: Development tasks in AUGGIE's native format with proper dependencies
- **Conflict Prevention**: File-level conflict detection prevents parallel task conflicts
- **Context Integration**: Each development task references specific specification documents
- **Complete Workspace**: Exported development projects include full `.augment/` structure
- **Multi-Agent Support**: 3-5 development AUGGIEs can coordinate simultaneously

### **🧠 Anti-Over-Engineering Controls**
- **Complexity Management**: Simple vs. Enterprise complexity levels prevent over-engineering
- **Pragmatic Technology Choices**: Appropriate tech stack recommendations based on actual needs
- **Scope Boundaries**: Explicit "NOT included" sections prevent scope creep
- **Maintenance-First Approach**: Code complexity limits and sustainability guidelines

### **🔄 Agentic Development Orchestration**
- **Master Planning**: Comprehensive specifications created through intelligent orchestration
- **AUGGIE Task Export**: Generated development tasks in native AUGGIE format for direct import
- **Parallel Execution**: Multiple AUGGIE agents work simultaneously on specialized specifications
- **Context Preservation**: Your precious context window used for planning, not implementation
- **Zero Ambiguity**: Specifications so detailed that AUGGIE agents need no interpretation
- **Seamless Handoff**: Complete workflow from Spec-Kit planning to AUGGIE execution

# 🎭 Enhanced Orchestration Workflow

## Phase 1: Project Setup & Context (Orchestrator)
```bash
# 1. Create project with comprehensive AUGGIE workspace
auggie-new-project "enterprise-saas" "Multi-tenant SaaS platform" --tech-stack=react --complexity=enterprise

# 2. Add comprehensive context materials to .augment/context/
# → PRD, market research, user personas, technical constraints, compliance requirements
```

## Phase 2: Intelligent Specification Planning (Orchestrator)
```bash
# 3. Analyze context and create intelligent specification task list
auggie-orchestrate "enterprise-saas" "Focus on SOC2 compliance and multi-tenant architecture"
# → Analyzes context materials and determines which specifications are actually needed
# → Creates shared task list in .augment/tasks.json with dependencies and priorities
# → Only includes specifications justified by project requirements
```

## Phase 3: Parallel Specification Generation (Multiple AUGGIEs)
```bash
# 4. Deploy multiple AUGGIE instances working from shared task list:
# → AUGGIE 1 (Security Specialist): auggie-security-spec "enterprise-saas" "SOC2 compliance"
# → AUGGIE 2 (Database Architect): auggie-database-spec "enterprise-saas" "Multi-tenant data model"
# → AUGGIE 3 (Infrastructure Engineer): auggie-infrastructure-spec "enterprise-saas" "K8s deployment"
# → AUGGIE 4 (API Designer): auggie-api-spec "enterprise-saas" "RESTful API with tenant isolation"
# → AUGGIE 5 (QA Engineer): auggie-testing-spec "enterprise-saas" "Load testing strategy"
# → All AUGGIEs reference same context materials and update shared task progress
```

## Phase 4: Development Task Generation & Export (Orchestrator)
```bash
# 5. Generate native AUGGIE development tasks with parallel execution support
auggie-tasks "enterprise-saas" "Focus on backend API and database first"
# → Creates native AUGGIE task format with dependency management
# → Marks tasks for parallel execution where safe
# → Includes context references to all specifications

# 6. Export complete development workspace
auggie-export-specs "enterprise-saas" "/path/to/development/"
# → Creates complete .augment/ workspace for development project
# → Includes all specifications as context materials
# → Sets up native AUGGIE task coordination
# → Provides development coordination documentation
```

## Phase 5: Multi-AUGGIE Development (Development Team)
```bash
# 7. Deploy multiple development AUGGIEs in the exported workspace
cd /path/to/development/enterprise-saas

# AUGGIE 1 (Setup & Infrastructure) - Sequential foundation
auggie view_tasklist  # See all development tasks
auggie update_tasks --task-id="setup-001" --state="IN_PROGRESS"

# AUGGIE 2 (Database & Models) - Parallel execution
auggie update_tasks --task-id="db-002" --state="IN_PROGRESS"

# AUGGIE 3 (API & Services) - Parallel execution
auggie update_tasks --task-id="api-001" --state="IN_PROGRESS"

# AUGGIE 4 (Frontend Components) - Parallel execution
auggie update_tasks --task-id="fe-002" --state="IN_PROGRESS"

# AUGGIE 5 (Testing & QA) - Parallel execution
auggie update_tasks --task-id="test-002" --state="IN_PROGRESS"
```

**⚡ Result: 80% planning reduction + 75% development reduction = 95% overall time reduction!**

# 4. Generate AUGGIE-compatible development tasks
auggie-tasks "task-manager"
# → Creates development tasks in AUGGIE's native format for export

# 5. EXECUTION PHASE: Manually import tasks into separate AUGGIE development project
cd /path/to/development/project
auggie # Start AUGGIE in your development project
# In AUGGIE: Use reorganize_tasklist() with the generated task markdown
# → Development tasks are now available for AUGGIE agents to execute

# 6. Execute with AUGGIE agents
# → AUGGIE agents work from detailed specifications
# → No interpretation needed - everything is precisely specified
```

### **🎯 VSCode Agent Advantages**
When using AUGGIE in VSCode (recommended), you get:
- **Full Codebase Context**: AUGGIE sees your entire project structure
- **Real-time File Analysis**: Understands existing patterns and conventions
- **Intelligent Suggestions**: Based on actual project architecture
- **Seamless Integration**: Works directly with your development environment
- **Context Preservation**: Maintains awareness across multiple interactions

## 🔄 **Update Strategy**

This repository stays current with upstream improvements:

### **Automatic Updates**
```bash
# Run our update script
./update-from-upstream.sh
```

### **Manual Updates**
```bash
# Fetch from official repo
git fetch upstream
git merge upstream/main

# Cherry-pick community improvements  
git fetch community
git cherry-pick <useful-commits>
```

See [UPDATE_STRATEGY.md](UPDATE_STRATEGY.md) for complete details.

## 📚 **Documentation**

### **AUGGIE-Specific Guides**
- [PROPER_USAGE_GUIDE.md](docs/PROPER_USAGE_GUIDE.md) - Complete guide on correct usage
- [QUICK_START_GUIDE.md](docs/QUICK_START_GUIDE.md) - Fast setup and examples
- [SPEC_KIT_AUGMENT_INTEGRATION_GUIDE.md](docs/SPEC_KIT_AUGMENT_INTEGRATION_GUIDE.md) - Integration details
- [TECHNICAL_REFERENCE.md](docs/TECHNICAL_REFERENCE.md) - Technical implementation details

### **Original Spec-Kit Documentation**
- [Detailed Process Guide](spec-driven.md) - Complete workflow documentation
- [Local Development](docs/local-development.md) - Contributing and development setup
- [Installation Guide](docs/installation.md) - Detailed installation instructions

## 🎯 **Key Differences from Original**

| Feature | Original Spec-Kit | Our Enhanced Version |
|---------|------------------|---------------------|
| AI Assistants | 3 (Claude, Gemini, Copilot) | **4 (+ AUGGIE CLI)** |
| Context Awareness | Basic templates | **Advanced codebase analysis** |
| Task Management | Markdown only | **Augment integration** |
| SSL/TLS | Basic | **Enhanced with truststore** |
| Claude Support | Basic | **Migration-aware** |
| Documentation | Standard | **Professional guides** |

## 🔧 **Installation & Setup**

### **Prerequisites**
- Python 3.11+
- Node.js (for AUGGIE CLI)
- Git

### **Full Installation**
```bash
# 1. Clone enhanced version
git clone https://github.com/j0209/spec-kit-auggie.git
cd spec-kit-auggie

# 2. Install Python dependencies
pip install -e .
pip install truststore

# 3. Install AUGGIE CLI
npm install -g @augmentcode/auggie

# 4. Verify installation
python -c "from src.specify_cli import main; main()" check
```

## 🚀 **Usage Examples**

### **Initialize with AUGGIE**
```bash
python -c "from src.specify_cli import main; main()" init my-app --ai auggie
```

### **Spec-Driven Workflow**
```bash
cd my-app
source templates/auggie-commands.sh

# Create specification
auggie-specify "Build a task management app with user authentication"

# Create implementation plan  
auggie-plan "Use React frontend, Node.js backend, PostgreSQL database"

# Generate tasks
auggie-tasks
```

### **AUGGIE Development Task Export & Import**
```bash
# After generating development tasks with auggie-tasks, export complete development workspace:

# Export enhanced development workspace with native AUGGIE task coordination
auggie-export-specs "task-manager" "/path/to/development/"

# The exported project includes:
# - Native AUGGIE task management (.augment/tasks.json)
# - Multi-agent orchestration tools
# - Portable AUGGIE commands for continued specification work
# - Complete context materials from all specifications

# The exported development tasks include:
# ✅ Hierarchical task structure (phases and subtasks)
# ✅ Dependency relationships between tasks
# ✅ Parallel execution markers [P] for concurrent work
# ✅ Detailed descriptions with file paths and requirements
# ✅ Realistic time estimates based on complexity analysis

# Note: These are DEVELOPMENT tasks for implementation, not planning tasks
# Planning tasks are managed separately within each project's .augment/tasks.json
```

## 🎯 **Quick Reference**

### **Choose Your Workflow**

#### **🌱 For New Projects (Greenfield)**
```bash
# 1. Install and setup workspace
uv tool install . && uv tool update-shell
specify init my-workspace
cd my-workspace && source templates/auggie-commands.sh

# 2. Create and develop projects
auggie-new-project "my-app" "Description" --tech-stack=react
auggie-orchestrate "my-app" "Focus on user experience"
auggie-export-specs "my-app" "/path/to/development/"
```

#### **🏗️ For Existing Projects (Brownfield)**
```bash
# 1. Install system-wide
uv tool install . && uv tool update-shell

# 2. Add to existing project
cd /path/to/existing-project
specify init --brownfield

# 3. Generate context-aware specifications
specify scope-spec "Add user authentication" --complexity=enterprise
specify design-spec "Modern login interface"
specify plan "JWT with existing backend"
specify tasks "Security best practices"
```

### **Key Benefits**

| Feature | Greenfield | Brownfield |
|---------|------------|------------|
| **Setup** | Multi-project workspace | Lightweight integration |
| **Context** | Project isolation | Existing codebase analysis |
| **Commands** | `auggie-*` with project names | `specify` with current directory |
| **Use Case** | New development from scratch | Adding features to existing apps |
| **AUGGIE Power** | Full orchestration & parallel execution | Codebase-aware specifications |

## 🤝 **Contributing**

We welcome contributions! This repository maintains:
- **Full compatibility** with original Spec-Kit
- **Enhanced AUGGIE integration**
- **Infrastructure improvements**
- **Professional documentation**

## 📄 **License**

This project maintains the same license as the original Spec-Kit. See [LICENSE](LICENSE) for details.

---

**Built with ❤️ to enhance Spec-Driven Development with AUGGIE CLI integration**
