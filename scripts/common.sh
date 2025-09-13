#!/usr/bin/env bash
# Common functions and variables for all scripts

# Get repository root
get_repo_root() {
    git rev-parse --show-toplevel
}

# Get current branch
get_current_branch() {
    git rev-parse --abbrev-ref HEAD
}

# Check if current branch is a feature branch
# Returns 0 if valid, 1 if not
check_feature_branch() {
    local branch="$1"
    if [[ ! "$branch" =~ ^[0-9]{3}- ]]; then
        echo "ERROR: Not on a feature branch. Current branch: $branch"
        echo "Feature branches should be named like: 001-feature-name"
        return 1
    fi
    return 0
}

# Get feature directory path (legacy - for backward compatibility)
get_feature_dir() {
    local repo_root="$1"
    local branch="$2"
    echo "$repo_root/specs/$branch"
}

# Get project directory path
get_project_dir() {
    local repo_root="$1"
    local project_name="$2"
    echo "$repo_root/projects/$project_name"
}

# Get feature directory path within a project
get_project_feature_dir() {
    local repo_root="$1"
    local project_name="$2"
    local branch="$3"
    echo "$repo_root/projects/$project_name/specs/$branch"
}

# Validate project exists
validate_project_exists() {
    local repo_root="$1"
    local project_name="$2"
    local project_dir=$(get_project_dir "$repo_root" "$project_name")

    if [[ ! -d "$project_dir" ]]; then
        echo "ERROR: Project '$project_name' does not exist at $project_dir"
        echo "Available projects:"
        if [[ -d "$repo_root/projects" ]]; then
            ls -1 "$repo_root/projects" 2>/dev/null | sed 's/^/  - /' || echo "  (none)"
        else
            echo "  (none - projects directory doesn't exist)"
        fi
        return 1
    fi
    return 0
}

# Get all standard paths for a feature
# Usage: eval $(get_feature_paths [project_name])
# Sets: REPO_ROOT, CURRENT_BRANCH, FEATURE_DIR, FEATURE_SPEC, IMPL_PLAN, TASKS
# If project_name is provided, uses project-specific structure
# If not provided, uses legacy structure for backward compatibility
get_feature_paths() {
    local project_name="$1"
    local repo_root=$(get_repo_root)
    local current_branch=$(get_current_branch)
    local feature_dir

    if [[ -n "$project_name" ]]; then
        # Project-specific structure
        feature_dir=$(get_project_feature_dir "$repo_root" "$project_name" "$current_branch")
    else
        # Legacy structure
        feature_dir=$(get_feature_dir "$repo_root" "$current_branch")
    fi

    echo "REPO_ROOT='$repo_root'"
    echo "CURRENT_BRANCH='$current_branch'"
    echo "FEATURE_DIR='$feature_dir'"
    echo "FEATURE_SPEC='$feature_dir/spec.md'"
    echo "IMPL_PLAN='$feature_dir/plan.md'"
    echo "TASKS='$feature_dir/tasks.md'"
    echo "RESEARCH='$feature_dir/research.md'"
    echo "DATA_MODEL='$feature_dir/data-model.md'"
    echo "QUICKSTART='$feature_dir/quickstart.md'"
    echo "CONTRACTS_DIR='$feature_dir/contracts'"

    # Also set project-specific variables if project_name is provided
    if [[ -n "$project_name" ]]; then
        local project_dir=$(get_project_dir "$repo_root" "$project_name")
        echo "PROJECT_NAME='$project_name'"
        echo "PROJECT_DIR='$project_dir'"
    fi
}

# Check if a file exists and report
check_file() {
    local file="$1"
    local description="$2"
    if [[ -f "$file" ]]; then
        echo "  ✓ $description"
        return 0
    else
        echo "  ✗ $description"
        return 1
    fi
}

# Check if a directory exists and has files
check_dir() {
    local dir="$1"
    local description="$2"
    if [[ -d "$dir" ]] && [[ -n "$(ls -A "$dir" 2>/dev/null)" ]]; then
        echo "  ✓ $description"
        return 0
    else
        echo "  ✗ $description"
        return 1
    fi
}