#!/bin/bash
# this_file: build_slides.sh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
PROJECT_NAME="twardoch-is-coding"
SLIDES_SRC="src_slides"
SLIDES_OUTPUT_DIR="src_docs/docs/slides"

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

# Function to validate prerequisites
check_prerequisites() {
    print_status $BLUE "📋 Checking slide build prerequisites..."
    
    local missing_deps=()
    
    if ! command_exists npm; then
        missing_deps+=("npm")
    fi
    
    if ! command_exists node; then
        missing_deps+=("node")
    fi
    
    # Check if marp-cli is installed
    if [[ ! -d "node_modules/@marp-team/marp-cli" ]] && ! command_exists marp; then
        missing_deps+=("@marp-team/marp-cli")
    fi
    
    if [[ ${#missing_deps[@]} -ne 0 ]]; then
        print_status $RED "❌ Missing required dependencies: ${missing_deps[*]}"
        print_status $RED "Please run 'npm install' first"
        exit 1
    fi
    
    print_status $GREEN "✅ Prerequisites check passed"
}

# Function to validate file structure
validate_files() {
    print_status $BLUE "📁 Validating slide source files..."
    
    if [[ ! -f "$SLIDES_SRC/slides.md" ]]; then
        print_status $RED "❌ Slide source file missing: $SLIDES_SRC/slides.md"
        exit 1
    fi
    
    if [[ ! -s "$SLIDES_SRC/slides.md" ]]; then
        print_status $RED "❌ Slide source file is empty: $SLIDES_SRC/slides.md"
        exit 1
    fi
    
    if [[ ! -f "marp.config.js" ]]; then
        print_status $YELLOW "⚠️  Marp config not found: marp.config.js"
    fi
    
    if [[ ! -f "$SLIDES_SRC/themes/custom-tech.css" ]]; then
        print_status $YELLOW "⚠️  Custom theme not found: $SLIDES_SRC/themes/custom-tech.css"
    fi
    
    print_status $GREEN "✅ File validation passed"
}

# Function to build HTML slides
build_html_slides() {
    print_status $BLUE "🎨 Building HTML presentation slides..."
    
    # Ensure output directory exists
    mkdir -p "$SLIDES_OUTPUT_DIR"
    
    # Build HTML slides
    npm run build-slides
    
    if [[ $? -eq 0 ]]; then
        if [[ -f "$SLIDES_OUTPUT_DIR/index.html" ]]; then
            local size=$(du -h "$SLIDES_OUTPUT_DIR/index.html" | cut -f1)
            print_status $GREEN "✅ HTML slides built successfully"
            print_status $GREEN "📄 Output: $SLIDES_OUTPUT_DIR/index.html ($size)"
            echo "$SLIDES_OUTPUT_DIR/index.html"
            return 0
        else
            print_status $RED "❌ HTML slide file not created"
            return 1
        fi
    else
        print_status $RED "❌ HTML slide build failed"
        return 1
    fi
}

# Function to build PDF slides
build_pdf_slides() {
    print_status $BLUE "📄 Building PDF presentation slides..."
    
    # Ensure output directory exists
    mkdir -p "$SLIDES_OUTPUT_DIR"
    
    # Build PDF slides
    npm run build-slides-pdf
    
    if [[ $? -eq 0 ]]; then
        if [[ -f "$SLIDES_OUTPUT_DIR/slides.pdf" ]]; then
            local size=$(du -h "$SLIDES_OUTPUT_DIR/slides.pdf" | cut -f1)
            print_status $GREEN "✅ PDF slides built successfully"
            print_status $GREEN "📄 Output: $SLIDES_OUTPUT_DIR/slides.pdf ($size)"
            echo "$SLIDES_OUTPUT_DIR/slides.pdf"
            return 0
        else
            print_status $RED "❌ PDF slide file not created"
            return 1
        fi
    else
        print_status $RED "❌ PDF slide build failed"
        return 1
    fi
}

# Function to display usage
usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Standalone slide builder for $PROJECT_NAME"
    echo ""
    echo "Options:"
    echo "  -h, --help       Show this help message"
    echo "  -p, --pdf        Build PDF slides only"
    echo "  -H, --html       Build HTML slides only (default)"
    echo "  -a, --all        Build both HTML and PDF slides"
    echo "  -c, --clean      Clean output directory before building"
    echo ""
    echo "Examples:"
    echo "  $0               # Build HTML slides (default)"
    echo "  $0 --pdf         # Build PDF slides only"
    echo "  $0 --all         # Build both HTML and PDF"
    echo "  $0 --clean --all # Clean and build both formats"
    echo ""
}

# Function to clean output directory
clean_output() {
    print_status $BLUE "🧹 Cleaning slides output directory..."
    
    if [[ -d "$SLIDES_OUTPUT_DIR" ]]; then
        rm -rf "$SLIDES_OUTPUT_DIR"/*
        print_status $GREEN "✅ Output directory cleaned"
    else
        mkdir -p "$SLIDES_OUTPUT_DIR"
        print_status $GREEN "✅ Output directory created"
    fi
}

# Main function
main() {
    local build_html="true"
    local build_pdf="false"
    local clean_first="false"
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                usage
                exit 0
                ;;
            -p|--pdf)
                build_html="false"
                build_pdf="true"
                shift
                ;;
            -H|--html)
                build_html="true"
                build_pdf="false"
                shift
                ;;
            -a|--all)
                build_html="true"
                build_pdf="true"
                shift
                ;;
            -c|--clean)
                clean_first="true"
                shift
                ;;
            *)
                print_status $RED "❌ Unknown option: $1"
                usage
                exit 1
                ;;
        esac
    done
    
    print_header "BUILDING $PROJECT_NAME SLIDES"
    
    # Execute build steps
    check_prerequisites
    validate_files
    
    if [[ "$clean_first" == "true" ]]; then
        clean_output
    fi
    
    local outputs=()
    local build_success="true"
    
    if [[ "$build_html" == "true" ]]; then
        if html_output=$(build_html_slides); then
            outputs+=("$html_output")
        else
            build_success="false"
        fi
    fi
    
    if [[ "$build_pdf" == "true" ]]; then
        if pdf_output=$(build_pdf_slides); then
            outputs+=("$pdf_output")
        else
            build_success="false"
        fi
    fi
    
    if [[ "$build_success" == "true" ]]; then
        print_header "SLIDE BUILD COMPLETED SUCCESSFULLY"
        print_status $GREEN "🎯 Built slides:"
        for output in "${outputs[@]}"; do
            print_status $GREEN "   • $output"
        done
        print_status $GREEN "🚀 Slides ready for presentation!"
        echo ""
    else
        print_header "SLIDE BUILD FAILED"
        print_status $RED "❌ Some slides failed to build"
        exit 1
    fi
}

# Run main function with all arguments
main "$@"