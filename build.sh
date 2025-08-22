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
    
    # Check OS compatibility
    case "$(uname -s)" in
        Linux|Darwin)
            print_status $GREEN "✅ Operating system supported: $(uname -s)"
            ;;
        CYGWIN*|MINGW*|MSYS*)
            print_status $YELLOW "⚠️  Windows environment detected - some features may be limited"
            ;;
        *)
            print_status $YELLOW "⚠️  Unknown operating system: $(uname -s)"
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

# Function to validate dependencies and versions
check_prerequisites() {
    print_status $BLUE "📋 Checking build prerequisites..."
    
    local missing_deps=()
    local version_warnings=()
    
    # Essential dependencies
    if ! command_exists npm; then
        missing_deps+=("npm")
    else
        NPM_VERSION=$(npm --version)
        print_status $GREEN "✅ npm: $NPM_VERSION"
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
    fi
    
    # Git (recommended for version management)
    if ! command_exists git; then
        print_status $YELLOW "⚠️  Git not found - version management limited"
    else
        GIT_VERSION=$(git --version | awk '{print $3}')
        print_status $GREEN "✅ Git: $GIT_VERSION"
    fi
    
    # Check for MkDocs (optional but recommended)
    if ! command_exists mkdocs; then
        print_status $YELLOW "⚠️  MkDocs not found - documentation build will be limited"
        SKIP_DOCS=true
    else
        MKDOCS_VERSION=$(mkdocs --version 2>/dev/null | head -n1)
        SKIP_DOCS=false
        print_status $GREEN "✅ MkDocs: $MKDOCS_VERSION"
    fi
    
    # Check Python if MkDocs is available
    if [[ "$SKIP_DOCS" == "false" ]]; then
        if ! command_exists python && ! command_exists python3; then
            print_status $YELLOW "⚠️  Python not found - some MkDocs features may be limited"
        else
            PYTHON_CMD=$(command_exists python3 && echo "python3" || echo "python")
            PYTHON_VERSION=$($PYTHON_CMD --version 2>&1 | awk '{print $2}')
            print_status $GREEN "✅ Python: $PYTHON_VERSION"
        fi
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

# Function to run validation
run_validation() {
    print_status $BLUE "🔍 Running build validation..."
    
    if [[ -x scripts/validate-build.sh ]]; then
        scripts/validate-build.sh
        
        if [[ $? -eq 0 ]]; then
            print_status $GREEN "✅ Build validation passed"
        else
            print_status $RED "❌ Build validation failed"
            exit 1
        fi
    else
        print_status $YELLOW "⚠️  Validation script not found or not executable"
        
        # Basic validation
        if [[ -f "$BUILD_DIR/slides.html" ]] && [[ -f "$BUILD_DIR/index.html" ]]; then
            print_status $GREEN "✅ Basic validation passed (key files present)"
        else
            print_status $RED "❌ Basic validation failed (missing key files)"
            exit 1
        fi
    fi
}

# Function to generate build report
generate_report() {
    print_status $BLUE "📋 Generating build report..."
    
    local REPORT_FILE="build-report-$(date +%Y%m%d-%H%M%S).txt"
    
    {
        echo "================================================================="
        echo "BUILD REPORT: $PROJECT_NAME"
        echo "================================================================="
        echo "Build Date: $(date)"
        echo "Build Mode: $BUILD_MODE"
        echo "Node Version: $(node --version)"
        if command_exists mkdocs; then
            echo "MkDocs Version: $(mkdocs --version)"
        fi
        if [[ -f $VERSION_FILE ]]; then
            echo "Project Version: $(cat $VERSION_FILE)"
        fi
        echo ""
        echo "Generated Files:"
        echo "================================================================="
        if [[ -d "$BUILD_DIR" ]]; then
            find "$BUILD_DIR" -type f -name "*.html" -o -name "*.pdf" | sort
        fi
        echo ""
        echo "Build Directory Size:"
        echo "================================================================="
        if [[ -d "$BUILD_DIR" ]]; then
            du -sh "$BUILD_DIR"/* 2>/dev/null || echo "No files found"
        fi
        echo ""
        echo "Package Information:"
        echo "================================================================="
        if [[ -f package.json ]]; then
            npm list --depth=0 2>/dev/null || echo "Could not list packages"
        fi
        echo ""
        echo "Build Status: SUCCESS"
        echo "================================================================="
    } > "$REPORT_FILE"
    
    print_status $GREEN "✅ Build report generated: $REPORT_FILE"
}

# Function to display usage
usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Build script for $PROJECT_NAME conference presentation"
    echo ""
    echo "Options:"
    echo "  -h, --help       Show this help message"
    echo "  -c, --clean      Clean build directory before building"
    echo "  -p, --pdf        Build PDF slides in addition to HTML"
    echo "  -d, --dev        Development mode (faster build, less validation)"
    echo "  -v, --validate   Run full validation after build"
    echo "  --no-version     Skip version update"
    echo "  --skip-deps      Skip dependency installation"
    echo ""
    echo "Examples:"
    echo "  $0                    # Standard build"
    echo "  $0 --clean --pdf      # Clean build with PDF generation"
    echo "  $0 --dev              # Quick development build"
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
            --no-version)
                UPDATE_VERSION="false"
                shift
                ;;
            --skip-deps)
                SKIP_DEPS="true"
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
        clean_build
    fi
    
    build_slides
    build_documentation
    
    if [[ "$RUN_VALIDATION" == "true" ]]; then
        run_validation
    fi
    
    if [[ "$BUILD_MODE" == "production" ]]; then
        generate_report
    fi
    
    # Calculate build time
    local END_TIME=$(date +%s)
    local BUILD_TIME=$((END_TIME - START_TIME))
    
    print_header "BUILD COMPLETED SUCCESSFULLY"
    print_status $GREEN "⏱️  Total build time: ${BUILD_TIME} seconds"
    print_status $GREEN "🎯 Output directory: $BUILD_DIR/"
    print_status $GREEN "🚀 Ready for deployment!"
    echo ""
}

# Run main function with all arguments
main "$@"