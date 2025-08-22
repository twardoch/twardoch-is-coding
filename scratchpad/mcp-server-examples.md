# this_file: scratchpad/mcp-server-examples.md

# MCP Server Examples and Configurations

## Understanding MCP (Model Context Protocol)

MCP enables LLMs to interact with external tools and services through a standardized JSON-RPC 2.0 interface. This transforms LLMs from text generators into action-taking agents.

## Example 1: Git Operations MCP Server

### Configuration
```json
{
  "mcpServers": {
    "git": {
      "command": "python",
      "args": ["-m", "mcp_git"],
      "env": {
        "GIT_SAFE_DIRECTORY": "*"
      }
    }
  }
}
```

### Capabilities Demonstrated
- **git_status**: Get current repository status
- **git_commit**: Create commits with generated messages
- **git_branch**: Manage branches and checkouts
- **git_log**: Analyze commit history
- **git_diff**: Compare changes between commits

### Live Demo Commands
```bash
# Comprehensive git workflow
claude-code "Analyze the current changes, create a meaningful commit message following conventional commit format, commit the changes, and create a new feature branch for the next development cycle"

# Automated code review
claude-code "Review the last 3 commits, identify any patterns or issues, and suggest improvements for the next development iteration"
```

### Real-World Impact
- Automates repetitive git operations
- Generates contextually appropriate commit messages
- Manages branching strategies automatically
- Provides intelligent code review assistance

---

## Example 2: File System Operations MCP Server

### Configuration
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path/to/allowed/directory"]
    }
  }
}
```

### Capabilities Demonstrated
- **read_file**: Read and analyze file contents
- **write_file**: Create and modify files
- **list_directory**: Navigate project structure
- **search_files**: Find files matching patterns
- **file_info**: Get metadata and statistics

### Live Demo Commands
```bash
# Project-wide refactoring
claude-code "Find all Python files using the deprecated 'requests' library, update them to use 'httpx' instead, and ensure all error handling is updated appropriately"

# Documentation generation
claude-code "Scan all source files, extract function signatures and docstrings, and generate a comprehensive API documentation file"
```

### Security Considerations
- Restricted to specific directory paths
- Read-only vs read-write permissions
- File type filtering and validation
- Audit logging for all operations

---

## Example 3: Database Query MCP Server

### Configuration
```json
{
  "mcpServers": {
    "postgres": {
      "command": "python",
      "args": ["-m", "mcp_postgres"],
      "env": {
        "DATABASE_URL": "postgresql://user:pass@localhost/dbname"
      }
    }
  }
}
```

### Capabilities Demonstrated
- **execute_query**: Run SQL queries safely
- **describe_schema**: Analyze database structure
- **explain_query**: Optimize query performance
- **backup_table**: Create data backups

### Live Demo Commands
```bash
# Database analysis and optimization
claude-code "Analyze the database schema, identify potential performance bottlenecks, and suggest index improvements for the most frequently accessed tables"

# Data quality assessment
claude-code "Check for data inconsistencies, duplicate records, and referential integrity issues across all tables, then generate a data quality report"
```

### Safety Features
- Query validation and sanitization
- Read-only query restrictions
- Transaction rollback capabilities
- Connection pooling and timeouts

---

## Example 4: Web Scraping and API MCP Server

### Configuration
```json
{
  "mcpServers": {
    "web": {
      "command": "python",
      "args": ["-m", "mcp_web_scraper"],
      "env": {
        "USER_AGENT": "MCP-Bot/1.0",
        "RATE_LIMIT": "1000"
      }
    }
  }
}
```

### Capabilities Demonstrated
- **fetch_url**: Retrieve web content
- **scrape_data**: Extract structured data
- **api_call**: Interact with REST APIs
- **monitor_changes**: Track content updates

### Live Demo Commands
```bash
# Competitive analysis
claude-code "Monitor the documentation pages of our top 3 competitors, extract their latest feature announcements, and create a comparison report"

# API integration
claude-code "Test our API endpoints against the latest OpenAPI specification, validate all responses, and generate an integration status report"
```

### Ethical Guidelines
- Respect robots.txt files
- Implement proper rate limiting
- Cache responses appropriately
- Handle errors gracefully

---

## Example 5: Development Tools MCP Server

### Configuration
```json
{
  "mcpServers": {
    "devtools": {
      "command": "python",
      "args": ["-m", "mcp_devtools"],
      "cwd": "/project/root"
    }
  }
}
```

### Capabilities Demonstrated
- **run_tests**: Execute test suites
- **lint_code**: Code quality analysis
- **build_project**: Compilation and packaging
- **deploy_application**: Deployment automation

### Live Demo Commands
```bash
# Comprehensive quality check
claude-code "Run the full test suite, analyze code quality metrics, check for security vulnerabilities, and generate a comprehensive quality report with specific improvement recommendations"

# Automated deployment
claude-code "Validate the current build, run all quality checks, update version numbers, create a release package, and deploy to staging environment with rollback plan"
```

### Integration Benefits
- Streamlined development workflows
- Automated quality assurance
- Consistent deployment procedures
- Comprehensive reporting

---

## Setting Up Custom MCP Servers

### Basic Python MCP Server Template
```python
#!/usr/bin/env python3
# this_file: scripts/mcp_example_server.py

import asyncio
import json
from mcp import ClientSession, StdioServerParameters
from mcp.server import Server
from mcp.server.models import InitializationOptions
import mcp.server.stdio
import mcp.types as types

# Server instance
server = Server("example-server")

@server.list_tools()
async def handle_list_tools() -> list[types.Tool]:
    """List available tools."""
    return [
        types.Tool(
            name="example_tool",
            description="An example tool that demonstrates MCP functionality",
            inputSchema={
                "type": "object",
                "properties": {
                    "query": {
                        "type": "string",
                        "description": "The query to process"
                    }
                },
                "required": ["query"]
            }
        )
    ]

@server.call_tool()
async def handle_call_tool(
    name: str, arguments: dict | None
) -> list[types.TextContent]:
    """Handle tool execution."""
    if name == "example_tool":
        query = arguments.get("query", "") if arguments else ""
        result = f"Processed query: {query}"
        return [types.TextContent(type="text", text=result)]
    else:
        raise ValueError(f"Unknown tool: {name}")

async def main():
    """Main server entry point."""
    async with mcp.server.stdio.stdio_server() as (read_stream, write_stream):
        await server.run(
            read_stream,
            write_stream,
            InitializationOptions(
                server_name="example-server",
                server_version="0.1.0",
                capabilities=server.get_capabilities(
                    notification_options=None,
                    experimental_capabilities=None
                )
            )
        )

if __name__ == "__main__":
    asyncio.run(main())
```

### Configuration for Custom Server
```json
{
  "mcpServers": {
    "example": {
      "command": "python",
      "args": ["scripts/mcp_example_server.py"]
    }
  }
}
```

---

## Production MCP Server Examples

### 1. GitHub Integration Server
```bash
# Repository management
claude-code "Create a new repository for the project, set up branch protection rules, configure GitHub Actions for CI/CD, and create issue templates"

# Code review automation
claude-code "Review all open pull requests, analyze code quality, run automated tests, and provide comprehensive review comments"
```

### 2. Cloud Infrastructure Server
```bash
# Infrastructure provisioning
claude-code "Deploy a new development environment on AWS with proper security groups, load balancing, and monitoring setup"

# Cost optimization
claude-code "Analyze current cloud usage, identify cost optimization opportunities, and implement resource rightsizing recommendations"
```

### 3. Monitoring and Alerting Server
```bash
# System health analysis
claude-code "Check all service health metrics, identify performance bottlenecks, and create alerts for critical thresholds"

# Incident response
claude-code "Analyze the recent system outage, create a detailed incident report, and implement preventive measures"
```

---

## Best Practices for MCP Integration

### Security Considerations
- **Principle of Least Privilege**: Grant minimal necessary permissions
- **Input Validation**: Sanitize all user inputs and parameters
- **Audit Logging**: Track all operations for security monitoring
- **Rate Limiting**: Prevent abuse and resource exhaustion
- **Secure Communication**: Use HTTPS and proper authentication

### Performance Optimization
- **Connection Pooling**: Reuse connections for efficiency
- **Caching**: Store frequently accessed data temporarily
- **Async Operations**: Use non-blocking operations where possible
- **Timeout Handling**: Implement proper timeout mechanisms
- **Resource Management**: Clean up resources properly

### Error Handling
- **Graceful Degradation**: Continue operation when possible
- **Clear Error Messages**: Provide actionable error information
- **Retry Logic**: Implement intelligent retry mechanisms
- **Fallback Strategies**: Provide alternative approaches
- **User Feedback**: Keep users informed of operation status

### Testing and Validation
- **Unit Tests**: Test individual MCP server functions
- **Integration Tests**: Validate full workflow scenarios
- **Performance Tests**: Ensure acceptable response times
- **Security Tests**: Validate access controls and data protection
- **User Acceptance Tests**: Verify real-world usage scenarios

---

## Future of MCP Development

### Emerging Patterns
- **Multi-Modal Integration**: Handling text, images, and audio
- **Real-Time Collaboration**: Shared contexts across team members
- **Intelligent Routing**: Automatic tool selection and chaining
- **Context Preservation**: Maintaining state across sessions
- **Cross-Platform Integration**: Unified interfaces across tools

### Industry Impact
- **Democratized Automation**: Making complex workflows accessible
- **Reduced Integration Complexity**: Standardized interfaces
- **Enhanced Productivity**: Seamless tool interoperability
- **New Business Models**: AI-powered service ecosystems
- **Accelerated Innovation**: Faster development and deployment cycles