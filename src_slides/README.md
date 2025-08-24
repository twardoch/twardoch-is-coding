# Conference Slide Presentations

This directory contains the same conference talk implemented in four different slide deck frameworks:

## 📁 Directory Structure

```
src_slides/
├── marp/       # Marp - Markdown-based with CSS themes
├── slidev/     # Slidev - Vue.js-based interactive slides
├── revealjs/   # Reveal.js - HTML/JS with rich plugins
└── mdx/        # MDX Deck - React-based with MDX
```

## 🚀 Quick Start

### Install All Dependencies
```bash
npm run install-all
```

### Run Individual Presentations
```bash
npm run serve-marp      # http://localhost:8081
npm run serve-slidev    # http://localhost:3030
npm run serve-revealjs  # http://localhost:8000
npm run serve-mdx       # http://localhost:8080
```

### Build All Presentations
```bash
npm run build-slides
```

## 🎨 Framework Features

### Marp
- **Strengths**: Simple, clean, multiple export formats
- **Features**: Custom CSS themes, speaker notes, math support
- **Best for**: Traditional presentations with professional styling

### Slidev
- **Strengths**: Interactive, developer-focused, Vue components
- **Features**: Live coding, Monaco editor, presenter mode
- **Best for**: Technical demos and interactive content

### Reveal.js
- **Strengths**: Mature ecosystem, rich animations, plugins
- **Features**: 3D transitions, nested slides, fragments
- **Best for**: Multimedia presentations with complex animations

### MDX Deck
- **Strengths**: React integration, component-driven
- **Features**: Custom React components, Theme UI
- **Best for**: React developers wanting component reusability

## 📝 Content

All four presentations cover:
1. LLM Fundamentals
2. IDE vs CLI Paradigms
3. MCP Protocol
4. Real Experience from 177 repositories

Each framework showcases its unique capabilities while delivering the same core content.

## 🛠️ Development

Each framework directory contains:
- `package.json` - Dependencies and scripts
- `slides.*` - Main presentation file
- Framework-specific configuration files

To modify a presentation, edit the slides file in the respective directory and use the serve command to see live updates.

## 📦 Building

Built presentations are output to `src_docs/docs/slides/[framework]/`

The build process:
1. Generates HTML presentations
2. Creates PDF exports (where supported)
3. Copies assets and dependencies
4. Integrates with MkDocs site

## 🔗 Integration

The presentations are integrated into the main MkDocs documentation site and can be accessed through the navigation menu under "Conference Slides".