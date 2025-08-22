#!/bin/bash
# this_file: build.sh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
PROJECT_NAME="twardoch-is-coding"
BUILD_DIR="docs"
SLIDES_SRC="src_slides"
DOCS_SRC="src_docs"
VERSION_FILE="VERSION"

# Build Resilience Configuration
BUILD_STATE_DIR=".build_state"
BUILD_LOCK_FILE="$BUILD_STATE_DIR/build.lock"
BUILD_STATE_FILE="$BUILD_STATE_DIR/build_state.json"
BUILD_BACKUP_DIR="$BUILD_STATE_DIR/backup"
BUILD_LOG_FILE="$BUILD_STATE_DIR/build.log"

# Function to print colored output
print_status() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

print_header() {
    echo ""
    print_status $CYAN "=================================================="
    print_status $CYAN "  $1"
    print_status $CYAN "=================================================="
    echo ""
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Build Resilience System Functions
# ==================================

# Initialize build state directory
init_build_state() {
    mkdir -p "$BUILD_STATE_DIR" "$BUILD_BACKUP_DIR"
    
    {
        echo "================================================================="
        echo "BUILD LOG: $PROJECT_NAME"
        echo "================================================================="
        echo "Start Time: $(date)"
        echo "PID: $$"
        echo "Working Directory: $(pwd)"
        echo ""
    } > "$BUILD_LOG_FILE"
}

# Log build events
log_build_event() {
    local event="$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $event" >> "$BUILD_LOG_FILE"
}

# Save build state with JSON format
save_build_state() {
    local stage="$1"
    local status="$2"
    local details="${3:-}"
    
    cat > "$BUILD_STATE_FILE" << EOF
{
    "timestamp": "$(date -Iseconds 2>/dev/null || date)",
    "stage": "$stage",
    "status": "$status",
    "pid": $$,
    "details": "$details",
    "build_mode": "${BUILD_MODE:-production}",
    "options": {
        "build_pdf": "${BUILD_PDF:-false}",
        "clean_build": "${CLEAN_BUILD:-false}",
        "dev_mode": "${DEV_MODE:-false}",
        "skip_optimize": "${SKIP_OPTIMIZE:-false}"
    }
}
EOF
    
    log_build_event "$stage: $status - $details"
}

# Check for existing build lock
check_build_lock() {
    if [[ -f "$BUILD_LOCK_FILE" ]]; then
        local lock_pid=$(cat "$BUILD_LOCK_FILE" 2>/dev/null || echo "unknown")
        
        if kill -0 "$lock_pid" 2>/dev/null; then
            print_status $RED "❌ Build already in progress (PID: $lock_pid)"
            print_status $YELLOW "   If this is incorrect, remove $BUILD_LOCK_FILE"
            return 1
        else
            print_status $YELLOW "⚠️  Found stale lock file, removing..."
            rm -f "$BUILD_LOCK_FILE"
        fi
    fi
    return 0
}

# Create build lock
create_build_lock() {
    echo $$ > "$BUILD_LOCK_FILE"
    save_build_state "lock_created" "success" "Build lock acquired"
    log_build_event "Build lock created (PID: $$)"
}

# Remove build lock
remove_build_lock() {
    if [[ -f "$BUILD_LOCK_FILE" ]]; then
        rm -f "$BUILD_LOCK_FILE"
        log_build_event "Build lock removed"
    fi
}

# Create backup before major operations
create_build_backup() {
    local backup_name="backup_$(date +%Y%m%d_%H%M%S)"
    local backup_path="$BUILD_BACKUP_DIR/$backup_name"
    
    if [[ -d "$BUILD_DIR" ]]; then
        print_status $BLUE "💾 Creating build backup..."
        cp -r "$BUILD_DIR" "$backup_path" 2>/dev/null || {
            print_status $YELLOW "⚠️  Failed to create backup, continuing..."
            return 1
        }
        
        # Keep only last 3 backups
        ls -t "$BUILD_BACKUP_DIR" 2>/dev/null | tail -n +4 | while read -r old_backup; do
            rm -rf "$BUILD_BACKUP_DIR/$old_backup" 2>/dev/null || true
        done
        
        save_build_state "backup_created" "success" "$backup_path"
        print_status $GREEN "✅ Backup created: $backup_path"
        echo "$backup_path"
    fi
}

# Handle build interruption
handle_interruption() {
    local signal="$1"
    
    print_status $YELLOW ""
    print_status $YELLOW "🛑 Build interrupted by signal: $signal"
    
    save_build_state "interrupted" "failure" "Signal $signal received"
    
    print_status $BLUE "🧹 Performing cleanup..."
    
    remove_build_lock
    
    print_status $YELLOW "📝 Build state saved to: $BUILD_STATE_FILE"
    print_status $YELLOW "📋 Build log available at: $BUILD_LOG_FILE"
    
    if [[ -d "$BUILD_BACKUP_DIR" ]]; then
        local backup_count=$(ls -1 "$BUILD_BACKUP_DIR" 2>/dev/null | wc -l)
        if [[ $backup_count -gt 0 ]]; then
            print_status $YELLOW "💾 $backup_count backup(s) available - Use './build.sh --recover'"
        fi
    fi
    
    print_status $RED "❌ Build terminated"
    exit 130
}

# Setup signal handlers
setup_signal_handlers() {
    trap 'handle_interruption SIGINT' INT
    trap 'handle_interruption SIGTERM' TERM
    trap 'handle_interruption SIGHUP' HUP
}

# Cleanup on exit
cleanup_on_exit() {
    local exit_code=$?
    
    if [[ $exit_code -eq 0 ]]; then
        save_build_state "completed" "success" "Build completed successfully"
        log_build_event "Build completed successfully (exit code: $exit_code)"
    else
        save_build_state "failed" "failure" "Build failed with exit code $exit_code"
        log_build_event "Build failed (exit code: $exit_code)"
        
        if [[ -d "$BUILD_BACKUP_DIR" ]]; then
            local backup_count=$(ls -1 "$BUILD_BACKUP_DIR" 2>/dev/null | wc -l)
            if [[ $backup_count -gt 0 ]]; then
                print_status $YELLOW "💾 Recovery option: './build.sh --recover'"
            fi
        fi
    fi
    
    remove_build_lock
    log_build_event "Build process ended (exit code: $exit_code)"
}

# Function to attempt recovery from previous failed build
recover_from_failure() {
    print_status $BLUE "🔧 Attempting build recovery..."
    
    if [[ ! -d "$BUILD_STATE_DIR" ]]; then
        print_status $RED "❌ No build state directory found"
        return 1
    fi
    
    # Check for previous build state
    if [[ -f "$BUILD_STATE_FILE" ]]; then
        local last_stage=$(grep '"stage"' "$BUILD_STATE_FILE" 2>/dev/null | cut -d'"' -f4)
        local last_status=$(grep '"status"' "$BUILD_STATE_FILE" 2>/dev/null | cut -d'"' -f4)
        
        print_status $BLUE "📋 Last build: $last_stage ($last_status)"
        
        if [[ "$last_status" == "failure" ]] || [[ "$last_status" == "interrupted" ]]; then
            # Find latest backup
            local latest_backup=$(ls -t "$BUILD_BACKUP_DIR" 2>/dev/null | head -n1)
            
            if [[ -n "$latest_backup" ]]; then
                print_status $BLUE "🔄 Found backup: $latest_backup"
                
                # Restore from backup
                print_status $BLUE "🔄 Restoring from backup: $latest_backup"
                rm -rf "$BUILD_DIR" 2>/dev/null || true
                cp -r "$BUILD_BACKUP_DIR/$latest_backup" "$BUILD_DIR" 2>/dev/null || {
                    print_status $RED "❌ Failed to restore from backup"
                    return 1
                }
                
                save_build_state "recovery_completed" "success" "Restored from backup: $latest_backup"
                print_status $GREEN "✅ Successfully recovered from backup"
                return 0
            else
                print_status $YELLOW "⚠️  No backup available for recovery"
            fi
        else
            print_status $GREEN "✅ Previous build completed successfully, no recovery needed"
            return 0
        fi
    else
        print_status $YELLOW "⚠️  No previous build state found"
    fi
    
    return 1
}

# Enhanced Build Resilience Functions
# =====================================

# Create enhanced build checkpoint with stage verification
create_build_checkpoint() {
    local stage="$1"
    local checkpoint_name="checkpoint_${stage}_$(date +%Y%m%d_%H%M%S)"
    local checkpoint_path="$BUILD_STATE_DIR/checkpoints/$checkpoint_name"
    
    mkdir -p "$BUILD_STATE_DIR/checkpoints"
    
    # Save stage-specific state information
    cat > "$checkpoint_path.json" << EOF
{
    "timestamp": "$(date -Iseconds 2>/dev/null || date)",
    "stage": "$stage",
    "pid": $$,
    "build_mode": "${BUILD_MODE:-production}",
    "files_created": [],
    "directories_created": [],
    "stage_duration": 0,
    "integrity_hash": "$(find ${BUILD_DIR} -type f -exec md5sum {} \; 2>/dev/null | md5sum | cut -d' ' -f1 2>/dev/null || echo 'unavailable')"
}
EOF
    
    # Create snapshot of current build state
    if [[ -d "$BUILD_DIR" ]]; then
        cp -r "$BUILD_DIR" "$checkpoint_path" 2>/dev/null || {
            print_status $YELLOW "⚠️  Failed to create checkpoint snapshot"
            return 1
        }
    fi
    
    log_build_event "Checkpoint created: $stage at $checkpoint_path"
    echo "$checkpoint_path"
}

# Verify build integrity
verify_build_integrity() {
    local expected_files=(
        "$BUILD_DIR/index.html"
        "$BUILD_DIR/slides.html"
    )
    
    print_status $BLUE "🔍 Verifying build integrity..."
    
    for file in "${expected_files[@]}"; do
        if [[ ! -f "$file" ]]; then
            print_status $RED "❌ Missing expected file: $file"
            return 1
        fi
        
        # Check file is not empty
        if [[ ! -s "$file" ]]; then
            print_status $RED "❌ Empty file detected: $file"
            return 1
        fi
        
        # Basic HTML validation for HTML files
        if [[ "$file" == *.html ]]; then
            if ! grep -q "<!DOCTYPE\|<html" "$file" 2>/dev/null; then
                print_status $RED "❌ Invalid HTML file: $file"
                return 1
            fi
        fi
    done
    
    # Check for build artifacts corruption
    if command_exists find && command_exists wc; then
        local total_files=$(find "$BUILD_DIR" -type f | wc -l)
        if [[ $total_files -lt 5 ]]; then
            print_status $YELLOW "⚠️  Unexpectedly few files in build output ($total_files)"
            return 1
        fi
    fi
    
    print_status $GREEN "✅ Build integrity verification passed"
    return 0
}

# Resume build from last successful checkpoint
resume_build_from_checkpoint() {
    local target_stage="$1"
    
    print_status $BLUE "🔄 Attempting to resume build from checkpoint..."
    
    if [[ ! -d "$BUILD_STATE_DIR/checkpoints" ]]; then
        print_status $YELLOW "⚠️  No checkpoints available"
        return 1
    fi
    
    # Find latest checkpoint for the target stage or before
    local latest_checkpoint=$(find "$BUILD_STATE_DIR/checkpoints" -name "checkpoint_*.json" -type f | sort -r | head -n1)
    
    if [[ -z "$latest_checkpoint" ]]; then
        print_status $YELLOW "⚠️  No suitable checkpoint found"
        return 1
    fi
    
    local checkpoint_stage=$(grep '"stage"' "$latest_checkpoint" 2>/dev/null | cut -d'"' -f4)
    local checkpoint_dir="${latest_checkpoint%.json}"
    
    print_status $BLUE "📂 Found checkpoint for stage: $checkpoint_stage"
    
    if [[ -d "$checkpoint_dir" ]]; then
        # Verify checkpoint integrity before using
        if verify_checkpoint_integrity "$checkpoint_dir"; then
            print_status $BLUE "🔄 Restoring from checkpoint: $checkpoint_stage"
            rm -rf "$BUILD_DIR" 2>/dev/null || true
            cp -r "$checkpoint_dir" "$BUILD_DIR" 2>/dev/null || {
                print_status $RED "❌ Failed to restore from checkpoint"
                return 1
            }
            
            save_build_state "checkpoint_restored" "success" "Resumed from checkpoint: $checkpoint_stage"
            print_status $GREEN "✅ Successfully resumed from checkpoint: $checkpoint_stage"
            return 0
        else
            print_status $RED "❌ Checkpoint integrity verification failed"
            return 1
        fi
    else
        print_status $RED "❌ Checkpoint directory not found: $checkpoint_dir"
        return 1
    fi
}

# Verify checkpoint integrity
verify_checkpoint_integrity() {
    local checkpoint_dir="$1"
    
    if [[ ! -d "$checkpoint_dir" ]]; then
        return 1
    fi
    
    # Check if checkpoint has expected structure
    if [[ ! -f "$checkpoint_dir/index.html" ]] && [[ ! -f "$checkpoint_dir/slides.html" ]]; then
        return 1
    fi
    
    # Verify no corrupted files (basic check)
    find "$checkpoint_dir" -type f -size 0 | grep -q . && return 1
    
    return 0
}

# Enhanced backup verification
verify_backup_integrity() {
    local backup_path="$1"
    
    if [[ ! -d "$backup_path" ]]; then
        return 1
    fi
    
    print_status $BLUE "🔍 Verifying backup integrity..."
    
    # Check backup has content
    local file_count=$(find "$backup_path" -type f | wc -l)
    if [[ $file_count -lt 3 ]]; then
        print_status $RED "❌ Backup appears incomplete (only $file_count files)"
        return 1
    fi
    
    # Verify key files exist
    if [[ ! -f "$backup_path/index.html" ]]; then
        print_status $RED "❌ Backup missing critical file: index.html"
        return 1
    fi
    
    # Check for file corruption (empty files)
    if find "$backup_path" -type f -size 0 | grep -q .; then
        print_status $RED "❌ Backup contains corrupted (empty) files"
        return 1
    fi
    
    print_status $GREEN "✅ Backup integrity verified"
    return 0
}

# Build health monitoring and performance tracking
monitor_build_health() {
    local stage="$1"
    local start_time="$2"
    local end_time="${3:-$(date +%s)}"
    local duration=$((end_time - start_time))
    
    # Store performance data
    local health_file="$BUILD_STATE_DIR/build_health.json"
    
    # Initialize health file if it doesn't exist
    if [[ ! -f "$health_file" ]]; then
        cat > "$health_file" << EOF
{
    "build_history": [],
    "average_times": {},
    "performance_trend": "stable"
}
EOF
    fi
    
    # Add current stage performance
    local temp_file=$(mktemp)
    cat "$health_file" | sed "s/\"build_history\": \[\]/\"build_history\": [{\"stage\": \"$stage\", \"duration\": $duration, \"timestamp\": \"$(date -Iseconds 2>/dev/null || date)\"}]/" > "$temp_file"
    mv "$temp_file" "$health_file"
    
    # Detect performance degradation
    if [[ $duration -gt 120 ]]; then  # Stage taking more than 2 minutes
        print_status $YELLOW "⚠️  Performance warning: $stage took ${duration}s (>2min)"
        log_build_event "Performance warning: $stage duration ${duration}s"
    fi
    
    # Memory usage check if available
    if command_exists free; then
        local mem_usage=$(free | awk 'NR==2{printf "%.1f", $3*100/$2 }')
        if (( $(echo "$mem_usage > 90" | bc -l 2>/dev/null || echo 0) )); then
            print_status $YELLOW "⚠️  High memory usage: ${mem_usage}%"
        fi
    fi
}

# Automatic corruption detection and repair
detect_and_repair_corruption() {
    print_status $BLUE "🔍 Checking for build corruption..."
    
    # Check if build directory exists
    if [[ ! -d "$BUILD_DIR" ]]; then
        print_status $YELLOW "📁 Build directory missing, will be recreated"
        return 1
    fi
    
    # Verify build integrity
    if ! verify_build_integrity; then
        print_status $YELLOW "🔧 Build corruption detected, attempting repair..."
        
        # Try to restore from latest backup
        local latest_backup=$(ls -t "$BUILD_BACKUP_DIR" 2>/dev/null | head -n1)
        
        if [[ -n "$latest_backup" ]] && verify_backup_integrity "$BUILD_BACKUP_DIR/$latest_backup"; then
            print_status $BLUE "🔄 Restoring from backup: $latest_backup"
            rm -rf "$BUILD_DIR" 2>/dev/null || true
            cp -r "$BUILD_BACKUP_DIR/$latest_backup" "$BUILD_DIR" 2>/dev/null || {
                print_status $RED "❌ Failed to restore from backup"
                return 1
            }
            
            if verify_build_integrity; then
                print_status $GREEN "✅ Successfully repaired corruption from backup"
                save_build_state "corruption_repaired" "success" "Restored from backup: $latest_backup"
                return 0
            fi
        fi
        
        # Try to restore from checkpoint
        if resume_build_from_checkpoint ""; then
            if verify_build_integrity; then
                print_status $GREEN "✅ Successfully repaired corruption from checkpoint"
                return 0
            fi
        fi
        
        print_status $RED "❌ Unable to repair corruption automatically"
        return 1
    fi
    
    print_status $GREEN "✅ No corruption detected"
    return 0
}

# Advanced failure recovery with smart retry logic
smart_retry_build() {
    local max_retries=3
    local retry_count=0
    local backoff_delay=5
    
    while [[ $retry_count -lt $max_retries ]]; do
        print_status $BLUE "🔄 Build attempt $((retry_count + 1)) of $max_retries"
        
        # Attempt build with corruption detection
        if detect_and_repair_corruption; then
            return 0
        fi
        
        retry_count=$((retry_count + 1))
        
        if [[ $retry_count -lt $max_retries ]]; then
            print_status $YELLOW "⏱️  Waiting ${backoff_delay}s before retry..."
            sleep $backoff_delay
            backoff_delay=$((backoff_delay * 2))  # Exponential backoff
            
            # Clear corrupted build directory for retry
            rm -rf "$BUILD_DIR" 2>/dev/null || true
        fi
    done
    
    print_status $RED "❌ Build failed after $max_retries attempts"
    return 1
}

# Enhanced backup verification with content checks
verify_backup_integrity_enhanced() {
    local backup_dir="$1"
    
    if [[ ! -d "$backup_dir" ]]; then
        return 1
    fi
    
    # Check essential files exist
    local essential_files=("index.html" "slides.html")
    for file in "${essential_files[@]}"; do
        if [[ ! -f "$backup_dir/$file" ]]; then
            return 1
        fi
        
        # Check file is not empty
        if [[ ! -s "$backup_dir/$file" ]]; then
            return 1
        fi
        
        # Check file contains expected content
        if [[ "$file" == *.html ]]; then
            if ! grep -q "<!DOCTYPE\|<html" "$backup_dir/$file" 2>/dev/null; then
                return 1
            fi
        fi
    done
    
    # Check total file count is reasonable
    local file_count=$(find "$backup_dir" -type f | wc -l)
    if [[ $file_count -lt 5 ]]; then
        return 1
    fi
    
    return 0
}

# System resource monitoring
monitor_system_resources() {
    local warn_disk_threshold=90
    local warn_memory_threshold=80
    
    # Check disk space
    if command_exists df; then
        local disk_usage=$(df . | awk 'NR==2 {print $5}' | sed 's/%//')
        if [[ $disk_usage -gt $warn_disk_threshold ]]; then
            print_status $YELLOW "⚠️  Warning: Disk usage is ${disk_usage}% (threshold: ${warn_disk_threshold}%)"
            log_build_event "WARNING: High disk usage: ${disk_usage}%"
        fi
    fi
    
    # Check memory usage (Linux/macOS)
    if command_exists free; then
        local mem_usage=$(free | awk 'NR==2{printf "%.0f", $3*100/($3+$7)}')
        if [[ $mem_usage -gt $warn_memory_threshold ]]; then
            print_status $YELLOW "⚠️  Warning: Memory usage is ${mem_usage}% (threshold: ${warn_memory_threshold}%)"
            log_build_event "WARNING: High memory usage: ${mem_usage}%"
        fi
    elif command_exists vm_stat; then  # macOS alternative
        local mem_pressure=$(vm_stat | awk '/Pages free/ {free=$3} /Pages active/ {active=$3} /Pages inactive/ {inactive=$3} END {print int((active+inactive)*100/(free+active+inactive))}')
        if [[ $mem_pressure -gt $warn_memory_threshold ]]; then
            print_status $YELLOW "⚠️  Warning: Memory pressure is high (${mem_pressure}%)"
            log_build_event "WARNING: High memory pressure: ${mem_pressure}%"
        fi
    fi
}

# Function to run gitnextver if available
update_version() {
    if command_exists gitnextver; then
        print_status $BLUE "📝 Updating version with gitnextver..."
        gitnextver .
        if [[ $? -eq 0 ]]; then
            print_status $GREEN "✅ Version updated successfully"
        else
            print_status $YELLOW "⚠️  Version update failed, continuing..."
        fi
    else
        print_status $YELLOW "⚠️  gitnextver not found, skipping version update"
        # Create a basic version file if it doesn't exist
        if [[ ! -f $VERSION_FILE ]]; then
            echo "1.0.0" > $VERSION_FILE
            print_status $BLUE "📄 Created basic VERSION file"
        fi
    fi
}

# Function to clean build directory
clean_build() {
    print_status $BLUE "🧹 Cleaning build directory..."
    
    # Remove generated files but keep .git if it exists
    if [[ -d "$BUILD_DIR" ]]; then
        find "$BUILD_DIR" -type f \( -name "*.html" -o -name "*.css" -o -name "*.js" -o -name "*.png" -o -name "*.jpg" -o -name "*.svg" -o -name "*.json" -o -name "*.xml" -o -name "*.gz" \) -delete 2>/dev/null || true
        find "$BUILD_DIR" -type d -empty -delete 2>/dev/null || true
        print_status $GREEN "✅ Build directory cleaned"
    else
        mkdir -p "$BUILD_DIR"
        print_status $GREEN "✅ Build directory created"
    fi
}

# Function to validate build environment
validate_environment() {
    print_status $BLUE "🌍 Validating build environment..."
    
    # Check shell compatibility
    if [[ -z "$BASH_VERSION" ]]; then
        print_status $RED "❌ This script requires Bash shell"
        exit 1
    fi
    
    # Enhanced cross-platform OS detection and compatibility
    detect_platform() {
        case "$(uname -s)" in
            Linux*)
                PLATFORM="linux"
                PLATFORM_NAME="Linux"
                ;;
            Darwin*)
                PLATFORM="macos"
                PLATFORM_NAME="macOS"
                ;;
            CYGWIN*|MINGW*|MSYS*)
                PLATFORM="windows"
                PLATFORM_NAME="Windows (Git Bash/MSYS2)"
                ;;
            *)
                PLATFORM="unknown"
                PLATFORM_NAME="Unknown ($(uname -s))"
                ;;
        esac
    }
    
    detect_platform
    
    case "$PLATFORM" in
        linux|macos)
            print_status $GREEN "✅ Operating system supported: $PLATFORM_NAME"
            ;;
        windows)
            print_status $YELLOW "⚠️  $PLATFORM_NAME detected - enabling Windows compatibility mode"
            # Set Windows-specific configurations
            export MSYS_NO_PATHCONV=1  # Prevent path conversion issues
            export MSYS2_ARG_CONV_EXCL="*"
            ;;
        *)
            print_status $YELLOW "⚠️  $PLATFORM_NAME - attempting compatibility mode"
            ;;
    esac
    
    # Check available disk space (require at least 100MB)
    if command_exists df; then
        AVAILABLE_SPACE=$(df . | awk 'NR==2 {print $4}')
        if [[ $AVAILABLE_SPACE -lt 102400 ]]; then  # 100MB in KB
            print_status $RED "❌ Insufficient disk space. Available: $(($AVAILABLE_SPACE/1024))MB, Required: 100MB"
            exit 1
        fi
        print_status $GREEN "✅ Sufficient disk space available: $(($AVAILABLE_SPACE/1024))MB"
    fi
    
    # Check write permissions
    if [[ ! -w "." ]]; then
        print_status $RED "❌ No write permission in current directory"
        exit 1
    fi
    
    # Test temporary file creation
    TEMP_FILE=".build_test_$$"
    if ! touch "$TEMP_FILE" 2>/dev/null; then
        print_status $RED "❌ Cannot create temporary files"
        exit 1
    fi
    rm -f "$TEMP_FILE"
    
    print_status $GREEN "✅ Build environment validation passed"
}

# Function to validate file system structure
validate_file_structure() {
    print_status $BLUE "📁 Validating project file structure..."
    
    local required_files=(
        "package.json"
        "$SLIDES_SRC/slides.md"
        "$DOCS_SRC/mkdocs.yml"
    )
    
    local required_dirs=(
        "$SLIDES_SRC"
        "$DOCS_SRC"
        "$DOCS_SRC/docs"
    )
    
    # Check required directories
    for dir in "${required_dirs[@]}"; do
        if [[ ! -d "$dir" ]]; then
            print_status $RED "❌ Required directory missing: $dir"
            exit 1
        fi
    done
    
    # Check required files
    for file in "${required_files[@]}"; do
        if [[ ! -f "$file" ]]; then
            print_status $RED "❌ Required file missing: $file"
            exit 1
        fi
        
        # Check file is readable
        if [[ ! -r "$file" ]]; then
            print_status $RED "❌ Cannot read required file: $file"
            exit 1
        fi
    done
    
    # Validate package.json syntax
    if ! node -e "JSON.parse(require('fs').readFileSync('package.json'))" 2>/dev/null; then
        print_status $RED "❌ Invalid package.json syntax"
        exit 1
    fi
    
    # Check slide file content
    if [[ ! -s "$SLIDES_SRC/slides.md" ]]; then
        print_status $RED "❌ Slide source file is empty: $SLIDES_SRC/slides.md"
        exit 1
    fi
    
    # Validate MkDocs configuration syntax
    if command_exists mkdocs && [[ -f "$DOCS_SRC/mkdocs.yml" ]]; then
        cd "$DOCS_SRC"
        if ! mkdocs build --config-file mkdocs.yml --site-dir "/tmp/mkdocs_test_$$" --quiet 2>/dev/null; then
            cd ..
            print_status $YELLOW "⚠️  MkDocs configuration may have issues"
        else
            rm -rf "/tmp/mkdocs_test_$$" 2>/dev/null
            cd ..
        fi
    fi
    
    print_status $GREEN "✅ File structure validation passed"
}

# Function to validate dependencies and versions with enhanced checks
check_prerequisites() {
    print_status $BLUE "📋 Checking build prerequisites..."
    
    local missing_deps=()
    local version_warnings=()
    local security_warnings=()
    
    # Essential dependencies with enhanced validation
    if ! command_exists npm; then
        missing_deps+=("npm")
    else
        NPM_VERSION=$(npm --version)
        NPM_MAJOR=$(echo $NPM_VERSION | cut -d'.' -f1)
        if [[ $NPM_MAJOR -lt 7 ]]; then
            version_warnings+=("npm $NPM_VERSION (recommend 7+)")
        else
            print_status $GREEN "✅ npm: $NPM_VERSION"
        fi
        
        # Check for npm vulnerabilities if package-lock.json exists
        if [[ -f "package-lock.json" ]]; then
            NPM_AUDIT_OUTPUT=$(npm audit --audit-level high --json 2>/dev/null || echo '{}')
            NPM_VULNS=$(echo "$NPM_AUDIT_OUTPUT" | node -pe 'try { JSON.parse(require("fs").readFileSync("/dev/stdin")).metadata.vulnerabilities.high || 0 } catch(e) { 0 }' 2>/dev/null)
            if [[ "$NPM_VULNS" -gt 0 ]] 2>/dev/null; then
                security_warnings+=("$NPM_VULNS high-severity npm vulnerabilities found")
            fi
        fi
    fi
    
    if ! command_exists node; then
        missing_deps+=("node")
    else
        NODE_VERSION_FULL=$(node --version)
        NODE_VERSION=$(echo $NODE_VERSION_FULL | cut -d'v' -f2 | cut -d'.' -f1)
        if [[ $NODE_VERSION -lt 16 ]]; then
            version_warnings+=("Node.js $NODE_VERSION_FULL (recommend 16+)")
        else
            print_status $GREEN "✅ Node.js: $NODE_VERSION_FULL"
        fi
        
        # Check Node.js memory limit for large builds
        NODE_MEMORY=$(node -p 'Math.floor(v8.getHeapStatistics().heap_size_limit / 1024 / 1024)' 2>/dev/null || echo "0")
        if [[ "$NODE_MEMORY" -lt 1000 ]] && [[ "$NODE_MEMORY" -gt 0 ]]; then
            version_warnings+=("Node.js memory limit may be low: ${NODE_MEMORY}MB")
        fi
    fi
    
    # Git with enhanced validation
    if ! command_exists git; then
        print_status $YELLOW "⚠️  Git not found - version management limited"
    else
        GIT_VERSION=$(git --version | awk '{print $3}')
        print_status $GREEN "✅ Git: $GIT_VERSION"
        
        # Check git configuration
        if ! git config user.name >/dev/null 2>&1; then
            version_warnings+=("Git user.name not configured")
        fi
        if ! git config user.email >/dev/null 2>&1; then
            version_warnings+=("Git user.email not configured")  
        fi
        
        # Check if we're in a git repository
        if git rev-parse --git-dir >/dev/null 2>&1; then
            # Check for uncommitted changes in production builds
            if [[ "$BUILD_MODE" == "production" ]] && ! git diff-index --quiet HEAD -- 2>/dev/null; then
                version_warnings+=("Uncommitted changes detected in production build")
            fi
        fi
    fi
    
    # Enhanced MkDocs validation
    if ! command_exists mkdocs; then
        print_status $YELLOW "⚠️  MkDocs not found - documentation build will be limited"
        SKIP_DOCS=true
    else
        MKDOCS_VERSION=$(mkdocs --version 2>/dev/null | head -n1)
        SKIP_DOCS=false
        print_status $GREEN "✅ MkDocs: $MKDOCS_VERSION"
        
        # Validate MkDocs plugins (basic check)
        if [[ -f "$DOCS_SRC/mkdocs.yml" ]]; then
            if grep -q "plugins:" "$DOCS_SRC/mkdocs.yml"; then
                PLUGIN_COUNT=$(grep -A 10 "plugins:" "$DOCS_SRC/mkdocs.yml" | grep -c "^  - " || echo "0")
                print_status $GREEN "   📦 MkDocs plugins configured: $PLUGIN_COUNT"
            fi
        fi
    fi
    
    # Enhanced Python validation
    if [[ "$SKIP_DOCS" == "false" ]]; then
        if ! command_exists python && ! command_exists python3; then
            print_status $YELLOW "⚠️  Python not found - some MkDocs features may be limited"
        else
            PYTHON_CMD=$(command_exists python3 && echo "python3" || echo "python")
            PYTHON_VERSION=$($PYTHON_CMD --version 2>&1 | awk '{print $2}')
            PYTHON_MAJOR=$(echo $PYTHON_VERSION | cut -d'.' -f1)
            PYTHON_MINOR=$(echo $PYTHON_VERSION | cut -d'.' -f2)
            
            if [[ $PYTHON_MAJOR -lt 3 ]] || [[ $PYTHON_MAJOR -eq 3 && $PYTHON_MINOR -lt 8 ]]; then
                version_warnings+=("Python $PYTHON_VERSION (recommend 3.8+)")
            else
                print_status $GREEN "✅ Python: $PYTHON_VERSION"
            fi
            
            # Check for pip
            if ! command_exists pip && ! command_exists pip3; then
                version_warnings+=("pip not found - Python package installation may fail")
            fi
        fi
    fi
    
    # Check for additional quality tools
    quality_tools_found=0
    optional_tools=("htmlproofer" "linkchecker" "pa11y" "lighthouse")
    for tool in "${optional_tools[@]}"; do
        if command_exists "$tool"; then
            print_status $GREEN "✅ $tool available for quality checks"
            ((quality_tools_found++))
        fi
    done
    
    if [[ $quality_tools_found -eq 0 ]]; then
        print_status $YELLOW "⚠️  No quality assurance tools found (optional)"
    fi
    
    # Check for performance tools
    if command_exists hyperfine; then
        print_status $GREEN "✅ hyperfine available for build performance measurement"
    fi
    
    # Check for optional tools
    if command_exists gitnextver; then
        print_status $GREEN "✅ gitnextver available for version management"
    else
        print_status $YELLOW "⚠️  gitnextver not found - using manual versioning"
    fi
    
    # Report missing dependencies
    if [[ ${#missing_deps[@]} -ne 0 ]]; then
        print_status $RED "❌ Missing required dependencies: ${missing_deps[*]}"
        print_status $RED "Please install the missing dependencies and try again"
        exit 1
    fi
    
    # Report version warnings
    if [[ ${#version_warnings[@]} -ne 0 ]]; then
        print_status $YELLOW "⚠️  Version warnings:"
        for warning in "${version_warnings[@]}"; do
            print_status $YELLOW "   - $warning"
        done
    fi
    
    # Report security warnings
    if [[ ${#security_warnings[@]} -ne 0 ]]; then
        print_status $YELLOW "🔒 Security warnings:"
        for warning in "${security_warnings[@]}"; do
            print_status $YELLOW "   - $warning"
        done
    fi
    
    print_status $GREEN "✅ Prerequisites check passed"
}

# Function to validate network connectivity (for dependency downloads)
check_network_connectivity() {
    if [[ "$SKIP_DEPS" == "true" ]]; then
        return 0
    fi
    
    print_status $BLUE "🌐 Checking network connectivity..."
    
    # Check if we can reach npm registry
    if command_exists curl; then
        if curl -s --max-time 10 https://registry.npmjs.org/ >/dev/null 2>&1; then
            print_status $GREEN "✅ NPM registry accessible"
        else
            print_status $YELLOW "⚠️  NPM registry not accessible - dependency installation may fail"
        fi
    elif command_exists wget; then
        if wget -q --timeout=10 --spider https://registry.npmjs.org/ 2>/dev/null; then
            print_status $GREEN "✅ NPM registry accessible"
        else
            print_status $YELLOW "⚠️  NPM registry not accessible - dependency installation may fail"
        fi
    else
        print_status $YELLOW "⚠️  Cannot test network connectivity (curl/wget not found)"
    fi
    
    # Check PyPI if we need Python packages
    if [[ "$SKIP_DOCS" == "false" ]] && command_exists curl; then
        if curl -s --max-time 10 https://pypi.org/ >/dev/null 2>&1; then
            print_status $GREEN "✅ PyPI accessible"
        else
            print_status $YELLOW "⚠️  PyPI not accessible - Python package installation may fail"
        fi
    fi
}

# Function to install/update dependencies
install_dependencies() {
    print_status $BLUE "📦 Installing/updating dependencies..."
    
    if [[ -f package.json ]]; then
        if [[ -f package-lock.json ]] && [[ -d node_modules ]]; then
            npm ci --silent
        else
            npm install --silent
        fi
        print_status $GREEN "✅ Node.js dependencies installed"
    else
        print_status $RED "❌ package.json not found"
        exit 1
    fi
    
    # Install Python dependencies if MkDocs is available
    if [[ "$SKIP_DOCS" == "false" ]]; then
        print_status $BLUE "📚 Checking MkDocs dependencies..."
        
        # Try to install required packages
        pip_packages=("mkdocs" "mkdocs-material" "mkdocstrings" "pymdown-extensions")
        for package in "${pip_packages[@]}"; do
            if ! python -c "import $package" 2>/dev/null; then
                print_status $YELLOW "⚠️  Installing $package..."
                pip install "$package" --quiet || print_status $YELLOW "⚠️  Failed to install $package"
            fi
        done
    fi
}

# Function to build slides
build_slides() {
    print_status $BLUE "🎨 Building presentation slides..."
    
    if [[ ! -f "$SLIDES_SRC/slides.md" ]]; then
        print_status $RED "❌ Slide source file not found: $SLIDES_SRC/slides.md"
        exit 1
    fi
    
    # Build HTML slides
    npm run build-slides
    
    if [[ $? -eq 0 ]]; then
        print_status $GREEN "✅ HTML slides built successfully"
        
        # Check if slides file was created
        if [[ -f "$BUILD_DIR/slides.html" ]]; then
            SIZE=$(du -h "$BUILD_DIR/slides.html" | cut -f1)
            print_status $GREEN "   📄 Slides: $BUILD_DIR/slides.html ($SIZE)"
        fi
    else
        print_status $RED "❌ Slide build failed"
        exit 1
    fi
    
    # Build PDF slides if requested
    if [[ "$BUILD_PDF" == "true" ]]; then
        print_status $BLUE "📄 Building PDF slides..."
        npm run build-slides-pdf
        
        if [[ $? -eq 0 ]] && [[ -f "$BUILD_DIR/slides.pdf" ]]; then
            SIZE=$(du -h "$BUILD_DIR/slides.pdf" | cut -f1)
            print_status $GREEN "✅ PDF slides built: $BUILD_DIR/slides.pdf ($SIZE)"
        else
            print_status $YELLOW "⚠️  PDF slide build failed or skipped"
        fi
    fi
}

# Function to build documentation
build_documentation() {
    if [[ "$SKIP_DOCS" == "true" ]]; then
        print_status $YELLOW "⚠️  Skipping documentation build (MkDocs not available)"
        return 0
    fi
    
    print_status $BLUE "📚 Building documentation..."
    
    if [[ ! -f "$DOCS_SRC/mkdocs.yml" ]]; then
        print_status $RED "❌ MkDocs configuration not found: $DOCS_SRC/mkdocs.yml"
        exit 1
    fi
    
    # Build documentation
    cd "$DOCS_SRC"
    mkdocs build --config-file mkdocs.yml --site-dir "../$BUILD_DIR" --quiet
    
    if [[ $? -eq 0 ]]; then
        cd ..
        print_status $GREEN "✅ Documentation built successfully"
        
        # Check if index was created
        if [[ -f "$BUILD_DIR/index.html" ]]; then
            print_status $GREEN "   📄 Documentation: $BUILD_DIR/index.html"
        fi
        
        # Report on documentation size
        DOCS_SIZE=$(du -sh "$BUILD_DIR" 2>/dev/null | cut -f1)
        print_status $GREEN "   📊 Total documentation size: $DOCS_SIZE"
    else
        cd ..
        print_status $RED "❌ Documentation build failed"
        exit 1
    fi
}

# Function to run content quality assurance checks
run_content_quality_checks() {
    print_status $BLUE "🔍 Running content quality assurance..."
    
    local quality_issues=()
    
    # Check for broken internal links in HTML files
    if [[ -d "$BUILD_DIR" ]]; then
        print_status $BLUE "🔗 Checking internal links..."
        
        local broken_links=0
        for html_file in $(find "$BUILD_DIR" -name "*.html" -type f 2>/dev/null); do
            if [[ -f "$html_file" ]]; then
                # Extract href attributes and check if referenced files exist
                local links=$(grep -o 'href="[^"]*"' "$html_file" 2>/dev/null | sed 's/href="//;s/"//' | grep -v "^http" | grep -v "^#" | grep -v "^mailto:")
                
                for link in $links; do
                    # Convert relative links to absolute paths
                    local link_path="$BUILD_DIR/$link"
                    if [[ "$link" == "/"* ]]; then
                        link_path="$BUILD_DIR$link"
                    fi
                    
                    # Check if file exists (remove fragment identifiers)
                    local clean_path=$(echo "$link_path" | cut -d'#' -f1)
                    if [[ -n "$clean_path" ]] && [[ ! -f "$clean_path" ]] && [[ ! -d "$clean_path" ]]; then
                        quality_issues+=("Broken internal link: $link in $(basename "$html_file")")
                        ((broken_links++))
                    fi
                done
            fi
        done
        
        if [[ $broken_links -eq 0 ]]; then
            print_status $GREEN "✅ No broken internal links found"
        else
            print_status $YELLOW "⚠️  Found $broken_links potentially broken internal links"
        fi
    fi
    
    # Check for missing alt attributes on images
    if [[ -d "$BUILD_DIR" ]]; then
        print_status $BLUE "🖼️  Checking image accessibility..."
        
        local missing_alt=0
        for html_file in $(find "$BUILD_DIR" -name "*.html" -type f 2>/dev/null); do
            if [[ -f "$html_file" ]]; then
                # Count images without alt attributes
                local img_without_alt=$(grep -o '<img[^>]*>' "$html_file" 2>/dev/null | grep -v 'alt=' | wc -l)
                if [[ $img_without_alt -gt 0 ]]; then
                    quality_issues+=("Images without alt text: $img_without_alt in $(basename "$html_file")")
                    ((missing_alt += img_without_alt))
                fi
            fi
        done
        
        if [[ $missing_alt -eq 0 ]]; then
            print_status $GREEN "✅ All images have alt attributes"
        else
            print_status $YELLOW "⚠️  Found $missing_alt images without alt attributes"
        fi
    fi
    
    # Validate HTML syntax with basic checks
    if [[ -d "$BUILD_DIR" ]]; then
        print_status $BLUE "📄 Checking HTML validity..."
        
        local html_errors=0
        for html_file in $(find "$BUILD_DIR" -name "*.html" -type f 2>/dev/null); do
            if [[ -f "$html_file" ]]; then
                # Basic HTML validation checks
                if ! grep -q "<!DOCTYPE" "$html_file"; then
                    quality_issues+=("Missing DOCTYPE declaration in $(basename "$html_file")")
                    ((html_errors++))
                fi
                
                if ! grep -q "</html>" "$html_file"; then
                    quality_issues+=("Missing closing html tag in $(basename "$html_file")")
                    ((html_errors++))
                fi
                
                # Check for unclosed tags (basic check)
                local open_divs=$(grep -o "<div" "$html_file" 2>/dev/null | wc -l)
                local close_divs=$(grep -o "</div>" "$html_file" 2>/dev/null | wc -l)
                if [[ $open_divs -ne $close_divs ]]; then
                    quality_issues+=("Potentially mismatched div tags in $(basename "$html_file")")
                    ((html_errors++))
                fi
            fi
        done
        
        if [[ $html_errors -eq 0 ]]; then
            print_status $GREEN "✅ Basic HTML validation passed"
        else
            print_status $YELLOW "⚠️  Found $html_errors potential HTML issues"
        fi
    fi
    
    # Check for large file sizes
    if [[ -d "$BUILD_DIR" ]]; then
        print_status $BLUE "📊 Checking file sizes..."
        
        local large_files=0
        while IFS= read -r -d '' file; do
            if [[ -f "$file" ]]; then
                local size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null || echo "0")
                if [[ $size -gt 5242880 ]]; then  # 5MB
                    local size_mb=$((size / 1048576))
                    quality_issues+=("Large file detected: $(basename "$file") (${size_mb}MB)")
                    ((large_files++))
                fi
            fi
        done < <(find "$BUILD_DIR" -type f -print0 2>/dev/null)
        
        if [[ $large_files -eq 0 ]]; then
            print_status $GREEN "✅ No excessively large files found"
        else
            print_status $YELLOW "⚠️  Found $large_files files larger than 5MB"
        fi
    fi
    
    # Check content consistency
    if [[ -f "$BUILD_DIR/slides.html" ]] && [[ -f "$BUILD_DIR/index.html" ]]; then
        print_status $BLUE "📝 Checking content consistency..."
        
        # Check if both files exist and have reasonable content
        local slides_size=$(wc -c < "$BUILD_DIR/slides.html" 2>/dev/null || echo "0")
        local docs_size=$(wc -c < "$BUILD_DIR/index.html" 2>/dev/null || echo "0")
        
        if [[ $slides_size -lt 1000 ]]; then
            quality_issues+=("Slides file appears too small: ${slides_size} bytes")
        fi
        
        if [[ $docs_size -lt 1000 ]]; then
            quality_issues+=("Documentation index appears too small: ${docs_size} bytes")
        fi
        
        # Check for required slide content
        if ! grep -q "LLMs" "$BUILD_DIR/slides.html" 2>/dev/null; then
            quality_issues+=("Slides may be missing core LLM content")
        fi
        
        print_status $GREEN "✅ Content consistency checks completed"
    fi
    
    # Report quality issues
    if [[ ${#quality_issues[@]} -eq 0 ]]; then
        print_status $GREEN "✅ All content quality checks passed"
    else
        print_status $YELLOW "⚠️  Content quality issues found:"
        for issue in "${quality_issues[@]}"; do
            print_status $YELLOW "   - $issue"
        done
        
        # In development mode, warn but continue; in production mode, consider failing
        if [[ "$BUILD_MODE" == "production" ]] && [[ ${#quality_issues[@]} -gt 10 ]]; then
            print_status $RED "❌ Too many content quality issues for production build"
            return 1
        fi
    fi
    
    return 0
}

# Function to optimize generated files for better performance
optimize_build_output() {
    print_status $BLUE "⚡ Optimizing build output for performance..."
    
    local optimization_count=0
    
    if [[ ! -d "$BUILD_DIR" ]]; then
        print_status $YELLOW "⚠️  Build directory not found, skipping optimization"
        return 0
    fi
    
    # Optimize HTML files
    print_status $BLUE "📄 Optimizing HTML files..."
    local html_files=$(find "$BUILD_DIR" -name "*.html" -type f 2>/dev/null)
    for html_file in $html_files; do
        if [[ -f "$html_file" ]]; then
            local original_size=$(wc -c < "$html_file")
            
            # Remove excessive whitespace and empty lines
            sed -i.bak 's/[[:space:]]*$//' "$html_file" 2>/dev/null || true
            sed -i.bak '/^[[:space:]]*$/d' "$html_file" 2>/dev/null || true
            rm -f "${html_file}.bak" 2>/dev/null || true
            
            local optimized_size=$(wc -c < "$html_file")
            if [[ $optimized_size -lt $original_size ]]; then
                ((optimization_count++))
                local saved=$((original_size - optimized_size))
                print_status $GREEN "   ✅ Optimized $(basename "$html_file"): saved ${saved} bytes"
            fi
        fi
    done
    
    # Optimize CSS files if any exist
    print_status $BLUE "🎨 Checking CSS files..."
    local css_files=$(find "$BUILD_DIR" -name "*.css" -type f 2>/dev/null)
    for css_file in $css_files; do
        if [[ -f "$css_file" ]]; then
            local original_size=$(wc -c < "$css_file")
            
            # Remove comments and excessive whitespace
            sed -i.bak 's|/\*.*\*/||g' "$css_file" 2>/dev/null || true
            sed -i.bak 's/[[:space:]]*$//' "$css_file" 2>/dev/null || true
            sed -i.bak '/^[[:space:]]*$/d' "$css_file" 2>/dev/null || true
            rm -f "${css_file}.bak" 2>/dev/null || true
            
            local optimized_size=$(wc -c < "$css_file")
            if [[ $optimized_size -lt $original_size ]]; then
                ((optimization_count++))
                local saved=$((original_size - optimized_size))
                print_status $GREEN "   ✅ Optimized $(basename "$css_file"): saved ${saved} bytes"
            fi
        fi
    done
    
    # Check for duplicate files
    print_status $BLUE "🔍 Checking for duplicate files..."
    local duplicates_found=0
    if command_exists shasum || command_exists md5sum; then
        local hash_cmd="shasum"
        if ! command_exists shasum; then
            hash_cmd="md5sum"
        fi
        
        # Find files with same content
        local temp_hashes=$(mktemp)
        find "$BUILD_DIR" -type f \( -name "*.css" -o -name "*.js" -o -name "*.png" -o -name "*.jpg" \) -exec $hash_cmd {} \; > "$temp_hashes" 2>/dev/null
        
        # Count duplicate hashes
        duplicates_found=$(cut -d' ' -f1 "$temp_hashes" | sort | uniq -d | wc -l)
        rm -f "$temp_hashes"
        
        if [[ $duplicates_found -gt 0 ]]; then
            print_status $YELLOW "⚠️  Found $duplicates_found potential duplicate files"
        else
            print_status $GREEN "✅ No duplicate files detected"
        fi
    fi
    
    # Generate gzip versions for better compression (if gzip available)
    if command_exists gzip; then
        print_status $BLUE "🗜️  Generating compressed versions..."
        local gzip_count=0
        for html_file in $(find "$BUILD_DIR" -name "*.html" -type f 2>/dev/null); do
            if [[ -f "$html_file" ]]; then
                gzip -c "$html_file" > "${html_file}.gz" 2>/dev/null
                if [[ $? -eq 0 ]] && [[ -f "${html_file}.gz" ]]; then
                    ((gzip_count++))
                fi
            fi
        done
        
        if [[ $gzip_count -gt 0 ]]; then
            print_status $GREEN "   ✅ Generated $gzip_count compressed files"
        fi
    fi
    
    # Report optimization summary
    if [[ $optimization_count -gt 0 ]]; then
        print_status $GREEN "✅ Optimized $optimization_count files successfully"
    else
        print_status $GREEN "✅ Files already optimally sized"
    fi
    
    # Calculate total build directory size after optimization
    local final_size=$(du -sh "$BUILD_DIR" 2>/dev/null | cut -f1)
    print_status $GREEN "📊 Final build size: $final_size"
}

# Function to run enhanced validation with performance monitoring
run_validation() {
    print_status $BLUE "🔍 Running comprehensive build validation..."
    
    # Measure validation time
    local validation_start=$(date +%s)
    
    # Run content quality checks first
    if ! run_content_quality_checks; then
        print_status $RED "❌ Content quality validation failed"
        exit 1
    fi
    
    # Run existing validation script if available
    if [[ -x scripts/validate-build.sh ]]; then
        print_status $BLUE "🛠️  Running custom validation script..."
        scripts/validate-build.sh
        
        if [[ $? -eq 0 ]]; then
            print_status $GREEN "✅ Custom validation passed"
        else
            print_status $RED "❌ Custom validation failed"
            exit 1
        fi
    else
        print_status $YELLOW "⚠️  Custom validation script not found, using enhanced checks"
        
        # Enhanced basic validation
        local validation_errors=0
        
        # Check for required files
        required_files=("$BUILD_DIR/slides.html" "$BUILD_DIR/index.html")
        for file in "${required_files[@]}"; do
            if [[ ! -f "$file" ]]; then
                print_status $RED "❌ Required file missing: $file"
                ((validation_errors++))
            else
                # Check file is not empty and contains expected content
                if [[ ! -s "$file" ]]; then
                    print_status $RED "❌ Required file is empty: $file"
                    ((validation_errors++))
                elif [[ "$file" == *"slides.html" ]] && ! grep -q "<html" "$file"; then
                    print_status $RED "❌ Slides file appears invalid"
                    ((validation_errors++))
                elif [[ "$file" == *"index.html" ]] && ! grep -q "<html" "$file"; then
                    print_status $RED "❌ Documentation index appears invalid"
                    ((validation_errors++))
                fi
            fi
        done
        
        # Check build directory structure
        if [[ ! -d "$BUILD_DIR" ]]; then
            print_status $RED "❌ Build directory missing"
            ((validation_errors++))
        fi
        
        if [[ $validation_errors -eq 0 ]]; then
            print_status $GREEN "✅ Enhanced basic validation passed"
        else
            print_status $RED "❌ Basic validation failed with $validation_errors errors"
            exit 1
        fi
    fi
    
    # Performance metrics for validation
    local validation_end=$(date +%s)
    local validation_time=$((validation_end - validation_start))
    print_status $GREEN "⏱️  Validation completed in ${validation_time} seconds"
    
    print_status $GREEN "✅ All validation checks passed"
}

# Function to generate enhanced build report with performance metrics
generate_report() {
    print_status $BLUE "📋 Generating enhanced build report..."
    
    local REPORT_FILE="build-report-$(date +%Y%m%d-%H%M%S).txt"
    
    {
        echo "================================================================="
        echo "ENHANCED BUILD REPORT: $PROJECT_NAME"
        echo "================================================================="
        echo "Build Date: $(date)"
        echo "Build Mode: $BUILD_MODE"
        echo "Build Script Version: Enhanced with Quality Assurance"
        echo ""
        echo "System Information:"
        echo "================================================================="
        echo "Operating System: $(uname -s) $(uname -r)"
        echo "Architecture: $(uname -m)"
        echo "Shell: $BASH_VERSION"
        echo "Node Version: $(node --version)"
        NPM_VERSION=$(npm --version)
        echo "NPM Version: $NPM_VERSION"
        if command_exists mkdocs; then
            echo "MkDocs Version: $(mkdocs --version 2>/dev/null | head -n1)"
        fi
        if command_exists git; then
            echo "Git Version: $(git --version | awk '{print $3}')"
        fi
        if [[ -f $VERSION_FILE ]]; then
            echo "Project Version: $(cat $VERSION_FILE)"
        fi
        echo ""
        echo "Build Performance Metrics:"
        echo "================================================================="
        if [[ -n "${BUILD_TIME:-}" ]]; then
            echo "Total Build Time: ${BUILD_TIME} seconds"
        fi
        if [[ -d "$BUILD_DIR" ]]; then
            local total_files=$(find "$BUILD_DIR" -type f | wc -l)
            local total_size=$(du -sh "$BUILD_DIR" 2>/dev/null | cut -f1)
            echo "Total Generated Files: $total_files"
            echo "Total Build Size: $total_size"
            
            # File type breakdown
            echo ""
            echo "File Type Breakdown:"
            echo "  HTML Files: $(find "$BUILD_DIR" -name "*.html" -type f | wc -l)"
            echo "  CSS Files: $(find "$BUILD_DIR" -name "*.css" -type f | wc -l)"
            echo "  JavaScript Files: $(find "$BUILD_DIR" -name "*.js" -type f | wc -l)"
            echo "  PDF Files: $(find "$BUILD_DIR" -name "*.pdf" -type f | wc -l)"
            echo "  Image Files: $(find "$BUILD_DIR" \( -name "*.png" -o -name "*.jpg" -o -name "*.svg" \) -type f | wc -l)"
        fi
        echo ""
        echo "Generated Files:"
        echo "================================================================="
        if [[ -d "$BUILD_DIR" ]]; then
            find "$BUILD_DIR" -type f \( -name "*.html" -o -name "*.pdf" -o -name "*.css" -o -name "*.js" \) | sort | while read -r file; do
                local size=$(du -h "$file" 2>/dev/null | cut -f1)
                echo "$file ($size)"
            done
        fi
        echo ""
        echo "Detailed Build Directory Analysis:"
        echo "================================================================="
        if [[ -d "$BUILD_DIR" ]]; then
            du -sh "$BUILD_DIR"/* 2>/dev/null | sort -hr | head -20 || echo "No files found"
        fi
        echo ""
        echo "Quality Assurance Summary:"
        echo "================================================================="
        echo "✅ Enhanced Build Validation: Enabled"
        echo "✅ Content Quality Checks: Enabled"
        echo "✅ Link Validation: Enabled"
        echo "✅ HTML Validation: Enabled"
        echo "✅ Accessibility Checks: Enabled"
        echo "✅ File Size Monitoring: Enabled"
        echo "✅ Performance Monitoring: Enabled"
        echo ""
        echo "Package Information:"
        echo "================================================================="
        if [[ -f package.json ]]; then
            echo "Dependencies:"
            npm list --depth=0 2>/dev/null | head -20 || echo "Could not list packages"
            
            # Security audit summary
            if [[ -f package-lock.json ]]; then
                echo ""
                echo "Security Audit Summary:"
                local audit_summary=$(npm audit --json 2>/dev/null | node -pe 'try { const a = JSON.parse(require("fs").readFileSync("/dev/stdin")); console.log(`Total vulnerabilities: ${a.metadata.vulnerabilities.total || 0}`); console.log(`High severity: ${a.metadata.vulnerabilities.high || 0}`); console.log(`Critical severity: ${a.metadata.vulnerabilities.critical || 0}`); } catch(e) { console.log("Unable to parse audit data"); }' 2>/dev/null || echo "Security audit not available")
            fi
        fi
        echo ""
        echo "Environment Variables:"
        echo "================================================================="
        echo "BUILD_PDF: ${BUILD_PDF:-false}"
        echo "CLEAN_BUILD: ${CLEAN_BUILD:-false}"
        echo "DEV_MODE: ${DEV_MODE:-false}"
        echo "SKIP_DOCS: ${SKIP_DOCS:-false}"
        echo ""
        echo "Build Status: SUCCESS"
        echo "Quality Enhancement: ACTIVE"
        echo "================================================================="
    } > "$REPORT_FILE"
    
    print_status $GREEN "✅ Enhanced build report generated: $REPORT_FILE"
    
    # Show key metrics in console
    if [[ -d "$BUILD_DIR" ]]; then
        local file_count=$(find "$BUILD_DIR" -type f | wc -l)
        local total_size=$(du -sh "$BUILD_DIR" 2>/dev/null | cut -f1)
        print_status $GREEN "📊 Build Summary: $file_count files, $total_size total"
    fi
}

# Function to display usage
usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Enhanced build script for $PROJECT_NAME conference presentation"
    echo ""
    echo "Options:"
    echo "  -h, --help       Show this help message"
    echo "  -c, --clean      Clean build directory before building"
    echo "  -p, --pdf        Build PDF slides in addition to HTML"
    echo "  -d, --dev        Development mode (faster build, skip optimization)"
    echo "  -v, --validate   Run full validation after build"
    echo "  -o, --optimize   Force optimization (enabled by default in production)"
    echo "  --no-version     Skip version update"
    echo "  --skip-deps      Skip dependency installation"
    echo "  --no-optimize    Skip optimization step"
    echo "  --recover        Recover from previous failed build"
    echo ""
    echo "Build Resilience Features:"
    echo "  • Automated build state tracking and recovery"
    echo "  • Build interruption handling with graceful cleanup"
    echo "  • Automatic backup creation before major operations"
    echo "  • Build lock mechanism to prevent concurrent builds"
    echo "  • Comprehensive build logging and error reporting"
    echo ""
    echo "Quality Assurance Features:"
    echo "  • Enhanced dependency validation with security checks"
    echo "  • Automated content quality assurance (links, HTML, accessibility)"
    echo "  • Performance optimization and file size monitoring" 
    echo "  • Build time measurement and performance insights"
    echo "  • Comprehensive build reporting with metrics"
    echo ""
    echo "Examples:"
    echo "  $0                        # Standard production build with all enhancements"
    echo "  $0 --clean --pdf          # Clean build with PDF generation"
    echo "  $0 --dev                  # Quick development build (minimal validation)"
    echo "  $0 --validate --optimize  # Full quality assurance with optimization"
    echo ""
}

# Main build function
main() {
    local START_TIME=$(date +%s)
    
    print_header "BUILDING $PROJECT_NAME CONFERENCE MATERIALS"
    
    # Parse command line arguments
    BUILD_PDF="false"
    CLEAN_BUILD="false"
    DEV_MODE="false"
    RUN_VALIDATION="false"
    UPDATE_VERSION="true"
    SKIP_DEPS="false"
    FORCE_OPTIMIZE="false"
    SKIP_OPTIMIZE="false"
    RECOVER_BUILD="false"
    RESUME_BUILD="false"
    CHECK_CORRUPTION="false"
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                usage
                exit 0
                ;;
            -c|--clean)
                CLEAN_BUILD="true"
                shift
                ;;
            -p|--pdf)
                BUILD_PDF="true"
                shift
                ;;
            -d|--dev)
                DEV_MODE="true"
                shift
                ;;
            -v|--validate)
                RUN_VALIDATION="true"
                shift
                ;;
            -o|--optimize)
                FORCE_OPTIMIZE="true"
                shift
                ;;
            --no-version)
                UPDATE_VERSION="false"
                shift
                ;;
            --skip-deps)
                SKIP_DEPS="true"
                shift
                ;;
            --no-optimize)
                SKIP_OPTIMIZE="true"
                shift
                ;;
            --recover)
                RECOVER_BUILD="true"
                shift
                ;;
            --resume)
                RESUME_BUILD="true"
                shift
                ;;
            --check-corruption)
                CHECK_CORRUPTION="true"
                shift
                ;;
            *)
                print_status $RED "❌ Unknown option: $1"
                usage
                exit 1
                ;;
        esac
    done
    
    # Set build mode
    if [[ "$DEV_MODE" == "true" ]]; then
        BUILD_MODE="development"
        print_status $YELLOW "🚧 Development mode enabled"
    else
        BUILD_MODE="production"
        RUN_VALIDATION="true"  # Always validate in production mode
    fi
    
    # Initialize build resilience system
    init_build_state
    setup_signal_handlers
    trap cleanup_on_exit EXIT
    
    # Handle recovery mode
    if [[ "$RECOVER_BUILD" == "true" ]]; then
        if recover_from_failure; then
            print_header "RECOVERY COMPLETED SUCCESSFULLY"
            exit 0
        else
            print_status $RED "❌ Recovery failed"
            exit 1
        fi
    fi
    
    # Handle resume mode
    if [[ "$RESUME_BUILD" == "true" ]]; then
        if resume_build_from_checkpoint ""; then
            print_header "BUILD RESUMED FROM CHECKPOINT"
            # Continue with remaining build steps
        else
            print_status $RED "❌ Resume failed, starting fresh build"
        fi
    fi
    
    # Handle corruption check mode
    if [[ "$CHECK_CORRUPTION" == "true" ]]; then
        if detect_and_repair_corruption; then
            print_header "CORRUPTION CHECK COMPLETED"
            exit 0
        else
            print_status $RED "❌ Corruption detected and repair failed"
            exit 1
        fi
    fi
    
    # Check for concurrent builds
    if ! check_build_lock; then
        exit 1
    fi
    
    create_build_lock
    save_build_state "build_started" "in_progress" "Build process initiated"
    
    # Execute comprehensive validation steps
    validate_environment
    validate_file_structure  
    check_prerequisites
    check_network_connectivity
    
    if [[ "$UPDATE_VERSION" == "true" ]]; then
        update_version
    fi
    
    if [[ "$SKIP_DEPS" == "false" ]]; then
        install_dependencies
    fi
    
    if [[ "$CLEAN_BUILD" == "true" ]]; then
        save_build_state "clean_build" "in_progress" "Cleaning build directory"
        clean_build
        save_build_state "clean_build" "success" "Build directory cleaned"
    fi
    
    # Check for existing corruption and attempt repair
    detect_and_repair_corruption
    
    # Create backup before major build operations
    save_build_state "backup_creation" "in_progress" "Creating pre-build backup"
    BACKUP_PATH=$(create_build_backup)
    
    # Build slides with enhanced resilience
    save_build_state "slides_build" "in_progress" "Building presentation slides"
    local slides_start_time=$(date +%s)
    build_slides
    local slides_end_time=$(date +%s)
    save_build_state "slides_build" "success" "Slides built successfully"
    
    # Create checkpoint after slides
    SLIDES_CHECKPOINT=$(create_build_checkpoint "slides_completed")
    monitor_build_health "slides_build" $slides_start_time $slides_end_time
    
    # Verify slides integrity
    if [[ -f "$BUILD_DIR/slides.html" ]]; then
        if ! grep -q "<!DOCTYPE\|<html" "$BUILD_DIR/slides.html" 2>/dev/null; then
            print_status $RED "❌ Slides build appears corrupted"
            exit 1
        fi
    fi
    
    # Build documentation with enhanced resilience
    save_build_state "docs_build" "in_progress" "Building documentation"
    local docs_start_time=$(date +%s)
    build_documentation
    local docs_end_time=$(date +%s)
    save_build_state "docs_build" "success" "Documentation built successfully"
    
    # Create checkpoint after documentation
    DOCS_CHECKPOINT=$(create_build_checkpoint "docs_completed")
    monitor_build_health "docs_build" $docs_start_time $docs_end_time
    
    # Verify documentation integrity
    if [[ -f "$BUILD_DIR/index.html" ]]; then
        if ! grep -q "<!DOCTYPE\|<html" "$BUILD_DIR/index.html" 2>/dev/null; then
            print_status $RED "❌ Documentation build appears corrupted"
            exit 1
        fi
    fi
    
    # Optimize build output based on mode and flags
    if [[ "$SKIP_OPTIMIZE" != "true" ]]; then
        if [[ "$FORCE_OPTIMIZE" == "true" ]] || [[ "$BUILD_MODE" == "production" && "$DEV_MODE" != "true" ]]; then
            save_build_state "optimization" "in_progress" "Optimizing build output"
            optimize_build_output
            save_build_state "optimization" "success" "Build output optimized"
        fi
    fi
    
    if [[ "$RUN_VALIDATION" == "true" ]]; then
        save_build_state "validation" "in_progress" "Running build validation"
        run_validation
        save_build_state "validation" "success" "Build validation completed"
    fi
    
    # Final integrity verification
    save_build_state "final_verification" "in_progress" "Performing final build integrity check"
    if verify_build_integrity; then
        save_build_state "final_verification" "success" "Final integrity check passed"
        
        # Create final checkpoint
        FINAL_CHECKPOINT=$(create_build_checkpoint "build_completed")
        print_status $GREEN "🏁 Final checkpoint created: $(basename "$FINAL_CHECKPOINT")"
    else
        save_build_state "final_verification" "failure" "Final integrity check failed"
        print_status $RED "❌ Final build integrity check failed"
        exit 1
    fi
    
    # Calculate build time and make it available globally
    local END_TIME=$(date +%s)
    BUILD_TIME=$((END_TIME - START_TIME))
    monitor_build_health "total_build" $START_TIME $END_TIME
    
    if [[ "$BUILD_MODE" == "production" ]]; then
        generate_report
    fi
    
    print_header "BUILD COMPLETED SUCCESSFULLY"
    print_status $GREEN "⏱️  Total build time: ${BUILD_TIME} seconds"
    print_status $GREEN "🎯 Output directory: $BUILD_DIR/"
    print_status $GREEN "🚀 Ready for deployment!"
    
    # Performance insights
    if [[ $BUILD_TIME -lt 30 ]]; then
        print_status $GREEN "🚀 Excellent build performance!"
    elif [[ $BUILD_TIME -lt 60 ]]; then
        print_status $YELLOW "⚡ Good build performance"
    else
        print_status $YELLOW "🐌 Consider optimizing build process (took ${BUILD_TIME}s)"
    fi
    
    echo ""
}

# Run main function with all arguments
main "$@"