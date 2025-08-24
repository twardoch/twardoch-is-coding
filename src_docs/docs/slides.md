# Conference Slide Presentations

This conference talk has been implemented using **four different slide deck frameworks**, each showcasing unique features and capabilities. Choose the version that best suits your viewing preferences:

## 🎨 Available Presentations

### 1. Marp Presentation
**[View Marp Slides](./slides/marp/index.html)** | [Download PDF](./slides/marp/slides.pdf)

- **Technology**: Markdown-based with custom CSS themes
- **Features**: Enhanced animations, speaker notes, math support (KaTeX)
- **Best for**: Simple, clean presentation with professional styling
- **Special**: Custom alert containers, progress bars, animated transitions

### 2. Slidev Presentation
**[View Slidev Slides](./slides/slidev/index.html)**

- **Technology**: Vue.js-based with interactive components
- **Features**: Live coding, Monaco editor integration, Vue animations
- **Best for**: Interactive demos and developer-focused presentations
- **Special**: Real-time code execution, presenter mode, drawing tools

### 3. Reveal.js Presentation
**[View Reveal.js Slides](./slides/revealjs/index.html)** | [Download PDF](./slides/revealjs/slides.pdf)

- **Technology**: HTML/JS with extensive plugin ecosystem
- **Features**: 3D transitions, nested slides, fragments, auto-animate
- **Best for**: Rich multimedia presentations with complex animations
- **Special**: Vertical slide navigation, overview mode, speaker notes

### 4. MDX Deck Presentation
**[View MDX Deck Slides](./slides/mdx/index.html)** | [Download PDF](./slides/mdx/slides.pdf)

- **Technology**: React-based with MDX (Markdown + JSX)
- **Features**: React components, Theme UI styling, step-through content
- **Best for**: Component-driven presentations with React integration
- **Special**: Custom React components, theme system, code splitting

## 🎯 Framework Comparison

| Feature | Marp | Slidev | Reveal.js | MDX Deck |
|---------|------|--------|-----------|----------|
| **Base Technology** | Markdown | Vue.js | HTML/JS | React/MDX |
| **Learning Curve** | Low | Medium | Medium | High |
| **Interactivity** | Basic | High | High | High |
| **Theming** | CSS | Vue/UnoCSS | CSS/JS | Theme UI |
| **Code Highlighting** | Yes | Shiki | Highlight.js | Prism |
| **Live Coding** | No | Yes | Plugin | Component |
| **Export Formats** | HTML, PDF, PPTX | HTML, PDF | HTML, PDF | HTML, PDF |
| **Speaker Notes** | Yes | Yes | Yes | Yes |
| **Animations** | CSS | Vue | CSS/JS | React |
| **Build Size** | Small | Large | Medium | Large |

## 🚀 Quick Start

### Running Locally

Each presentation can be run locally for development:

```bash
# Install dependencies for all frameworks
npm run install-all

# Run individual presentations
npm run serve-marp      # Marp on port 8081
npm run serve-slidev    # Slidev on port 3030
npm run serve-revealjs  # Reveal.js on port 8000
npm run serve-mdx       # MDX Deck on port 8080
```

### Building All Presentations

```bash
# Build all slide decks
npm run build-slides

# Build everything including documentation
npm run build-all
```

## 📚 Content Overview

All four presentations cover the same core content:

1. **LLM Fundamentals** - How these models actually work
2. **IDE vs CLI Paradigms** - Different tools for different jobs
3. **MCP Protocol** - Standardized tool integration
4. **Real Experience** - Practical insights from 177 repositories

Each framework presents this content with its unique styling and interactive features, demonstrating the flexibility of modern web-based presentation tools.

## 💡 Choosing a Framework

- **For simplicity**: Choose **Marp** - pure Markdown with minimal setup
- **For interactivity**: Choose **Slidev** - Vue components and live coding
- **For rich media**: Choose **Reveal.js** - extensive plugin ecosystem
- **For React developers**: Choose **MDX Deck** - full React integration

## 📖 Technical Details

Each presentation framework offers unique advantages:

- **Marp** excels at generating multiple output formats including PowerPoint
- **Slidev** provides the best developer experience with hot reload and Vue DevTools
- **Reveal.js** offers the most mature ecosystem with hundreds of plugins
- **MDX Deck** enables complex component composition and state management

All presentations are optimized for:
- Modern web browsers (Chrome, Firefox, Safari, Edge)
- Screen resolutions from 1280x720 to 4K
- Both presenter and audience viewing modes
- Keyboard navigation and accessibility features