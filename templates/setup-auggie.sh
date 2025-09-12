#!/bin/bash
# Setup script for AUGGIE CLI integration with Spec-Driven Development

set -e

echo "🌱 Setting up AUGGIE CLI for Spec-Driven Development..."

# Check if AUGGIE CLI is installed
if ! command -v auggie &> /dev/null; then
    echo "❌ AUGGIE CLI not found!"
    echo "📦 Install with: npm install -g @augmentcode/auggie"
    echo "📖 See: https://docs.augmentcode.com/cli/overview"
    exit 1
fi

# Check if user is logged in to Augment
echo "🔐 Checking Augment authentication..."
if ! auggie --print --quiet "Hello" &> /dev/null; then
    echo "❌ Not logged in to Augment!"
    echo "🔑 Please run: auggie login"
    exit 1
fi

echo "✅ AUGGIE CLI is installed and authenticated"

# Source the AUGGIE commands
if [ -f "auggie-commands.sh" ]; then
    echo "📜 Loading AUGGIE commands..."
    source auggie-commands.sh
    echo "✅ AUGGIE commands loaded"
else
    echo "⚠️  auggie-commands.sh not found in current directory"
fi

# Add to shell profile for persistence
add_to_profile() {
    local profile_file="$1"
    local source_line="source $(pwd)/auggie-commands.sh"
    
    if [ -f "$profile_file" ]; then
        if ! grep -q "auggie-commands.sh" "$profile_file"; then
            echo "" >> "$profile_file"
            echo "# AUGGIE CLI integration for Spec-Driven Development" >> "$profile_file"
            echo "$source_line" >> "$profile_file"
            echo "✅ Added to $profile_file"
            return 0
        else
            echo "ℹ️  Already configured in $profile_file"
            return 1
        fi
    fi
    return 1
}

# Try to add to common shell profiles
echo "🔧 Configuring shell integration..."
added=false

# Try common shell profiles
for profile in ~/.bashrc ~/.zshrc ~/.bash_profile ~/.profile; do
    if add_to_profile "$profile"; then
        added=true
        break
    fi
done

if [ "$added" = false ]; then
    echo "⚠️  Could not automatically configure shell integration"
    echo "📝 Manually add this line to your shell profile:"
    echo "   source $(pwd)/auggie-commands.sh"
fi

echo ""
echo "🎉 AUGGIE CLI setup complete!"
echo ""
echo "📚 Available commands:"
echo "   auggie-specify \"description\"  - Create feature specifications"
echo "   auggie-plan \"tech details\"    - Create implementation plans"  
echo "   auggie-tasks [context]         - Generate executable tasks"
echo "   auggie-status                  - Check project SDD status"
echo "   auggie-help                    - Show help"
echo ""
echo "🚀 Start with: auggie-specify \"Your feature description\""
echo "📖 See AUGGIE.md for detailed instructions"

# Test the integration
echo ""
echo "🧪 Testing integration..."
if auggie --print --quiet "Test connection" > /dev/null 2>&1; then
    echo "✅ AUGGIE integration test passed"
else
    echo "❌ AUGGIE integration test failed"
    echo "🔍 Check your Augment authentication and try again"
fi
