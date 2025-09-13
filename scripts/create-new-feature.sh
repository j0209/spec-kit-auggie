#!/usr/bin/env bash
# Create a new feature with branch, directory structure, and template
# Usage: ./create-new-feature.sh "feature description"
#        ./create-new-feature.sh --json "feature description"
#        ./create-new-feature.sh --project=project-name "feature description"

set -e

JSON_MODE=false
PROJECT_NAME=""

# Collect non-flag args
ARGS=()
for arg in "$@"; do
    case "$arg" in
        --json)
            JSON_MODE=true
            ;;
        --project=*)
            PROJECT_NAME="${arg#*=}"
            ;;
        --help|-h)
            echo "Usage: $0 [--json] [--project=project-name] <feature_description>"
            echo "  --json              Output paths in JSON format"
            echo "  --project=name      Create feature in specific project (recommended for new multi-project structure)"
            echo "  --help              Show this help"
            echo ""
            echo "Examples:"
            echo "  $0 --project=task-manager \"Add user authentication\""
            echo "  $0 --json --project=task-manager \"Add user authentication\""
            echo "  $0 \"Legacy feature\" # Uses old structure for backward compatibility"
            exit 0 ;;
        *)
            ARGS+=("$arg") ;;
    esac
done

FEATURE_DESCRIPTION="${ARGS[*]}"
if [ -z "$FEATURE_DESCRIPTION" ]; then
        echo "Usage: $0 [--json] [--project=project-name] <feature_description>" >&2
        exit 1
fi

# Get repository root
REPO_ROOT=$(git rev-parse --show-toplevel)

# Determine directory structure based on project parameter
if [[ -n "$PROJECT_NAME" ]]; then
    # Project-specific structure
    PROJECT_DIR="$REPO_ROOT/projects/$PROJECT_NAME"
    if [[ ! -d "$PROJECT_DIR" ]]; then
        echo "Error: Project '$PROJECT_NAME' does not exist at $PROJECT_DIR" >&2
        echo "Available projects:" >&2
        if [[ -d "$REPO_ROOT/projects" ]]; then
            ls -1 "$REPO_ROOT/projects" 2>/dev/null | sed 's/^/  - /' || echo "  (none)" >&2
        else
            echo "  (none - use auggie-new-project to create a project first)" >&2
        fi
        exit 1
    fi
    SPECS_DIR="$PROJECT_DIR/specs"
else
    # Legacy structure for backward compatibility
    SPECS_DIR="$REPO_ROOT/specs"
fi

# Create specs directory if it doesn't exist
mkdir -p "$SPECS_DIR"

# Find the highest numbered feature directory
HIGHEST=0
if [ -d "$SPECS_DIR" ]; then
    for dir in "$SPECS_DIR"/*; do
        if [ -d "$dir" ]; then
            dirname=$(basename "$dir")
            number=$(echo "$dirname" | grep -o '^[0-9]\+' || echo "0")
            number=$((10#$number))
            if [ "$number" -gt "$HIGHEST" ]; then
                HIGHEST=$number
            fi
        fi
    done
fi

# Generate next feature number with zero padding
NEXT=$((HIGHEST + 1))
FEATURE_NUM=$(printf "%03d" "$NEXT")

# Create branch name from description
BRANCH_NAME=$(echo "$FEATURE_DESCRIPTION" | \
    tr '[:upper:]' '[:lower:]' | \
    sed 's/[^a-z0-9]/-/g' | \
    sed 's/-\+/-/g' | \
    sed 's/^-//' | \
    sed 's/-$//')

# Extract 2-3 meaningful words
WORDS=$(echo "$BRANCH_NAME" | tr '-' '\n' | grep -v '^$' | head -3 | tr '\n' '-' | sed 's/-$//')

# Final branch name
BRANCH_NAME="${FEATURE_NUM}-${WORDS}"

# Create and switch to new branch
git checkout -b "$BRANCH_NAME"

# Create feature directory
FEATURE_DIR="$SPECS_DIR/$BRANCH_NAME"
mkdir -p "$FEATURE_DIR"

# Copy template if it exists
TEMPLATE="$REPO_ROOT/templates/spec-template.md"
SPEC_FILE="$FEATURE_DIR/spec.md"

if [ -f "$TEMPLATE" ]; then
    cp "$TEMPLATE" "$SPEC_FILE"
else
    echo "Warning: Template not found at $TEMPLATE" >&2
    touch "$SPEC_FILE"
fi

if $JSON_MODE; then
    if [[ -n "$PROJECT_NAME" ]]; then
        printf '{"BRANCH_NAME":"%s","SPEC_FILE":"%s","FEATURE_NUM":"%s","PROJECT_NAME":"%s","PROJECT_DIR":"%s"}\n' \
            "$BRANCH_NAME" "$SPEC_FILE" "$FEATURE_NUM" "$PROJECT_NAME" "$PROJECT_DIR"
    else
        printf '{"BRANCH_NAME":"%s","SPEC_FILE":"%s","FEATURE_NUM":"%s"}\n' \
            "$BRANCH_NAME" "$SPEC_FILE" "$FEATURE_NUM"
    fi
else
    # Output results for the LLM to use (legacy key: value format)
    echo "BRANCH_NAME: $BRANCH_NAME"
    echo "SPEC_FILE: $SPEC_FILE"
    echo "FEATURE_NUM: $FEATURE_NUM"
    if [[ -n "$PROJECT_NAME" ]]; then
        echo "PROJECT_NAME: $PROJECT_NAME"
        echo "PROJECT_DIR: $PROJECT_DIR"
    fi
fi