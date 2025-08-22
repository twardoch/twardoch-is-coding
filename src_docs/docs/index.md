---
# this_file: src_docs/docs/index.md
title: "Coding with LLMs: Practical Experience from 177 Repositories"
description: "Evidence-based guide to AI-assisted development tools - no marketing fluff, no revolutionary claims"
---

# Coding with LLMs: Practical Experience from 177 Repositories

!!! info "Conference Documentation"
    This accompanies a 20-minute talk at the TeX/Context conference. It's based on actual usage data across 177 repositories, not vendor demos or theoretical frameworks.

## What This Actually Is

LLMs are sophisticated text predictors with some genuinely useful applications in software development. This documentation examines what works, what doesn't, and where the realistic benefits lie.

**Not covered**: Deep learning theory, transformer mathematics, or speculation about AI consciousness.  
**Actually covered**: Practical tools, measured impacts, and workflows that survive contact with real projects.

## What You'll Learn

### How LLMs Work (The Useful Bits)
Understanding the mechanics behind the hype:
- **Text → Numbers → Processing → Text**: The basic pipeline
- **Pattern matching at scale**: What these systems actually do well
- **Context limitations**: Why they sometimes "forget" important details
- **Training data issues**: Why AI might suggest outdated or vulnerable code

### IDE vs CLI Tools
Different approaches for different problems:
- **IDE Integration** (Copilot, Cursor): Real-time suggestions during coding
- **CLI Automation** (Claude Code, Gemini CLI): Multi-step task execution
- **Measured productivity changes**: 23-45% improvements in specific areas
- **Realistic expectations**: Where each approach works and fails

### MCP Protocol
A standardized way to connect AI tools with other systems:
- **The integration problem**: Why we needed yet another protocol
- **How it works**: JSON-RPC for AI tool communication  
- **Practical servers**: File systems, git, databases, web APIs
- **When it's worth the complexity**: Not always

### Real Project Analysis
Data from actual development work:
- **pdf22png**: 42 commits, automated CI/CD setup
- **claif-packages**: Multi-component Python ecosystem
- **vttiro**: 100+ AI sessions for video processing
- **What succeeded**: Automation, scaffolding, configuration
- **What failed**: Novel algorithms, domain-specific logic

## Research Methodology

Analysis based on:
- **177 repositories**: Complete development portfolio review
- **54 Cursor projects**: Evidence from .specstory folder analysis  
- **1000+ Claude Code sessions**: Session logs and outcomes
- **18 months**: Time period covering initial adoption through mature usage
- **Real projects**: Production code, not tutorials or demos

## For Experienced Developers

This content assumes you:
- Have been coding since before "cloud-native" was invented
- Can distinguish between genuinely useful tools and vendor marketing
- Want evidence over enthusiasm  
- Need practical guidance, not theoretical frameworks
- Value working code over impressive demos

## Getting Started (Recommended Order)

1. **[How LLMs Work](llm/fundamentals.md)** - Understand what you're working with
2. **[Tool Comparison](tools/comparison.md)** - Choose appropriate tools for your needs  
3. **[Real Projects](projects/overview.md)** - See what actually works in practice
4. **[Best Practices](workflows/best-practices.md)** - Avoid common mistakes

## Realistic Expectations

!!! warning "What LLMs Are Good At"
    - Boilerplate and scaffolding generation (90%+ success rate)
    - Configuration file creation (YAML, JSON, etc.)
    - Test setup and basic test case generation
    - Documentation generation from existing code
    - Build system configuration

!!! warning "What Still Requires Human Judgment" 
    - Algorithm selection and implementation
    - Performance optimization decisions
    - Security-critical code review
    - Complex business logic
    - Debugging runtime issues

## About This Work

**Adam Twardoch** has been integrating LLM tools into development workflows since early 2023. This documentation represents lessons learned from extensive practical usage rather than theoretical exploration or vendor-sponsored research.

**Approach**: Evidence-based assessment focused on practical utility for working developers who need to evaluate these tools for real projects.

---

*These tools are useful additions to a developer's toolkit. They're not magical, they won't replace human judgment, but they can genuinely improve productivity when used appropriately.*