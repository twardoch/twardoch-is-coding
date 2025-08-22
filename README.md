---
# this_file: README.md
---

# Coding with LLMs: Tools and Techniques for Modern Development

A comprehensive conference talk exploring practical Large Language Model integration in software development workflows, presented by Adam Twardoch.

## 🎯 Talk Overview

**Duration:** 20 minutes  
**Audience:** Experienced developers (particularly TeX/Context community)  
**Focus:** Practical insights without deep ML/mathematical background

### Core Topics

1. **How LLMs Actually Work** (5 min) - Tokenization → Embeddings → Transformer → Output
2. **IDE vs CLI: Two Paradigms** (6 min) - VSCode/Cursor vs Claude Code/Gemini CLI
3. **The MCP Revolution** (6 min) - Model Context Protocol and agentic AI tools
4. **My Coding Journey with LLMs** (3 min) - Real-world experience and lessons

## 📁 Project Structure

```
├── src_slides/           # Marpit slide sources
│   ├── slides.md        # Main presentation file
│   ├── themes/          # Custom CSS themes
│   └── assets/          # Images and resources
├── src_docs/            # MkDocs documentation sources
│   ├── mkdocs.yml       # Documentation configuration
│   └── docs/            # Markdown content files
├── docs/                # Generated output (slides + docs)
├── package.json         # Node.js dependencies and scripts
└── README.md           # This file
```

## 🚀 Quick Start

### Prerequisites

- Node.js 16+ (for Marpit slides)
- Python 3.8+ (for MkDocs documentation)

### Installation

```bash
# Clone the repository
git clone https://github.com/twardoch/twardoch-is-coding.git
cd twardoch-is-coding

# Install Node.js dependencies
npm install

# Install Python dependencies (optional, for local docs)
pip install mkdocs mkdocs-material
```

### Build Commands

```bash
# Build slide presentation (HTML)
npm run build-slides

# Build slide presentation (PDF)
npm run build-slides-pdf

# Build documentation site
npm run build-docs

# Build everything
npm run build-all

# Serve slides locally (development)
npm run serve-slides

# Serve documentation locally
npm run serve-docs
```

## 📊 Research Foundation

This talk is based on extensive analysis of Adam Twardoch's development portfolio:

- **177 repositories** analyzed for AI tool usage
- **54 projects** with .specstory folders (Cursor usage evidence)
- **Thousands of Claude Code sessions** documented in ~/.claude/projects/
- **Key projects studied:**
  - **pdf22png**: 42 commits in 60 days, CI/CD pipeline development
  - **claif-packages**: Multi-project Python ecosystem (50+ commits per component)
  - **vttiro**: 100+ Claude Code sessions for video processing
  - **boabro**: Web application with extensive .specstory history

## 🛠️ Technologies Used

### Slide Generation
- **[Marpit](https://marpit.marp.app/)** - Markdown-based slide framework
- **Custom CSS theme** - Technical presentation styling
- **Mermaid diagrams** - Architecture visualizations

### Documentation
- **[MkDocs](https://www.mkdocs.org/)** - Static site generator
- **[Material theme](https://squidfunk.github.io/mkdocs-material/)** - Modern documentation theme
- **GitHub Pages** - Hosting and deployment

### Development Tools Covered
- **IDE-based:** VSCode + GitHub Copilot, Cursor
- **CLI-based:** Claude Code, Gemini CLI, OpenAI Codex
- **Protocols:** Model Context Protocol (MCP)

## 📖 Key Insights

### LLM Fundamentals
- LLMs are sophisticated pattern matching systems, not magic
- Understanding the text → tokens → embeddings → transformer → text flow helps with better prompting
- Attention mechanism enables context understanding and long-range dependencies

### Tool Paradigms
- **IDE tools** excel at real-time suggestions and file-level work
- **CLI tools** provide project-wide understanding and automation capabilities
- **Strategic combination** of both approaches maximizes effectiveness

### MCP Protocol
- Transforms LLMs from text generators to action-taking agents
- Enables tool discovery, chaining, and persistent context
- Bridges the gap between simple completion APIs and autonomous AI systems

### Best Practices
- Always review and test AI-generated code
- Use version control as a safety net
- Security considerations remain critical
- Start simple, scale complexity gradually

## 🔗 Resources

### Live Materials
- **Slides:** [twardoch.github.io/twardoch-is-coding/slides.html](https://twardoch.github.io/twardoch-is-coding/slides.html)
- **Documentation:** [twardoch.github.io/twardoch-is-coding](https://twardoch.github.io/twardoch-is-coding)
- **Source Code:** [github.com/twardoch/twardoch-is-coding](https://github.com/twardoch/twardoch-is-coding)

### Tools Mentioned
- [Claude Code](https://claude.ai/code) - Anthropic's agentic CLI tool
- [Cursor](https://cursor.sh/) - AI-first code editor
- [GitHub Copilot](https://github.com/features/copilot) - AI pair programming
- [Gemini CLI](https://github.com/GoogleAI/gemini-cli) - Google's AI CLI interface

### Further Reading
- [Model Context Protocol (MCP) Documentation](https://modelcontextprotocol.io/)
- [Transformer Architecture Explained](https://arxiv.org/abs/1706.03762)
- [Best Practices for AI-Assisted Development](https://github.com/microsoft/AI-For-Beginners)

## 👤 About the Speaker

**Adam Twardoch** is an experienced software developer with extensive experience in typography, font technology, and AI-assisted development. His portfolio includes 177+ repositories showcasing practical applications of LLM tools in real-world projects.

- **Email:** adam@twardoch.com
- **Website:** [twardoch.com](https://twardoch.com)
- **GitHub:** [@twardoch](https://github.com/twardoch)
- **Twitter:** [@adamtwar](https://twitter.com/adamtwar)

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/twardoch/twardoch-is-coding/issues).

---

*"The future of coding is collaborative—human creativity + AI capabilities"*

