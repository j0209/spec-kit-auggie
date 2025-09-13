#!/usr/bin/env bash
# Get paths for current feature branch without creating anything
# Used by commands that need to find existing feature files
# Usage: ./get-feature-paths.sh [--project=project-name]

set -e

PROJECT_NAME=""

# Parse arguments
for arg in "$@"; do
    case "$arg" in
        --project=*) PROJECT_NAME="${arg#*=}" ;;
        --help|-h)
            echo "Usage: $0 [--project=project-name]"
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

# Output paths (don't create anything)
echo "REPO_ROOT: $REPO_ROOT"
echo "BRANCH: $CURRENT_BRANCH"
echo "FEATURE_DIR: $FEATURE_DIR"
echo "FEATURE_SPEC: $FEATURE_SPEC"
echo "IMPL_PLAN: $IMPL_PLAN"
echo "TASKS: $TASKS"

# Output project-specific paths if applicable
if [[ -n "$PROJECT_NAME" ]]; then
    echo "PROJECT_NAME: $PROJECT_NAME"
    echo "PROJECT_DIR: $PROJECT_DIR"
fi