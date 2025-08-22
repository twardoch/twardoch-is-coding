---
# this_file: src_docs/docs/workflows/best-practices.md
title: "LLM-Assisted Development Workflows"
description: "Best practices and proven workflows for integrating LLM tools into software development"
---

# LLM-Assisted Development Workflows

This guide presents proven workflows for integrating LLM tools into software development, based on analysis of 177 real projects and thousands of development sessions.

## Overview of Hybrid Development

Modern LLM-assisted development isn't about replacing human developers—it's about strategic amplification of human capabilities through intelligent tool combination.

### The Three-Tool Strategy

**Research Phase**: Gemini CLI for exploration and analysis  
**Development Phase**: Cursor for rapid iteration, Claude Code for complex implementation  
**Maintenance Phase**: Claude Code for systematic improvements and automation

## Project Lifecycle Workflows

### 1. Project Initiation Workflow

#### Phase 1: Research and Planning (Gemini CLI)
```bash
# Technology exploration
gemini "Compare Node.js frameworks for building REST APIs: Express, Fastify, and NestJS. Consider performance, ecosystem, learning curve, and maintenance overhead for a team of 3 developers"

# Architecture planning
gemini "Design a microservices architecture for an e-commerce platform with user management, product catalog, order processing, and payment integration"

# Risk assessment
gemini "What are the main technical risks and challenges in building a real-time collaborative document editor, and how can they be mitigated?"
```

**Outputs:**
- Technology recommendations with trade-offs
- Architectural blueprints and diagrams
- Risk analysis and mitigation strategies
- Implementation timeline estimates

#### Phase 2: Project Structure Setup (Claude Code)
```bash
# Create comprehensive project foundation
claude "Initialize a Node.js project with TypeScript, Express, PostgreSQL, and Docker. Set up development environment, testing framework, CI/CD pipeline, and comprehensive documentation structure"

# Results in:
# - Complete project scaffolding
# - Development tooling configuration
# - Testing framework setup
# - Docker containerization
# - CI/CD pipeline implementation
# - Documentation templates
```

**Benefits:**
- Professional-grade project structure in minutes
- Consistent development environment
- Automated quality assurance from day one
- Comprehensive documentation foundation

### 2. Feature Development Workflow

#### The Hybrid Implementation Pattern

**Step 1: Feature Exploration (Cursor)**
```typescript
// Rapid prototyping in Cursor
// Quick iteration on user interface
// Testing different approaches
// Validating user experience
```

**Benefits of Cursor for prototyping:**
- Real-time feedback and suggestions
- Rapid iteration cycles
- Excellent for UI/UX development
- Low friction for experimentation

**Step 2: Production Implementation (Claude Code)**
```bash
# Comprehensive feature implementation
claude "Implement a user authentication system with JWT tokens, password hashing, email verification, password reset, rate limiting, and comprehensive error handling. Include full test coverage and API documentation"
```

**Claude Code delivers:**
- Complete feature implementation
- Comprehensive error handling
- Full test coverage
- Security best practices
- API documentation
- Integration with existing code

**Step 3: Refinement and Polish (Cursor)**
```typescript
// Fine-tuning user experience
// Adjusting styling and interactions
// Performance optimizations
// Edge case handling
```

### 3. Maintenance and Evolution Workflow

#### Continuous Improvement Pattern

**Weekly Code Health Review (Claude Code)**
```bash
# Comprehensive codebase analysis
claude "Analyze the entire codebase for code quality issues, security vulnerabilities, performance bottlenecks, and technical debt. Provide prioritized recommendations for improvements"

# Dependency updates and security
claude "Review all dependencies for updates, security issues, and compatibility. Create a plan for safe upgrades with comprehensive testing"

# Documentation maintenance
claude "Review and update all documentation to ensure accuracy, completeness, and usefulness. Generate missing documentation where needed"
```

**Monthly Architecture Review (Gemini CLI + Claude Code)**
```bash
# Architecture analysis with Gemini CLI
gemini "Analyze this codebase architecture for scalability issues, design pattern consistency, and alignment with modern best practices. Suggest improvements for the next 6 months"

# Implementation with Claude Code
claude "Implement the architectural improvements suggested in the analysis, ensuring backward compatibility and comprehensive testing"
```

## Tool-Specific Workflow Patterns

### Cursor Workflows

#### Rapid Prototyping Pattern
1. **Create basic structure** with live suggestions
2. **Iterate quickly** on functionality
3. **Test ideas immediately** with real-time feedback
4. **Refine user experience** through rapid cycles

```typescript
// Example: Building a React component with Cursor
// 1. Start with component structure
const UserDashboard = () => {
  // Cursor suggests state management
  // 2. Add state and effects rapidly
  // 3. Implement UI with real-time preview
  // 4. Refine styling and interactions
}
```

#### Code Review and Refinement Pattern
1. **Use Cursor chat** for code explanation
2. **Apply suggestions** with inline assistance  
3. **Refactor incrementally** with AI guidance
4. **Validate changes** through testing

#### .cursorrules Configuration Pattern
```markdown
# Project-specific .cursorrules
- Use TypeScript for all new files
- Follow React functional component patterns
- Implement comprehensive error boundaries
- Use styled-components for styling
- Include JSDoc comments for functions
- Follow conventional commit message format
```

### Claude Code Workflows

#### Complex Implementation Pattern
```bash
# Single command for comprehensive feature
claude "Implement a real-time notification system with WebSocket connections, push notifications, email fallback, user preferences, and comprehensive admin dashboard"

# Results in:
# - WebSocket server implementation
# - Push notification service
# - Email service integration
# - User preference management
# - Admin dashboard with real-time metrics
# - Comprehensive testing
# - API documentation
```

#### Systematic Refactoring Pattern
```bash
# Step 1: Analysis
claude "Analyze the authentication system for security vulnerabilities, performance issues, and maintainability concerns"

# Step 2: Planning
claude "Create a comprehensive refactoring plan for the authentication system based on the analysis"

# Step 3: Implementation
claude "Implement the refactoring plan incrementally, ensuring no functionality is lost and all tests pass"

# Step 4: Validation
claude "Validate the refactored authentication system through comprehensive testing and security review"
```

#### Documentation Generation Pattern
```bash
# API documentation
claude "Generate comprehensive API documentation for this FastAPI application, including request/response schemas, error codes, authentication requirements, and usage examples"

# Code documentation  
claude "Add comprehensive docstrings to all functions and classes, following Google style guide"

# User documentation
claude "Create user-facing documentation explaining how to integrate with this API, including tutorials and examples"
```

### Gemini CLI Workflows

#### Research and Analysis Pattern
```bash
# Technology comparison
gemini "Compare React, Vue, and Svelte for a large-scale enterprise application. Consider performance, ecosystem, team learning curve, and long-term maintenance"

# Architecture decision
gemini "Should we use microservices or monolith for a startup with 5 developers building a SaaS platform? Consider development speed, maintenance overhead, and scaling requirements"

# Performance optimization
gemini "Analyze these PostgreSQL slow query logs and recommend optimization strategies including indexing, query rewriting, and schema changes"
```

#### Problem Investigation Pattern
```bash
# Issue analysis
gemini "Our Node.js application has memory leaks in production. Based on these symptoms [describe], what are the most likely causes and how should we investigate?"

# Solution research  
gemini "What are the best practices for implementing rate limiting in a distributed system with Redis? Consider edge cases, performance, and failure scenarios"
```

## Project-Type-Specific Workflows

### Web Application Development

#### Frontend-Heavy Projects
```bash
# Phase 1: UI prototyping (Cursor)
# - Rapid component development
# - Real-time styling and interaction
# - User experience validation

# Phase 2: Backend integration (Claude Code)
# - API implementation
# - State management
# - Error handling
# - Performance optimization

# Phase 3: Production readiness (Claude Code)
# - Testing framework
# - CI/CD pipeline
# - Security implementation
# - Performance monitoring
```

#### API Development Projects
```bash
# Phase 1: API design (Gemini CLI)
gemini "Design a REST API for a social media platform with user management, posts, comments, and real-time features"

# Phase 2: Implementation (Claude Code)  
claude "Implement the social media API with FastAPI, including authentication, CRUD operations, real-time updates, rate limiting, and comprehensive testing"

# Phase 3: Documentation and testing (Claude Code)
claude "Generate comprehensive API documentation and create extensive test coverage including integration tests and performance tests"
```

### CLI Tool Development

#### Python CLI Projects
```bash
# Phase 1: Architecture planning (Gemini CLI)
gemini "Design a command-line tool architecture for processing video files with plugins, configuration management, and parallel processing capabilities"

# Phase 2: Implementation (Claude Code)
claude "Implement the video processing CLI tool using Click, with plugin system, configuration management, progress bars, comprehensive error handling, and full test coverage"

# Phase 3: Packaging and distribution (Claude Code)
claude "Set up packaging for PyPI distribution, create installation scripts, implement auto-updates, and create comprehensive user documentation"
```

### Library/Package Development

#### Multi-Package Ecosystem (claif-packages case study)
```bash
# Phase 1: Ecosystem design (Gemini CLI)
gemini "Design a multi-package Python ecosystem for CLI tools with shared utilities, consistent interfaces, and coordinated releases"

# Phase 2: Implementation coordination (Claude Code)
claude "Implement the multi-package ecosystem with consistent coding standards, shared configuration, cross-package testing, and unified documentation"

# Phase 3: Maintenance automation (Claude Code)  
claude "Set up automated dependency management, synchronized releases, comprehensive testing matrix, and ecosystem health monitoring"
```

## Quality Assurance Workflows

### Testing Strategy

#### Comprehensive Test Implementation
```bash
# Test-driven development with Claude Code
claude "Implement a payment processing system using TDD approach: start with comprehensive test suite defining expected behavior, then implement functionality to pass tests"

# Test coverage analysis and improvement
claude "Analyze test coverage for this project and implement tests for uncovered functionality, focusing on edge cases and error conditions"

# Integration test automation
claude "Create comprehensive integration tests for the API endpoints, including authentication flows, error scenarios, and performance validation"
```

#### Performance Testing
```bash
# Performance test implementation
claude "Implement performance tests for the API using pytest-benchmark, including load testing, stress testing, and database performance validation"

# Performance optimization
claude "Analyze the performance test results and implement optimizations to meet the target response times under load"
```

### Security Workflows

#### Security Implementation Pattern
```bash
# Phase 1: Security analysis (Gemini CLI)
gemini "What are the top security concerns for a web application handling financial data? Provide specific implementation recommendations"

# Phase 2: Security implementation (Claude Code)
claude "Implement comprehensive security measures for this financial web application, including authentication, authorization, data encryption, input validation, and security monitoring"

# Phase 3: Security validation (Claude Code)
claude "Perform security audit of the implemented measures and create comprehensive security tests"
```

#### Vulnerability Management
```bash
# Regular security reviews
claude "Scan this codebase for security vulnerabilities using static analysis and provide remediation recommendations"

# Dependency security management
claude "Review all dependencies for security issues and implement automated security scanning in the CI/CD pipeline"
```

## Team Collaboration Workflows

### Code Review Enhancement

#### AI-Assisted Code Review
```bash
# Comprehensive review preparation
claude "Prepare this pull request for review: analyze code quality, security implications, performance impact, and adherence to project standards. Generate detailed review comments"

# Review response assistance
claude "Help me respond to these code review comments by explaining the rationale for implementation decisions and suggesting improvements where valid"
```

#### Mentoring Support
```bash
# Junior developer guidance
claude "This is a junior developer's first contribution to our React project. Provide constructive feedback that explains not just what to change, but why these changes improve code quality and align with our team standards"

# Knowledge transfer
claude "Create comprehensive documentation explaining the architecture decisions in this codebase for new team members"
```

### Documentation Workflows

#### Living Documentation Pattern
```bash
# Architecture documentation
claude "Generate architecture documentation that stays current with code changes, including component diagrams, data flow, and decision records"

# API documentation automation
claude "Implement automated API documentation generation that updates with code changes and includes examples and testing information"

# User guide generation
claude "Create user guides and tutorials for this software that are beginner-friendly but comprehensive"
```

## Performance Optimization Workflows

### Systematic Performance Improvement

#### Performance Analysis Pattern
```bash
# Phase 1: Performance profiling (Gemini CLI)
gemini "Analyze these application performance metrics and identify the most impactful optimization opportunities"

# Phase 2: Implementation (Claude Code)
claude "Implement the performance optimizations focusing on database queries, caching, and algorithmic improvements"

# Phase 3: Validation (Claude Code)
claude "Implement performance monitoring and create automated performance regression tests"
```

#### Database Optimization Workflow
```bash
# Database analysis
claude "Analyze the database schema and queries for performance bottlenecks, suggesting indexing strategies and query optimizations"

# Implementation and testing
claude "Implement the database optimizations with proper migrations and performance validation tests"
```

## Deployment and DevOps Workflows

### CI/CD Implementation

#### Complete Pipeline Setup
```bash
# Infrastructure as code
claude "Implement a complete CI/CD pipeline using GitHub Actions with automated testing, security scanning, deployment to staging and production, and monitoring integration"

# Container orchestration
claude "Set up Docker containerization with multi-stage builds, security scanning, and Kubernetes deployment configurations"

# Monitoring and alerting
claude "Implement comprehensive monitoring with Prometheus and Grafana, including application metrics, performance monitoring, and automated alerting"
```

### Production Maintenance

#### Incident Response Workflow
```bash
# Issue investigation
claude "Analyze these production logs and error reports to identify the root cause of the performance degradation"

# Resolution implementation
claude "Implement a fix for the identified issue with proper testing and gradual rollout strategy"

# Post-incident improvements
claude "Create preventive measures and monitoring to prevent similar issues in the future"
```

## Best Practices Summary

### Tool Selection Guidelines

**Use Cursor when:**
- Rapid prototyping and experimentation
- UI/UX development and styling
- Interactive debugging and testing
- Learning new APIs or frameworks
- Fine-tuning and polishing features

**Use Claude Code when:**
- Complex multi-file implementations
- Systematic refactoring and optimization
- Comprehensive testing and documentation
- CI/CD pipeline setup and maintenance
- Security implementation and auditing

**Use Gemini CLI when:**
- Technology research and comparison
- Architecture design and planning
- Problem investigation and analysis
- Performance optimization strategies
- Best practice recommendations

### Quality Assurance Integration

**Always include:**
- Comprehensive error handling
- Security considerations
- Performance optimization
- Test coverage
- Documentation updates
- Code review preparation

**Validation steps:**
- Run automated tests
- Perform security scanning
- Validate performance impact
- Review code quality metrics
- Update documentation
- Test deployment process

### Common Pitfalls to Avoid

**Over-reliance on single tools:**
- Each tool has optimal use cases
- Context switching requires planning
- Maintain human oversight and judgment

**Insufficient validation:**
- Always review AI-generated code
- Test thoroughly before production
- Validate security implications
- Consider performance impact

**Poor context management:**
- Maintain clear project structure
- Document architectural decisions
- Keep AI tools informed of constraints
- Regular context refresh for long sessions

---

*These workflows represent distilled best practices from analyzing 177 real projects with extensive LLM tool usage. The key to success is strategic tool combination, systematic quality assurance, and maintaining human oversight throughout the development process.*