#!/bin/bash

# Update script for spec-kit-auggie
# Safely merges updates from upstream while preserving AUGGIE integration

set -e

echo "🔄 Updating spec-kit-auggie from upstream sources..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in the right directory
if [ ! -f "src/specify_cli/__init__.py" ]; then
    print_error "Not in spec-kit-auggie directory. Please run from repository root."
    exit 1
fi

# Check if we have uncommitted changes
if ! git diff-index --quiet HEAD --; then
    print_error "You have uncommitted changes. Please commit or stash them first."
    git status --short
    exit 1
fi

# Fetch from all remotes
print_status "Fetching from all remotes..."
git fetch --all

# Check what's new in upstream
print_status "Checking for updates in upstream (github/spec-kit)..."
UPSTREAM_COMMITS=$(git rev-list HEAD..upstream/main --count)
if [ "$UPSTREAM_COMMITS" -gt 0 ]; then
    print_warning "Found $UPSTREAM_COMMITS new commits in upstream:"
    git log HEAD..upstream/main --oneline --max-count=10
    
    echo ""
    read -p "Merge these updates? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_status "Merging upstream updates..."
        if git merge upstream/main; then
            print_success "Successfully merged upstream updates"
        else
            print_error "Merge conflicts detected. Please resolve manually."
            print_status "After resolving conflicts, run: git commit"
            exit 1
        fi
    else
        print_status "Skipping upstream merge"
    fi
else
    print_success "Already up to date with upstream"
fi

# Check what's new in community fork
print_status "Checking for updates in community fork (hungthai1401/spec-kit)..."
COMMUNITY_COMMITS=$(git rev-list HEAD..community/main --count)
if [ "$COMMUNITY_COMMITS" -gt 0 ]; then
    print_warning "Found $COMMUNITY_COMMITS new commits in community fork:"
    git log HEAD..community/main --oneline --max-count=10
    
    echo ""
    print_status "Review these commits and cherry-pick useful ones manually:"
    print_status "git cherry-pick <commit-hash>"
else
    print_success "No new commits in community fork"
fi

# Verify AUGGIE integration is intact
print_status "Verifying AUGGIE integration..."
if grep -q '"auggie": "Augment AUGGIE CLI"' src/specify_cli/__init__.py; then
    print_success "AUGGIE integration intact"
else
    print_error "AUGGIE integration missing! Please restore it."
    exit 1
fi

# Test basic functionality
print_status "Testing basic functionality..."
if python -c "from src.specify_cli import main; import sys; sys.argv=['specify', 'check']; main()" > /dev/null 2>&1; then
    print_success "Basic functionality test passed"
else
    print_warning "Basic functionality test failed - please check manually"
fi

# Check if templates exist
print_status "Verifying AUGGIE templates..."
if [ -d "templates/commands/auggie" ]; then
    print_success "AUGGIE templates present"
else
    print_error "AUGGIE templates missing!"
    exit 1
fi

print_success "Update process completed!"
print_status "Next steps:"
echo "  1. Test thoroughly: python -c \"from src.specify_cli import main; main()\" check"
echo "  2. If all good: git push origin main"
echo "  3. Update documentation if needed"
