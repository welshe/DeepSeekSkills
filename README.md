# DeepSeekSkills

A curated collection of 15+ expert-level skill definitions for AI models. Each skill is a condensed, high-density cheat sheet designed to activate specialized expertise in specific domains.

**Publisher:** github.com/welshe  
**Target Model:** DeepSeek v4  
**Version:** 1.0.0

## Usage

Each skill file is a self-contained YAML/Markdown hybrid that defines:
- **Identity:** Who the AI becomes when activating this skill
- **Methodology:** Step-by-step systematic approach
- **Cheat Sheets:** Copy-paste ready patterns, commands, and code
- **Anti-Patterns:** Common mistakes to avoid
- **Integration:** How this skill composes with others

## Skills Index

| Skill | Domain | Emoji |
|-------|--------|-------|
| `security-audit` | Application Security & Penetration Testing | 🔒 |
| `system-architect` | Distributed Systems & Cloud Architecture | 🏗️ |
| `data-engineer` | ETL, Pipelines & Big Data Infrastructure | 📊 |
| `ml-ops` | Machine Learning Operations & Model Deployment | 🤖 |
| `database-optimizer` | Query Tuning & Database Performance | ⚡ |
| `devops-sre` | Site Reliability & Infrastructure Automation | 🔄 |
| `api-designer` | REST/GraphQL API Design & Versioning | 🔌 |
| `frontend-performance` | Web Performance & Core Web Vitals | 🚀 |
| `container-security` | Kubernetes & Container Hardening | 🛡️ |
| `incident-responder` | Security Incident Response & Forensics | 🚨 |
| `compliance-auditor` | GDPR, SOC2, HIPAA & Regulatory Compliance | 📋 |
| `cloud-cost-optimizer` | FinOps & Cloud Spend Reduction | 💰 |
| `chaos-engineer` | Resilience Testing & Failure Injection | 💥 |
| `observability-expert` | Logging, Metrics, Tracing & Debugging | 🔍 |
| `threat-modeler` | STRIDE, DREAD & Attack Surface Analysis | 🎯 |

## Structure

Each skill follows this format:

```yaml
---
name: skill-name
description: >
  Concise description of when to activate this skill.
metadata:
  publisher: github.com/welshe
  version: "1.0.0"
  target: "DeepSeek v4"
clawdbot:
  emoji: "🔧"
  requires:
    bins: []
    os: ["linux", "darwin", "win32"]
```

Followed by Markdown sections:
- **Core Identity** - Role definition and mindset
- **Methodology** - Systematic approach
- **Quick Reference** - Commands, patterns, checklists
- **Anti-Patterns** - What NOT to do
- **Integration** - Related skills

## License

MIT License - Use freely in your AI workflows.
