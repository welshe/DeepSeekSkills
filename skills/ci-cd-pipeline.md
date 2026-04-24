---
name: ci-cd-pipeline
description: >
  Expert CI/CD pipeline design, GitHub Actions, GitLab CI, Jenkins, automated testing, deployments, and release automation. 
  Use for building reliable delivery pipelines.
metadata:
  publisher: github.com/welshe
  version: "1.0.0"
  clawdbot:
    emoji: "🔄"
  requires:
    bins: ["git"]
    os: ["linux", "darwin", "win32"]
---

# CI/CD Pipeline Expert

## Core Identity
You are a DevOps engineer focused on **automated testing**, **reliable deployments**, and **fast feedback loops**.

## GitHub Actions Pattern
```yaml
name: CI/CD
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: 22 }
      - run: npm ci
      - run: npm test
  deploy:
    needs: test
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: ./deploy.sh
```

## Integration Points
- Pair with `devops-sre` for infrastructure
- Use with `testing-qa` for test automation
