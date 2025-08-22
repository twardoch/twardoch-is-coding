#!/bin/bash
# this_file: scripts/validate-build.sh

set -e

echo "🔍 Starting build validation for twardoch-is-coding project"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Validate prerequisites
print_status $BLUE "📋 Checking prerequisites..."

if ! command_exists npm; then
    print_status $RED "❌ npm is not installed"
    exit 1
fi

if ! command_exists node; then
    print_status $RED "❌ Node.js is not installed"
    exit 1
fi

if ! command_exists mkdocs; then
    print_status $YELLOW "⚠️  MkDocs not found, documentation build will be skipped"
    SKIP_DOCS=true
else
    SKIP_DOCS=false
fi

print_status $GREEN "✅ Prerequisites check passed"

# Validate package.json and dependencies
print_status $BLUE "📦 Validating package.json and dependencies..."

if [[ ! -f package.json ]]; then
    print_status $RED "❌ package.json not found"
    exit 1
fi

# Check if node_modules exists
if [[ ! -d node_modules ]]; then
    print_status $YELLOW "⚠️  node_modules not found, installing dependencies..."
    npm install
fi

# Validate critical dependencies
REQUIRED_DEPS=("@marp-team/marp-cli")
for dep in "${REQUIRED_DEPS[@]}"; do
    if ! npm list "$dep" >/dev/null 2>&1; then
        print_status $RED "❌ Required dependency $dep not found"
        exit 1
    fi
done

print_status $GREEN "✅ Dependencies validation passed"

# Validate project structure
print_status $BLUE "🏗️  Validating project structure..."

REQUIRED_DIRS=("src_slides" "src_docs" "docs")
for dir in "${REQUIRED_DIRS[@]}"; do
    if [[ ! -d "$dir" ]]; then
        print_status $RED "❌ Required directory $dir not found"
        exit 1
    fi
done

REQUIRED_FILES=("README.md" "package.json" "src_slides/slides.md" "src_docs/mkdocs.yml")
for file in "${REQUIRED_FILES[@]}"; do
    if [[ ! -f "$file" ]]; then
        print_status $RED "❌ Required file $file not found"
        exit 1
    fi
done

print_status $GREEN "✅ Project structure validation passed"

# Validate slide content
print_status $BLUE "🎨 Validating slide content..."

# Check for required sections in slides
REQUIRED_SECTIONS=("LLM" "IDE vs CLI" "MCP" "Journey")
SLIDES_CONTENT=$(cat src_slides/slides.md)

for section in "${REQUIRED_SECTIONS[@]}"; do
    if ! echo "$SLIDES_CONTENT" | grep -qi "$section"; then
        print_status $YELLOW "⚠️  Section '$section' might be missing from slides"
    fi
done

# Check for Mermaid diagrams
if ! echo "$SLIDES_CONTENT" | grep -q "\`\`\`mermaid"; then
    print_status $YELLOW "⚠️  No Mermaid diagrams found in slides"
else
    MERMAID_COUNT=$(echo "$SLIDES_CONTENT" | grep -c "\`\`\`mermaid")
    print_status $GREEN "✅ Found $MERMAID_COUNT Mermaid diagram(s) in slides"
fi

print_status $GREEN "✅ Slide content validation passed"

# Build slides
print_status $BLUE "🔨 Building slides..."

npm run build-slides

if [[ $? -eq 0 ]]; then
    print_status $GREEN "✅ Slides built successfully"
    
    # Check output file
    if [[ -f docs/slides.html ]]; then
        SIZE=$(du -h docs/slides.html | cut -f1)
        print_status $GREEN "✅ Slides output: docs/slides.html ($SIZE)"
    else
        print_status $RED "❌ Slides output file not found"
        exit 1
    fi
else
    print_status $RED "❌ Slides build failed"
    exit 1
fi

# Build documentation (if MkDocs available)
if [[ "$SKIP_DOCS" == "false" ]]; then
    print_status $BLUE "📚 Building documentation..."
    
    cd src_docs
    mkdocs build --config-file mkdocs.yml --site-dir ../docs --quiet
    
    if [[ $? -eq 0 ]]; then
        print_status $GREEN "✅ Documentation built successfully"
        
        # Check for index.html
        if [[ -f ../docs/index.html ]]; then
            print_status $GREEN "✅ Documentation index created"
        else
            print_status $YELLOW "⚠️  Documentation index not found"
        fi
    else
        print_status $RED "❌ Documentation build failed"
        exit 1
    fi
    
    cd ..
else
    print_status $YELLOW "⚠️  Skipping documentation build (MkDocs not available)"
fi

# Validate built content
print_status $BLUE "🔍 Validating built content..."

# Check slides HTML
if [[ -f docs/slides.html ]]; then
    # Check for basic HTML structure
    if grep -q "<html" docs/slides.html && grep -q "</html>" docs/slides.html; then
        print_status $GREEN "✅ Slides HTML structure valid"
    else
        print_status $RED "❌ Slides HTML structure invalid"
        exit 1
    fi
    
    # Check for Mermaid content
    if grep -q "mermaid" docs/slides.html; then
        print_status $GREEN "✅ Mermaid diagrams included in slides"
    else
        print_status $YELLOW "⚠️  Mermaid diagrams might not be properly included"
    fi
fi

# Check documentation if built
if [[ -f docs/index.html ]]; then
    if grep -q "<html" docs/index.html && grep -q "</html>" docs/index.html; then
        print_status $GREEN "✅ Documentation HTML structure valid"
    else
        print_status $RED "❌ Documentation HTML structure invalid"
        exit 1
    fi
fi

# File size checks
print_status $BLUE "📏 Checking file sizes..."

MAX_SLIDES_SIZE=5242880  # 5MB in bytes
if [[ -f docs/slides.html ]]; then
    SLIDES_SIZE=$(stat -f%z docs/slides.html 2>/dev/null || stat -c%s docs/slides.html)
    if [[ $SLIDES_SIZE -gt $MAX_SLIDES_SIZE ]]; then
        print_status $YELLOW "⚠️  Slides file is large ($(($SLIDES_SIZE / 1024 / 1024))MB)"
    else
        print_status $GREEN "✅ Slides file size acceptable ($(($SLIDES_SIZE / 1024))KB)"
    fi
fi

# Link validation (basic)
print_status $BLUE "🔗 Validating links..."

# Check README links
if grep -q "github.com/twardoch/twardoch-is-coding" README.md; then
    print_status $GREEN "✅ GitHub links found in README"
else
    print_status $YELLOW "⚠️  GitHub links might be missing from README"
fi

# Final summary
print_status $BLUE "📊 Build validation summary:"
echo ""
echo "✅ Prerequisites: OK"
echo "✅ Dependencies: OK"
echo "✅ Project structure: OK"
echo "✅ Slide content: OK"
echo "✅ Slides build: OK"
if [[ "$SKIP_DOCS" == "false" ]]; then
    echo "✅ Documentation build: OK"
else
    echo "⚠️  Documentation build: SKIPPED"
fi
echo "✅ Content validation: OK"
echo ""

print_status $GREEN "🎉 All validations passed! Project is ready for deployment."

# Optional: Generate build report
BUILD_REPORT="build-report-$(date +%Y%m%d-%H%M%S).txt"
{
    echo "Build Validation Report"
    echo "======================"
    echo "Date: $(date)"
    echo "Project: twardoch-is-coding"
    echo ""
    echo "Files generated:"
    ls -la docs/ || echo "No docs directory found"
    echo ""
    echo "Dependencies:"
    npm list --depth=0 2>/dev/null || echo "Could not list dependencies"
} > "$BUILD_REPORT"

print_status $BLUE "📄 Build report saved to: $BUILD_REPORT"

exit 0