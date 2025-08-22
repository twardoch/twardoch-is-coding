---
# this_file: src_docs/docs/llm/fundamentals.md
title: "How LLMs Actually Work"
description: "Understanding Large Language Models from text input to text output - accessible explanation for experienced programmers"
---

# How LLMs Actually Work

Large Language Models might seem like magic, but they're actually sophisticated pattern matching systems built on well-understood principles. This guide explains the core concepts without diving into complex mathematics.

## The Big Picture

At its core, an LLM follows a straightforward pipeline:

**Text Input → Tokenization → Embeddings → Transformer → Text Output**

Each step transforms the data in a specific way, ultimately enabling the model to understand context and generate relevant responses.

## 1. Tokenization: Text → Numbers

The first step converts human-readable text into numbers that computers can process.

### How It Works

```python
# Example tokenization
text = "The cat sat on the mat"
tokens = [1034, 717, 423, 891, 1034, 2341]
```

- **Vocabulary**: A fixed mapping from text pieces to unique integers
- **Tokens**: Usually words, subwords, or characters depending on the model
- **Subword tokenization**: Handles rare words by breaking them into smaller pieces

### Why It Matters

- Neural networks can only process numbers, not text
- Token choice affects model performance and capabilities
- Different models use different tokenization strategies

## 2. Embeddings: Tokens → Vectors

Embeddings transform discrete token IDs into high-dimensional vectors that capture semantic meaning.

### The Concept

```python
# Token 1034 ("the") becomes a vector
embedding = [0.1, -0.3, 0.8, 0.2, ...]  # 768+ dimensions
```

- **Vector space**: Similar concepts cluster together
- **Dimensionality**: Typically 768-4096 dimensions
- **Learned representations**: Trained to capture semantic relationships

### Key Properties

- **Semantic similarity**: "cat" and "dog" have similar embeddings
- **Arithmetic properties**: "king" - "man" + "woman" ≈ "queen"
- **Context-independent**: Base embeddings are the same regardless of surrounding text

## 3. Transformer Architecture: The Processing Engine

The transformer is where the real magic happens - it processes all tokens simultaneously while maintaining awareness of relationships between them.

### Core Innovations

**Parallel Processing**
- Unlike RNNs, transformers process all tokens at once
- Enables much faster training and inference
- Scales efficiently to longer sequences

**Layer Stacking**
- Multiple transformer blocks build complexity
- Each layer can learn different patterns
- Typical models have 12-96+ layers

**Feed-Forward Networks**
- Each token is processed independently
- Learns complex feature combinations
- Adds non-linearity to the model

### Why It Works

The transformer architecture enables:
- **Long-range dependencies**: Connecting concepts across long texts
- **Parallel computation**: Faster training on modern hardware
- **Scalability**: Performance improves with more parameters and data

## 4. Attention Mechanism: The Context Engine

Attention is the transformer's key innovation - it allows each token to dynamically focus on relevant parts of the input.

### How Attention Works

For each token, the model:
1. **Looks at all other tokens** in the sequence
2. **Computes relevance scores** for each relationship
3. **Creates weighted combinations** emphasizing important connections
4. **Updates representations** based on relevant context

### Example in Action

In "The programmer used Claude Code to analyze **her** codebase":
- "her" attends strongly to "programmer"
- "analyze" attends to both "Claude Code" and "codebase"
- "Claude Code" attends to "used" and "analyze"

### Types of Attention

**Self-Attention**
- Tokens attend to other tokens in the same sequence
- Captures relationships within the input
- Foundation of transformer architecture

**Multi-Head Attention**
- Multiple attention mechanisms in parallel
- Each "head" learns different types of relationships
- Combines diverse attention patterns

## Putting It All Together

### The Complete Flow

1. **Input**: "Explain how transformers work"
2. **Tokenization**: [1567, 2984, 3847, 6721]
3. **Embeddings**: Each token becomes a 768-dimensional vector
4. **Positional Encoding**: Add position information to embeddings
5. **Transformer Layers**: 
   - Self-attention finds relevant relationships
   - Feed-forward networks process features
   - Repeat 12-96+ times
6. **Output Layer**: Convert final representations to probability distribution over vocabulary
7. **Decoding**: Sample or select most likely next token
8. **Iteration**: Feed output back as input for next token

### Key Insights

**Pattern Matching at Scale**
- LLMs learn statistical patterns from massive datasets
- Quality emerges from quantity and sophisticated architecture
- No explicit programming of knowledge or rules

**Context is Everything**
- Attention mechanism enables dynamic context understanding
- Same token can have different meanings in different contexts
- Context window limits how much the model can "remember"

**Emergent Capabilities**
- Complex behaviors arise from simple mechanisms
- Scaling up parameters and data reveals new capabilities
- Training objectives shape model behavior

## Practical Implications

### For Developers

Understanding LLMs helps with:
- **Better prompting**: Know how context and attention work
- **Managing expectations**: Understand capabilities and limitations
- **Debugging issues**: Recognize when problems stem from tokenization or context
- **Performance optimization**: Understand computational requirements

### Common Misconceptions

**"LLMs are databases"**
- Actually: Statistical models that learned patterns from data
- Don't store facts, generate plausible continuations

**"LLMs understand meaning"**
- Actually: Process statistical relationships between tokens
- No consciousness or true comprehension

**"LLMs are deterministic"**
- Actually: Generate probability distributions, sampling introduces randomness
- Temperature and other parameters affect output variety

## Next Steps

Now that you understand the fundamentals:

1. **Explore [Development Tools](../tools/paradigms.md)** to see how these concepts apply to coding assistants
2. **Learn about [MCP Protocol](../mcp/introduction.md)** to understand how LLMs interact with external tools
3. **Study [Real Projects](../projects/overview.md)** to see LLMs in action

---

*Remember: LLMs are powerful pattern matching systems, not magical intelligence. Understanding their mechanics helps you use them more effectively.*