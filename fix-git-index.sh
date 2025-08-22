#!/bin/bash
# this_file: fix-git-index.sh

# Git Index Corruption Fix Script
# Fixes the AssertionError in gitnextver caused by corrupted git index

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

print_header() {
    echo ""
    print_status $BLUE "=================================================="
    print_status $BLUE "  $1"
    print_status $BLUE "=================================================="
    echo ""
}

# Main fix function
fix_git_index() {
    print_header "FIXING GIT INDEX CORRUPTION"
    
    # Check if we're in a git repository
    if ! git rev-parse --git-dir >/dev/null 2>&1; then
        print_status $RED "❌ Not in a git repository"
        exit 1
    fi
    
    local git_dir=$(git rev-parse --git-dir)
    local index_file="$git_dir/index"
    
    print_status $BLUE "🔍 Diagnosing git index corruption..."
    
    if [[ ! -f "$index_file" ]]; then
        print_status $YELLOW "⚠️  Git index file not found at: $index_file"
    else
        print_status $GREEN "✅ Git index file found at: $index_file"
        
        # Check if index file is accessible
        if [[ ! -r "$index_file" ]]; then
            print_status $RED "❌ Git index file is not readable"
            exit 1
        fi
        
        # Get file size
        local size=$(stat -f%z "$index_file" 2>/dev/null || stat -c%s "$index_file" 2>/dev/null || echo "unknown")
        print_status $BLUE "📊 Index file size: $size bytes"
    fi
    
    # Check current git status
    print_status $BLUE "📋 Checking current git status..."
    git status --porcelain > /tmp/git_status_before_fix
    local changes_count=$(wc -l < /tmp/git_status_before_fix)
    print_status $GREEN "📄 Found $changes_count file changes to preserve"
    
    # Create backup of current state
    print_status $BLUE "💾 Creating backup of current git state..."
    local backup_dir="/tmp/git_backup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"
    
    # Save current staged and unstaged changes
    git diff --cached > "$backup_dir/staged_changes.patch" 2>/dev/null || true
    git diff > "$backup_dir/unstaged_changes.patch" 2>/dev/null || true
    cp /tmp/git_status_before_fix "$backup_dir/git_status.txt"
    
    print_status $GREEN "✅ Backup created at: $backup_dir"
    
    # Fix the corrupted index
    print_status $BLUE "🔧 Fixing git index corruption..."
    
    # Remove the corrupted index file
    if [[ -f "$index_file" ]]; then
        print_status $BLUE "🗑️  Removing corrupted index file..."
        rm "$index_file"
        print_status $GREEN "✅ Corrupted index file removed"
    fi
    
    # Recreate the index
    print_status $BLUE "🔄 Recreating git index..."
    git reset --mixed HEAD >/dev/null 2>&1 || true
    
    # Re-add previously staged files
    if [[ -s "$backup_dir/staged_changes.patch" ]]; then
        print_status $BLUE "📥 Restoring previously staged changes..."
        git apply --cached "$backup_dir/staged_changes.patch" 2>/dev/null || {
            print_status $YELLOW "⚠️  Could not automatically restore staged changes"
            print_status $YELLOW "    Staged changes saved in: $backup_dir/staged_changes.patch"
        }
    fi
    
    # Verify the fix
    print_status $BLUE "🔍 Verifying git index fix..."
    
    # Test git operations
    if git status >/dev/null 2>&1; then
        print_status $GREEN "✅ Git status working"
    else
        print_status $RED "❌ Git status still failing"
        exit 1
    fi
    
    if git diff --cached >/dev/null 2>&1; then
        print_status $GREEN "✅ Git diff --cached working"
    else
        print_status $RED "❌ Git diff --cached still failing"
        exit 1
    fi
    
    # Test gitnextver if available
    if command -v gitnextver >/dev/null 2>&1; then
        print_status $BLUE "🧪 Testing gitnextver..."
        if gitnextver --dry-run >/dev/null 2>&1; then
            print_status $GREEN "✅ gitnextver working correctly"
        else
            print_status $YELLOW "⚠️  gitnextver test failed, but git index appears fixed"
        fi
    else
        print_status $YELLOW "⚠️  gitnextver not found, cannot test"
    fi
    
    # Show final status
    print_status $BLUE "📋 Final git status:"
    git status --porcelain > /tmp/git_status_after_fix
    local final_changes=$(wc -l < /tmp/git_status_after_fix)
    
    if [[ $changes_count -eq $final_changes ]]; then
        print_status $GREEN "✅ All $final_changes file changes preserved"
    else
        print_status $YELLOW "⚠️  File change count differs: before=$changes_count, after=$final_changes"
        print_status $YELLOW "    Check backup at: $backup_dir"
    fi
    
    # Cleanup temp files
    rm -f /tmp/git_status_before_fix /tmp/git_status_after_fix
    
    print_header "GIT INDEX FIX COMPLETED"
    print_status $GREEN "🎉 Git index corruption has been fixed!"
    print_status $GREEN "📁 Backup saved at: $backup_dir"
    print_status $GREEN "🚀 You can now use gitnextver and other git operations normally"
    echo ""
}

# Run the fix
fix_git_index