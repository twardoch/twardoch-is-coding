# this_file: scratchpad/demo-scenarios.md

# Live Demonstration Scenarios for Conference Talk

## Demo 1: Claude Code - Real Codebase Analysis

### Scenario: "Analyzing an Unknown Python Project"
**Duration**: 3-4 minutes
**Purpose**: Show Claude Code's project-wide understanding capabilities

#### Setup
- Use a moderately complex Python project from Adam's portfolio
- **Suggested project**: `claif-packages/claif_cla` (57 commits, active development)
- Clean terminal with Claude Code available

#### Demonstration Flow
1. **Initial Exploration** (60 seconds)
   ```bash
   claude-code "Analyze this Python project structure and tell me what it does"
   ```
   - Show how Claude Code scans multiple files
   - Highlight project-wide understanding vs single-file analysis

2. **Architecture Analysis** (90 seconds)
   ```bash
   claude-code "Explain the main architecture patterns used here and identify any potential improvements"
   ```
   - Demonstrate code quality assessment
   - Show multi-file dependency analysis

3. **Practical Refactoring** (90 seconds)
   ```bash
   claude-code "Add comprehensive error handling to the main CLI function and update related tests"
   ```
   - Show multi-file changes in action
   - Demonstrate test coordination

#### Key Talking Points
- "Notice how it understands the entire project context"
- "This would take me hours manually - Claude Code does it in seconds"
- "The changes are coordinated across multiple files automatically"

#### Backup Materials
- Screenshots of each step saved as `demo1-step1.png`, `demo1-step2.png`, etc.
- Pre-recorded video of entire demo saved as `demo1-backup.mp4`

---

## Demo 2: Cursor IDE - Rapid Prototyping with .cursorrules

### Scenario: "Building a Quick Font Analysis Tool"
**Duration**: 3-4 minutes  
**Purpose**: Show Cursor's context-aware development within IDE

#### Setup
- Empty VSCode workspace with Cursor extension active
- Pre-configured `.cursorrules` file for font development context
- Font file sample ready (from Adam's font work)

#### Demonstration Flow
1. **Show .cursorrules Configuration** (30 seconds)
   ```markdown
   # .cursorrules
   You are a font technology expert specializing in OpenType features and Python font manipulation.
   
   Context: This project analyzes font files and generates reports.
   - Use fontTools library for font parsing
   - Follow typographic conventions
   - Generate clear, visual output
   - Handle Unicode and glyph naming properly
   ```

2. **Rapid Development** (180 seconds)
   - Create `font_analyzer.py` from scratch
   - Show real-time code generation with Tab completions
   - Demonstrate context-aware suggestions based on .cursorrules

3. **Live Testing** (60 seconds)
   - Run the generated script on a real font file
   - Show immediate feedback and iteration

#### Key Talking Points
- "The .cursorrules file gives Cursor domain-specific knowledge"
- "Notice how suggestions are contextually relevant to font analysis"
- "This is perfect for rapid prototyping and exploration"

#### Backup Materials
- Pre-written `.cursorrules` configurations for different scenarios
- Sample font files and expected outputs
- Screenshots of key development moments

---

## Demo 3: MCP Server Integration - Tool Ecosystem

### Scenario: "Git Operations Through MCP"
**Duration**: 2-3 minutes
**Purpose**: Show MCP protocol enabling LLM-tool integration

#### Setup
- Project with MCP server for git operations configured
- Uncommitted changes ready in repository
- Terminal with MCP-enabled Claude Code

#### Demonstration Flow
1. **Show MCP Configuration** (30 seconds)
   ```json
   {
     "mcpServers": {
       "git": {
         "command": "python",
         "args": ["-m", "mcp_git_server"]
       }
     }
   }
   ```

2. **Demonstrate Tool Integration** (120 seconds)
   ```bash
   claude-code "Analyze the current git status, create a meaningful commit message based on the changes, and commit with proper formatting"
   ```
   - Show how Claude Code uses MCP to:
     - Read git status
     - Analyze file changes
     - Generate commit message
     - Execute git commands

3. **Chained Operations** (60 seconds)
   ```bash
   claude-code "Now create a new branch for the next feature and push the current changes"
   ```

#### Key Talking Points
- "MCP transforms LLMs from text generators to action takers"
- "Notice the seamless integration between analysis and action"
- "This is the future of AI development workflows"

#### Backup Materials
- Pre-configured MCP server setups
- Git repository in known state for demo reset
- Video recording of successful MCP operations

---

## Demo 4: Hybrid Workflow - Best of Both Worlds

### Scenario: "Real Project Development Cycle"
**Duration**: 3-4 minutes
**Purpose**: Show strategic combination of IDE and CLI tools

#### Setup
- Real project needing a new feature
- Both Cursor and Claude Code available
- Clear feature specification ready

#### Demonstration Flow
1. **Planning with Claude Code** (60 seconds)
   ```bash
   claude-code "I need to add a configuration validation feature. Analyze the existing codebase and create a detailed implementation plan"
   ```

2. **Rapid Prototyping with Cursor** (120 seconds)
   - Switch to Cursor IDE
   - Implement basic feature structure with AI assistance
   - Show real-time code generation and iteration

3. **Integration with Claude Code** (90 seconds)
   ```bash
   claude-code "Review the new validation feature I just added and integrate it properly with the existing error handling system and tests"
   ```

4. **Quality Assurance** (30 seconds)
   - Show automated testing and validation
   - Demonstrate coordinated changes across project

#### Key Talking Points
- "I use Cursor for speed and exploration"
- "Claude Code for comprehensive integration and quality"
- "This hybrid approach maximizes productivity"

#### Backup Materials
- Project in specific state for demo start
- Feature specification document
- Screenshots of each tool transition

---

## Technical Requirements and Setup

### Hardware Preparation
- **Laptop**: MacBook with sufficient processing power
- **Display**: 1440p external monitor for clear audience visibility
- **Network**: Reliable high-speed internet connection
- **Backup**: Mobile hotspot for internet redundancy

### Software Setup
- **Claude Code**: Latest version with active subscription
- **Cursor IDE**: Latest version with configured settings
- **Terminal**: iTerm2 with clear, large font (18pt minimum)
- **Screen Recording**: QuickTime Player for backup recordings
- **Demo Timer**: Silent countdown timer for timing control

### Pre-Demo Checklist
- [ ] All tools authenticated and tested
- [ ] Demo repositories in correct initial state
- [ ] Backup materials accessible
- [ ] Internet connectivity verified
- [ ] Screen recording capabilities tested
- [ ] Timer and presentation notes ready

### Recovery Procedures
- **Network Failure**: Switch to pre-recorded demo videos
- **Tool Failure**: Fall back to screenshot walkthroughs with narration
- **Time Overrun**: Skip to hybrid workflow demo (most impressive)
- **Complete Technical Failure**: Switch to slide-only presentation with detailed explanations

### Practice Schedule
- **Week 1**: Individual demo component practice (1 hour daily)
- **Week 2**: Full demo sequence timing (30 minutes daily)
- **Week 3**: Final rehearsal with backup scenarios (45 minutes daily)

---

## Audience Engagement Elements

### Interactive Questions
- "How many of you have used autocomplete tools like GitHub Copilot?" (show of hands)
- "Who has tried having AI analyze an entire codebase?" (gauge experience level)
- "What's your biggest concern about AI code generation?" (address fears)

### Relatable Analogies
- **LLM Processing**: "Like having a research assistant who has read all of Stack Overflow"
- **MCP Protocol**: "Universal remote control for all your development tools"
- **Hybrid Workflow**: "Using the right tool for each part of the job, like a craftsman's toolkit"

### Call to Action
- Provide business cards with contact information
- Offer follow-up resources and documentation links
- Invite questions during coffee break
- Share GitHub repository for hands-on exploration