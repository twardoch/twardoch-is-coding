# this_file: src_slides/assets/visual-assets.md

# Visual Assets for Conference Talk

This document contains the Mermaid diagrams and visual specifications for the "Coding with LLMs" presentation.

## Mermaid Diagrams

### 1. LLM Processing Pipeline
**Topic:** Complete flow from text input to text output
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

### 2. Transformer Architecture Detail
**Topic:** Internal structure of transformer layers
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

### 3. IDE vs CLI Paradigm Comparison
**Topic:** Two different development approaches
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

### 4. MCP Architecture
**Topic:** Model Context Protocol ecosystem
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

### 5. Simple vs Agentic APIs
**Topic:** Evolution from completion to action
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

### 6. Development Workflow Evolution
**Topic:** Timeline of coding tool progression
```mermaid
timeline
    title Coding Tool Evolution
    
    Traditional Era
        : Text Editors
        : Manual Documentation
        : Command Line Tools
    
    IDE Era
        : Integrated Environments
        : Syntax Highlighting
        : Debugging Integration
    
    AI-Assisted Era
        : GitHub Copilot
        : Code Completion
        : Context Awareness
    
    Agentic Era
        : Claude Code
        : MCP Integration
        : Autonomous Workflows
```

### 7. Tool Selection Decision Tree
**Topic:** When to use which AI coding tool
```mermaid
graph TD
    A[Coding Task] --> B{Task Scope?}
    
    B -->|Single File| C[IDE Tools]
    B -->|Multi-File| D[CLI Tools]
    B -->|Project-wide| D
    
    C --> E{Need Speed?}
    E -->|Yes| F[GitHub Copilot]
    E -->|Context Important| G[Cursor]
    
    D --> H{Task Complexity?}
    H -->|Simple Automation| I[Claude Code]
    H -->|Research Needed| J[Gemini CLI]
    H -->|Multi-step Workflow| I
    
    style F fill:#e3f2fd
    style G fill:#e8f5e8
    style I fill:#fff3e0
    style J fill:#fce4ec
```

### 8. Real Project Examples
**Topic:** Adam's portfolio project analysis
```mermaid
graph LR
    subgraph "Project Portfolio"
        A[177 Repositories]
        B[54 .specstory Projects]
        C[1000+ Claude Sessions]
    end
    
    subgraph "Key Projects"
        D[pdf22png<br/>42 commits]
        E[claif-packages<br/>50+ each]
        F[vttiro<br/>100+ sessions]
        G[boabro<br/>Web app]
    end
    
    A --> D
    B --> G
    C --> F
    C --> E
    
    subgraph "Tool Usage"
        H[Cursor: Prototyping]
        I[Claude Code: Implementation]
        J[Gemini CLI: Research]
    end
    
    D --> I
    E --> I
    F --> I
    G --> H
    
    style D fill:#e3f2fd
    style E fill:#e8f5e8
    style F fill:#fff3e0
    style G fill:#fce4ec
```

## Usage in Slides

Embed Mermaid diagrams in slides using:

```markdown
```mermaid
graph LR
    A[Text] --> B[Tokens]
    B --> C[Embeddings]
```
```

## Usage in Documentation

For MkDocs, Mermaid is supported through pymdownx.superfences:

```markdown
```mermaid
graph TB
    A --> B
```
```

## Diagram Specifications

- **Format:** Mermaid syntax (text-based)
- **Rendering:** Native support in modern browsers and documentation tools
- **Style:** Clean, professional color schemes
- **Accessibility:** Screen reader compatible with proper alt text
- **Maintenance:** Version controlled and easily editable

## Color Scheme

- **Primary Blue:** #2196f3
- **Success Green:** #4caf50
- **Warning Orange:** #ff9800
- **Accent Purple:** #9c27b0
- **Light Backgrounds:** #f5f5f5
- **Text:** #333333

## Alternative Formats

If Mermaid needs alternatives:

1. **PlantUML** - For complex UML diagrams
2. **Graphviz/DOT** - For network diagrams
3. **D3.js** - For interactive visualizations
4. **Custom SVG** - For precise technical illustrations

## Accessibility

All images should include:
- Descriptive alt text
- High contrast for visibility
- Clear labeling of components
- Support for screen readers