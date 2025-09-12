# Spec-Kit with AUGGIE Integration

**Enhanced Spec-Kit with AUGGIE CLI support for Spec-Driven Development**

This is an enhanced version of GitHub's Spec-Kit that adds **AUGGIE CLI** as a 4th AI assistant option alongside Claude Code, Gemini CLI, and GitHub Copilot. It includes infrastructure improvements and maintains compatibility with all official Spec-Kit features.

> 📋 **Original Documentation**: See [README-ORIGINAL.md](README-ORIGINAL.md) for the complete original Spec-Kit documentation and philosophy.

## 🚀 **What's Enhanced**

### **✅ AUGGIE CLI Integration**
- **4th AI Assistant**: AUGGIE CLI joins Claude Code, Gemini CLI, and GitHub Copilot
- **Context-Aware Specifications**: Uses Spec-Kit templates for professional output
- **Task Management Bridge**: Integrates with Augment's task management system
- **Professional Documentation**: Complete usage guides and technical reference

### **✅ Infrastructure Improvements**
- **Enhanced SSL/TLS**: Better certificate handling with truststore
- **Claude Migration Support**: Handles Claude CLI path changes after migrate-installer
- **Improved Error Handling**: Better download and extraction error handling
- **Progress Tracking**: Enhanced user experience during setup

## 🎯 **Quick Start**

### **1. Install Dependencies**
```bash
pip install specify-cli truststore
npm install -g @augmentcode/auggie  # For AUGGIE support
```

### **2. Initialize Project with AUGGIE**
```bash
# Clone this enhanced version
git clone https://github.com/j0209/spec-kit-auggie.git
cd spec-kit-auggie

# Initialize project with AUGGIE
python -c "from src.specify_cli import main; main()" init my-project --ai auggie
```

### **3. Use AUGGIE Commands**
```bash
cd my-project
source templates/auggie-commands.sh

# Spec-driven workflow with AUGGIE
auggie-specify "Add user authentication system"
auggie-plan "Use JWT tokens and bcrypt hashing"  
auggie-tasks
```

## 🤖 **AI Assistant Options**

| Assistant | Command | Description |
|-----------|---------|-------------|
| **AUGGIE CLI** | `--ai auggie` | **NEW**: Augment's context-aware AI with task management |
| Claude Code | `--ai claude` | Anthropic's Claude with IDE integration |
| Gemini CLI | `--ai gemini` | Google's Gemini with command-line interface |
| GitHub Copilot | `--ai copilot` | GitHub's AI pair programmer |

## 📋 **AUGGIE Integration Features**

### **Context-Aware Specifications**
- Uses Spec-Kit templates for professional output
- Analyzes existing codebase patterns
- Handles ambiguity with `[NEEDS CLARIFICATION]` markers
- Follows enterprise-grade specification standards

### **Task Management Bridge**
- Converts Spec-Kit tasks to Augment format
- Maintains task hierarchy and dependencies
- Supports parallel execution markers
- Integrates with Augment's task tracking

### **Professional Workflow**
```bash
# Proper AUGGIE integration (context-aware)
auggie-specify "Feature description"

# NOT direct prompts (generic output)
auggie --print "Generate specification..."
```

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

### **Task Management Integration**
```bash
# Convert to Augment format
python spec-kit-augment-bridge.py tasks.md augment-tasks.md

# Import into Augment (via prompt)
# Use the generated markdown in Augment's task management
```

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
