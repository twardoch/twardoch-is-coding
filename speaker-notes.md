---
# this_file: speaker-notes.md
---

# Speaker Notes: "Coding with LLMs: Tools and Techniques for Modern Development"
**Duration:** 20 minutes + Q&A  
**Audience:** TeX and Context developers (experienced programmers, 50+ years old)

---

## 🎯 **Opening - Establish Credibility** *(1 minute)*

### Key Message
*"I'm not here to theorize - I'm here to share what actually works from 177 real projects"*

### Talking Points
- **Hook**: "Over the past 18 months, I've used AI coding tools across 177 repositories"
- **Evidence**: "54 projects with Cursor, 1000+ Claude Code sessions, real production results"
- **Promise**: "Today I'll show you exactly what works, what doesn't, and when to use each tool"

### **TIMING CUE: 1 minute - Move to Section 1**

---

## 📊 **Section 1: How LLMs Actually Work** *(5 minutes total)*

### Opening Hook *(30 seconds)*
*"Before we talk tools, let's demystify what's under the hood - no PhD required"*

### **Slide: The LLM Pipeline** *(1 minute)*
- **Key Point**: "It's just sophisticated pattern matching - Text → Numbers → Processing → Text"
- **Emphasis**: "No magic, just math we don't need to understand to use effectively"

### **Slide: Tokenization** *(1 minute)*
- **Demo Concept**: "Your code becomes numbers: `function calculateSum` becomes `[1034, 717, 2341]`"
- **Key Insight**: "Different models tokenize differently - that's why some understand code better"
- **Practical**: "Cursor is optimized for code tokenization, Claude Code for project context"

### **Slide: Embeddings** *(1 minute)*
- **Analogy**: "Think of it as a 768-dimensional filing system where similar concepts cluster together"
- **Example**: "`cat` and `dog` are neighbors, but `car` lives in a different neighborhood"
- **Practical**: "This is why LLMs can suggest relevant functions and patterns"

### **Slide: Transformer Architecture** *(1 minute)*
- **Key Innovation**: "Parallel processing - it sees all your code at once, not line by line"
- **Advantage**: "That's why it can refactor across multiple files consistently"
- **Contrast**: "Unlike search-and-replace, it understands relationships"

### **Slide: Attention Mechanism** *(30 seconds)*
- **Simple Explanation**: "Each word asks 'who should I pay attention to?'"
- **Code Example**: "In `her laptop`, 'her' pays attention to 'programmer' from earlier context"
- **Power**: "This is why it can maintain context across thousands of lines"

### **TIMING CUE: 6 minutes total - Move to Section 2**

---

## ⚔️ **Section 2: IDE vs CLI - Two Paradigms** *(6 minutes total)*

### Transition *(15 seconds)*
*"Now that you understand the engine, let's talk about the vehicles"*

### **Slide: IDE-Based Tools** *(1.5 minutes)*
- **Strengths**: "Real-time, immediate, low learning curve"
- **Best for**: "Rapid prototyping, learning new APIs, quick fixes"
- **Example**: "GitHub Copilot excels at `// create user model` → instant implementation"
- **Limitation**: "File-focused, limited project understanding"

### **Slide: Cursor Advantages** *(1.5 minutes)*
- **Key Differentiator**: "AI-first editor, not just AI-enhanced VSCode"
- **Demo Setup**: "Show .cursorrules file example"
- **Read Example**: "TypeScript + React functional components + JSDoc comments"
- **Power**: "Project-wide context, not just current file"

### **Slide: CLI-Based Tools** *(1.5 minutes)*
- **Strengths**: "Project-wide understanding, multi-step execution, automation"
- **Best for**: "Complex refactoring, comprehensive implementations, system-wide changes"
- **Example**: "Claude Code: single command implements auth system with tests and docs"
- **Key Insight**: "Planning then executing vs. suggesting then you executing"

### **Slide: Comparison Table** *(1 minute)*
- **Speed**: "IDE for immediate feedback, CLI for comprehensive solutions"
- **Scope**: "IDE for file-level, CLI for project-level"
- **Automation**: "IDE for assistance, CLI for autonomous execution"

### **Strategic Insight** *(30 seconds)*
*"The secret isn't choosing one - it's knowing when to use each"*

### **TIMING CUE: 12 minutes total - Move to Section 3**

---

## 🔌 **Section 3: The MCP Revolution** *(6 minutes total)*

### Transition *(15 seconds)*
*"This is where AI stops being a text generator and becomes a true development partner"*

### **Slide: MCP Architecture** *(1.5 minutes)*
- **Problem**: "Traditional AI: prompt → response. Limited to training data."
- **Solution**: "MCP: prompt → planning → tool usage → execution → result"
- **Key Point**: "AI can now read files, run tests, commit code, deploy applications"

### **Slide: Simple vs Agentic APIs** *(1.5 minutes)*
- **Old Way**: "You ask, it answers, you implement"
- **New Way**: "You ask, it plans, discovers tools, executes, reports back"
- **Analogy**: "From asking directions to having a copilot who can actually drive"

### **Slide: MCP Server Examples** *(1 minute)*
- **File System**: "Read, write, organize files"
- **Git Operations**: "Analyze history, create commits, manage branches"
- **Database**: "Query, analyze, optimize schemas"
- **Custom Tools**: "Your domain-specific operations"

### **Slide: MCP in Action** *(1.5 minutes)*
- **Real Example**: "claude 'analyze codebase and suggest improvements'"
- **Behind the scenes**: "Reads all files → runs static analysis → executes tests → generates report"
- **From pdf22png project**: "42 commits, complete CI/CD pipeline, comprehensive testing"
- **Key Insight**: "Hours of work in minutes, but with professional quality"

### **Future Vision** *(30 seconds)*
*"This isn't just about coding faster - it's about coding at a higher level of abstraction"*

### **TIMING CUE: 18 minutes total - Move to Section 4**

---

## 🚀 **Section 4: My Coding Journey with LLMs** *(3 minutes total)*

### Personal Story *(1 minute)*
- **Timeline**: "Traditional tools → GitHub Copilot → Cursor → Claude Code → MCP integration"
- **Evolution**: "From assistance to collaboration to orchestration"
- **Metric**: "177 repositories, 54 with Cursor usage, 1000+ Claude Code sessions"

### **Slide: Real Project Examples** *(1.5 minutes)*
- **pdf22png**: "42 commits in 60 days, complete CI/CD pipeline - Claude Code systematic approach"
- **claif-packages**: "5-package ecosystem, 250+ commits, unified standards - mixed approach coordination"
- **vttiro**: "100+ sessions, complex video processing - CLI for complexity management"

### **Slide: Key Lessons Learned** *(30 seconds)*
- **Strategic Combination**: "Cursor for exploration, Claude Code for implementation"
- **Quality Control**: "AI amplifies both good and bad practices - review everything"
- **Version Control**: "Your safety net when AI suggests bold changes"
- **Security First**: "Never trust, always verify"
- **Start Simple**: "MVP first, complexity later"

### **Evidence-Based Insight**: 
*"From 177 repositories analysis: 54 projects used Cursor, 1000+ sessions with Claude Code - this isn't theory, it's production reality"*

### **TIMING CUE: 21 minutes total - Conclusion**

---

## 🎓 **Conclusion & Key Takeaways** *(30 seconds)*

### **5 Core Insights**
1. **"LLMs are pattern matchers, not magic"** - Understanding helps you use them better
2. **"IDE and CLI tools complement each other"** - Strategic combination is key
3. **"MCP enables true automation"** - Beyond completion to autonomous execution
4. **"Strategic tool combination maximizes effectiveness"** - Right tool for right task
5. **"Human oversight remains essential"** - AI amplifies judgment, doesn't replace it

### **Final Message**
*"The future of coding isn't human vs AI - it's human creativity amplified by AI capabilities"*

### **TIMING CUE: 21.5 minutes total - Q&A**

---

## 🎤 **Q&A Preparation**

### **Anticipated Questions & Responses**

**Q: "What about job security for developers?"**
**A:** "These tools make us more productive, not obsolete. I'm shipping 10x more features, handling more complex projects. The demand for experienced developers who can orchestrate AI tools is actually increasing."

**Q: "How do you ensure code quality with AI assistance?"**
**A:** "Same way you ensure quality with junior developers - comprehensive testing, code reviews, and established standards. The .cursorrules file and systematic prompting become your quality gates."

**Q: "What about learning curve for older developers?"**
**A:** "Start with Cursor for familiar IDE experience, then gradually add Claude Code for complex tasks. The key is strategic adoption, not wholesale replacement of your workflow."

**Q: "Which tool should I start with?"**
**A:** "Cursor if you're coming from VSCode and want immediate benefits. Claude Code if you prefer command-line tools and want project-wide capabilities. Both if you want maximum effectiveness."

**Q: "How do you handle AI-generated bugs?"**
**A:** "Same way you handle human-generated bugs - good testing practices, version control, and systematic debugging. AI bugs are often more consistent and predictable than human bugs."

**Q: "What about costs?"**
**A:** "Cursor is $20/month, Claude Code usage-based. But consider the productivity gain - if these tools save you 10 hours a month, they pay for themselves many times over."

---

## ⏱️ **Timing Management**

### **Section Time Allocation**
- **Opening**: 1 minute (1 min total)
- **Section 1**: 5 minutes (6 min total)
- **Section 2**: 6 minutes (12 min total)  
- **Section 3**: 6 minutes (18 min total)
- **Section 4**: 3 minutes (21 min total)
- **Conclusion**: 30 seconds (21.5 min total)
- **Buffer**: 30 seconds for transitions

### **Time Monitoring Cues**
- **5-minute mark**: Should be finishing LLM fundamentals
- **10-minute mark**: Should be in tool comparison section
- **15-minute mark**: Should be starting MCP section
- **18-minute mark**: Should be starting personal journey
- **20-minute mark**: Should be concluding

### **If Running Over Time**
- **Cut**: Detailed attention mechanism explanation (save 1 min)
- **Cut**: Extended MCP server examples (save 1 min)  
- **Shorten**: Personal project details (save 1 min)

### **If Running Under Time**
- **Add**: Live demo of .cursorrules configuration
- **Add**: More detailed MCP architecture explanation
- **Add**: Additional real project metrics

---

## 🎯 **Key Success Factors**

### **Confidence Builders**
- **Real Data**: "177 repositories, 54 Cursor projects, 1000+ Claude Code sessions"
- **Production Results**: "pdf22png: 42 commits in 60 days with professional CI/CD"
- **Specific Examples**: Always cite actual project experiences

### **Audience Connection**
- **Respect Experience**: "You've been coding longer than these tools have existed"
- **Practical Focus**: "What actually works vs. what sounds impressive"
- **No Hype**: "This is about improving your existing workflow, not replacing it"

### **Technical Credibility**
- **Architecture Understanding**: Show you understand both tools and underlying technology
- **Real Limitations**: "AI makes mistakes, has context limits, needs human oversight"
- **Evidence-Based**: Every claim backed by actual development experience

---

## 🛡️ **Backup Plans**

### **If Technology Fails**
- **Slides don't load**: Have PDF backup on desktop
- **Demos don't work**: Pre-recorded screenshots ready
- **Internet fails**: All examples work offline

### **If Questions Are Hostile**
- **Stay Evidence-Based**: Return to actual project results
- **Acknowledge Concerns**: "Valid concern, here's what I've learned..."
- **Stay Practical**: "Let's focus on what helps you ship better code"

### **If Running Short on Time**
- **Priority 1**: Ensure all 4 main sections covered
- **Priority 2**: Strong conclusion with key takeaways
- **Priority 3**: Buffer time for questions

---

## 📞 **Post-Presentation Follow-up**

### **Documentation Links Ready**
- **Repository**: https://github.com/twardoch/twardoch-is-coding
- **Documentation Site**: https://twardoch.github.io/twardoch-is-coding
- **Email Contact**: adam@twardoch.com

### **Expected Follow-up Questions**
- **Tool-specific guidance** for their particular development stack
- **Implementation advice** for team adoption
- **Specific workflow** recommendations

---

*These notes are designed to be glanced at during presentation for timing and key points. The goal is natural delivery backed by concrete data and real experience.*