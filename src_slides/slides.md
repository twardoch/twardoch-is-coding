---
# this_file: src_slides/slides.md
marp: true
theme: custom-tech
class: 
  - lead
  - invert
paginate: true
backgroundColor: #1e1e1e
color: #ffffff
---

<!-- _class: title -->

# Coding with LLMs
## Tools and Techniques for Modern Development

**Adam Twardoch**  
*Conference Talk - 20 minutes*

---

<!-- _class: agenda -->

# Agenda

1. **How LLMs Actually Work** *(5 min)*
2. **IDE vs CLI: Two Paradigms** *(6 min)*  
3. **The MCP Revolution** *(6 min)*
4. **My Coding Journey with LLMs** *(3 min)*

*Focus: Practical insights for experienced developers*

---

<!-- _class: section-divider -->

# Section 1
## How LLMs Actually Work
*Making transformer architecture accessible*

---

<!-- _class: content -->

# The LLM Pipeline

```mermaid
graph LR
    A[Text Input] --> B[Tokenization]
    B --> C[Embeddings]
    C --> D[Transformer Layers]
    D --> E[Attention Mechanism]
    E --> F[Output Layer]
    F --> G[Text Output]
    
    style A fill:#e1f5fe
    style G fill:#e8f5e8
    style D fill:#fff3e0
    style E fill:#fce4ec
```

**Core Flow:** Text → Numbers → Vectors → Processing → Text

*No magic, just sophisticated pattern matching*

---

<!-- _class: content -->

# 1. Tokenization
## Text → Numbers

```python
# Example tokenization
text = "The cat sat on the mat"
tokens = [1034, 717, 423, 891, 1034, 2341]
```

- **Words/subwords** become unique integers
- **Vocabulary** maps tokens to IDs
- **Foundation** for all neural processing

---

<!-- _class: content -->

# 2. Embeddings
## Tokens → Vectors

```python
# Token 1034 ("the") becomes vector
embedding = [0.1, -0.3, 0.8, 0.2, ...]  # 768+ dimensions
```

- **Semantic similarity** in vector space
- **Related concepts** have similar embeddings
- **Context-independent** base representation

---

<!-- _class: content -->

# 3. Transformer Architecture
## The Processing Engine

```mermaid
graph TB
    subgraph "Transformer Block"
        A[Input Embeddings] --> B[Multi-Head Attention]
        B --> C[Add & Norm]
        A --> C
        C --> D[Feed Forward]
        D --> E[Add & Norm]
        C --> E
    end
    
    E --> F[Next Layer]
    
    style B fill:#ffeb3b
    style D fill:#4caf50
    style C fill:#2196f3
    style E fill:#2196f3
```

- **Parallel processing** (vs sequential RNNs)
- **Layer stacking** for complexity
- **Feed-forward networks** refine representations
- **Self-attention** captures relationships

*Key insight: Processes all tokens simultaneously*

---

<!-- _class: content -->

# 4. Attention Mechanism
## Dynamic Context Weighting

- Each token "**looks at**" all other tokens
- Computes **relevance scores** dynamically
- **Weighted combination** creates context-aware output
- Enables **long-range dependencies**

*"The key to understanding context"*

---

<!-- _class: section-divider -->

# Section 2
## IDE vs CLI: Two Paradigms
*When and why to use different approaches*

---

<!-- _class: comparison -->

# IDE-Based Tools
## VSCode + GitHub Copilot, Cursor

**Strengths:**
- ✅ **Real-time** inline suggestions
- ✅ **Immediate** feedback loop
- ✅ **File-focused** context
- ✅ **Low learning curve**

**Use for:** Quick edits, exploration, prototyping

---

<!-- _class: comparison -->

# Cursor Advantages
## Beyond VSCode + Copilot

- **Codebase-wide context** understanding
- **.cursorrules files** for project-specific guidance
- **Built-in AI chat** with project awareness
- **AI-powered refactoring** with multi-file scope

*"AI-first editor, not just AI-enhanced"*

---

<!-- _class: comparison -->

# CLI-Based Tools
## Claude Code, Gemini CLI

**Strengths:**
- ✅ **Project-wide** understanding
- ✅ **Agentic behavior** (plan → execute)
- ✅ **Automation** capabilities
- ✅ **MCP integration** for tools

**Use for:** Complex tasks, automation, scripting

---

<!-- _class: comparison-table -->

# IDE vs CLI Paradigms

```mermaid
graph TB
    subgraph "IDE-Based Tools"
        A1[VSCode + Copilot] --> A2[Real-time Suggestions]
        A3[Cursor] --> A4[Codebase Context]
        A2 --> A5[File-level Focus]
        A4 --> A5
    end
    
    subgraph "CLI-Based Tools"
        B1[Claude Code] --> B2[Agentic Behavior]
        B3[Gemini CLI] --> B4[Project-wide Context]
        B2 --> B5[Multi-step Tasks]
        B4 --> B5
    end
    
    A5 -.-> C[Strategic Combination]
    B5 -.-> C
    
    style A5 fill:#e3f2fd
    style B5 fill:#f3e5f5
    style C fill:#e8f5e8
```

---

<!-- _class: section-divider -->

# Section 3
## The MCP Revolution
*Beyond simple completion APIs*

---

<!-- _class: content -->

# MCP Architecture

```mermaid
graph TB
    subgraph "AI Agent"
        A[LLM Core]
        B[MCP Client]
        A --> B
    end
    
    subgraph "Transport Layer"
        C[JSON-RPC]
        D[HTTP/stdio]
        C --> D
    end
    
    subgraph "MCP Servers"
        E[File System]
        F[Git Operations]
        G[Database]
        H[Web APIs]
        I[Custom Tools]
    end
    
    B --> C
    D --> E
    D --> F
    D --> G
    D --> H
    D --> I
    
    style A fill:#ffeb3b
    style C fill:#2196f3
    style E fill:#4caf50
    style F fill:#4caf50
    style G fill:#4caf50
    style H fill:#4caf50
    style I fill:#4caf50
```

*Universal protocol enabling true AI automation*

---

<!-- _class: comparison -->

# Simple vs Agentic APIs

```mermaid
graph TB
    subgraph "Simple APIs"
        A1[User Prompt] --> A2[LLM Processing]
        A2 --> A3[Text Response]
    end
    
    subgraph "Agentic APIs (MCP)"
        B1[User Request] --> B2[Planning]
        B2 --> B3[Tool Discovery]
        B3 --> B4[Execution]
        B4 --> B5[Iteration]
        B5 --> B6[Final Result]
        
        B3 -.-> B7[External Tools]
        B4 -.-> B7
        B7 -.-> B4
    end
    
    style A3 fill:#ffcdd2
    style B6 fill:#c8e6c9
    style B7 fill:#fff3e0
```

---

<!-- _class: content -->

# MCP Server Examples

- **File System**: Read, write, search files
- **Git Operations**: Commit, branch, merge automation
- **Database Queries**: SQL execution and analysis
- **Web Scraping**: API calls and data extraction
- **Custom Business Logic**: Domain-specific tools

*Real automation, not just text generation*

---

<!-- _class: content -->

# MCP in Action

```bash
# Claude Code with MCP
claude "Analyze this codebase and suggest improvements"
# → Reads all files
# → Runs static analysis tools  
# → Executes tests
# → Generates comprehensive report
```

*Autonomous execution with human oversight*

---

<!-- _class: section-divider -->

# Section 4
## My Coding Journey with LLMs
*Real-world experience and lessons*

---

<!-- _class: timeline -->

# Tool Evolution Timeline

```mermaid
timeline
    title Development Tool Evolution
    
    Traditional Era
        : Text Editors
        : Manual Documentation
        : Command Line Tools
    
    AI-Assisted Era
        : GitHub Copilot
        : Code Completion
        : Context Awareness
    
    Agentic Era
        : Claude Code
        : MCP Integration
        : Autonomous Workflows
```

*Progressive enhancement of development capabilities*

---

<!-- _class: case-studies -->

# Real Project Examples

## pdf22png
- **42 commits** in 60 days
- **CI/CD pipeline** implementation
- **Automated testing** setup

## claif-packages
- **Multi-package** Python ecosystem
- **50+ commits** per component
- **Comprehensive documentation**

## vttiro
- **100+ Claude Code sessions**
- **Video processing** automation

---

<!-- _class: lessons -->

# Key Lessons Learned

✅ **Combine tools strategically**  
✅ **Always review and test** AI-generated code  
✅ **Use version control** as safety net  
✅ **Security considerations** remain critical  
✅ **Start simple**, scale complexity gradually

*AI amplifies capabilities, doesn't replace judgment*

---

<!-- _class: conclusion -->

# Key Takeaways

1. **LLMs are pattern matchers**, not magic
2. **IDE and CLI tools complement** each other
3. **MCP enables true automation** beyond completion
4. **Strategic combination** maximizes effectiveness
5. **Human oversight** remains essential

---

<!-- _class: resources -->

# Resources & Next Steps

📚 **Documentation**: [twardoch.github.io/twardoch-is-coding](https://twardoch.github.io/twardoch-is-coding)  
🛠️ **Tools**: Claude Code, Cursor, Gemini CLI  
📧 **Contact**: adam@twardoch.com  
🐙 **Code**: [github.com/twardoch/twardoch-is-coding](https://github.com/twardoch/twardoch-is-coding)

---

<!-- _class: thank-you -->

# Thank You!
## Questions?

*"The future of coding is collaborative—*  
*human creativity + AI capabilities"*

**Adam Twardoch**  
*adam@twardoch.com*