#!/bin/bash
# Create a new AUGGIE-enabled Spec-Driven Development project

set -e

PROJECT_NAME="$1"
if [ -z "$PROJECT_NAME" ]; then
    echo "Usage: $0 <project-name>"
    echo "Example: $0 my-awesome-app"
    exit 1
fi

echo "🌱 Creating AUGGIE-enabled Spec-Driven Development project: $PROJECT_NAME"

# Create project directory
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

# Copy core files from templates
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATES_DIR="$SCRIPT_DIR/templates"

echo "📁 Setting up project structure..."

# Create directories
mkdir -p memory scripts specs templates

# Copy memory files
cp "$TEMPLATES_DIR/../memory/constitution.md" memory/
cp "$TEMPLATES_DIR/../memory/constitution_update_checklist.md" memory/

# Copy scripts
cp -r "$TEMPLATES_DIR/../scripts/"* scripts/

# Copy templates
cp -r "$TEMPLATES_DIR/"* templates/

# Create AUGGIE-specific files
echo "🤖 Setting up AUGGIE integration..."

# Make scripts executable
chmod +x scripts/*.sh
chmod +x templates/setup-auggie.sh
chmod +x templates/auggie-commands.sh

# Create README
cat > README.md << 'EOF'
# Spec-Driven Development with AUGGIE CLI

This project uses **Spec-Driven Development (SDD)** methodology with AUGGIE CLI integration.

## Quick Start

1. **Setup AUGGIE CLI:**
   ```bash
   npm install -g @augmentcode/auggie
   auggie login
   ```

2. **Setup the project:**
   ```bash
   ./templates/setup-auggie.sh
   ```

3. **Start developing:**
   ```bash
   auggie-specify "Your feature description"
   auggie-plan "Your technical approach"
   auggie-tasks
   ```

## Available Commands

- `auggie-specify "description"` - Create feature specifications
- `auggie-plan "tech details"` - Create implementation plans
- `auggie-tasks [context]` - Generate executable tasks
- `auggie-status` - Check project SDD status
- `auggie-help` - Show help

## Workflow

1. **Specify** - Describe what you want to build
2. **Plan** - Define how to build it technically
3. **Tasks** - Break it down into executable steps
4. **Implement** - Build following the generated tasks

## Documentation

- `AUGGIE.md` - AUGGIE agent instructions
- `memory/constitution.md` - Project principles and constraints
- `templates/` - Templates for specs, plans, and tasks

For more information, see the [Spec-Kit documentation](https://github.com/github/spec-kit).
EOF

# Initialize git repository
echo "📦 Initializing git repository..."
git init
git add .
git commit -m "Initial commit: AUGGIE-enabled Spec-Driven Development project"

echo ""
echo "🎉 Project '$PROJECT_NAME' created successfully!"
echo ""
echo "📚 Next steps:"
echo "   1. cd $PROJECT_NAME"
echo "   2. ./templates/setup-auggie.sh"
echo "   3. auggie-specify \"Your first feature\""
echo ""
echo "📖 See README.md for detailed instructions"
