#!/usr/bin/env bash
# Setup implementation plan structure for current branch
# Returns paths needed for implementation plan generation
# Usage: ./setup-plan.sh [--json] [--project=project-name]

set -e

JSON_MODE=false
PROJECT_NAME=""

for arg in "$@"; do
    case "$arg" in
        --json) JSON_MODE=true ;;
        --project=*) PROJECT_NAME="${arg#*=}" ;;
        --help|-h)
            echo "Usage: $0 [--json] [--project=project-name]"
            echo "  --json              Output paths in JSON format"
            echo "  --project=name      Use project-specific structure"
            echo "  --help              Show this help"
            exit 0 ;;
    esac
done

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Get all paths (with optional project context)
if [[ -n "$PROJECT_NAME" ]]; then
    # Validate project exists
    REPO_ROOT=$(get_repo_root)
    validate_project_exists "$REPO_ROOT" "$PROJECT_NAME" || exit 1
    eval $(get_feature_paths "$PROJECT_NAME")
else
    eval $(get_feature_paths)
fi

# Check if on feature branch
check_feature_branch "$CURRENT_BRANCH" || exit 1

# Create specs directory if it doesn't exist
mkdir -p "$FEATURE_DIR"

# Copy plan template if it exists
TEMPLATE="$REPO_ROOT/templates/plan-template.md"
if [ -f "$TEMPLATE" ]; then
    cp "$TEMPLATE" "$IMPL_PLAN"
fi

if $JSON_MODE; then
    if [[ -n "$PROJECT_NAME" ]]; then
        printf '{"FEATURE_SPEC":"%s","IMPL_PLAN":"%s","SPECS_DIR":"%s","BRANCH":"%s","PROJECT_NAME":"%s","PROJECT_DIR":"%s"}\n' \
            "$FEATURE_SPEC" "$IMPL_PLAN" "$FEATURE_DIR" "$CURRENT_BRANCH" "$PROJECT_NAME" "$PROJECT_DIR"
    else
        printf '{"FEATURE_SPEC":"%s","IMPL_PLAN":"%s","SPECS_DIR":"%s","BRANCH":"%s"}\n' \
            "$FEATURE_SPEC" "$IMPL_PLAN" "$FEATURE_DIR" "$CURRENT_BRANCH"
    fi
else
    # Output all paths for LLM use
    echo "FEATURE_SPEC: $FEATURE_SPEC"
    echo "IMPL_PLAN: $IMPL_PLAN"
    echo "SPECS_DIR: $FEATURE_DIR"
    echo "BRANCH: $CURRENT_BRANCH"
    if [[ -n "$PROJECT_NAME" ]]; then
        echo "PROJECT_NAME: $PROJECT_NAME"
        echo "PROJECT_DIR: $PROJECT_DIR"
    fi
fi