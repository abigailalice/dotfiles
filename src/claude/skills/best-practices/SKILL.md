---
name: best-practices
description: Use when a developer wants to find improvements to project health they may not know they're missing — testing, CI, linting, dependency management, observability, secrets hygiene, documentation — not business logic or features.
---

# Project Health Audit

## Overview

Survey a project for missing or underdeveloped engineering practices. Surface things the developer doesn't know they're missing — not a critique of business logic, but gaps in foundational practices that affect maintainability, reliability, and safety over time.

**This skill is not a checklist to run through.** The categories below are a starting point, not an exhaustive list — and critically, the developer invoking this skill has read these categories and may well have already addressed them. If the project passes everything listed here, that's not the end of the audit; it means you need to look harder and think more broadly. The goal is to find genuine unknown unknowns, not to confirm that known items are handled.

## Known Tooling — Check These First

The developer using this skill is already familiar with the following. Before surfacing anything as an "unknown unknown," check whether these are applicable and in use:

**Testing**
- Property/generative testing (QuickCheck, Hypothesis, fast-check, etc.) — not just unit tests
- mypy — Python type checking

**Languages & Frameworks**
- Haskell — check for HLS, hlint, fourmolu/ormolu, ghcid, cabal/stack, hspec/QuickCheck
- TypeScript — check for strict mode, tsc --noEmit in CI, ESLint with type-aware rules
- Rust — check for clippy, cargo audit, cargo test
- React + shadcn — check for component testing (Testing Library), storybook, a11y linting
- Python — check for mypy, ruff, pytest, pip audit

**Infrastructure & Dev Tooling**
- Nix/NixOS — check for flake.lock committed, `nix flake check`, devShell defined
- Docker/docker-compose — check for .dockerignore, pinned base image tags, multi-stage builds
- direnv — check for .envrc present and nix-direnv if it's a Nix project
- just — check for a justfile with common dev tasks (test, lint, fmt, build)
- process-compose — check if multi-process dev setup is defined and documented
- OpenAPI — check for schema defined and kept in sync with implementation, generated client/server types

**Problem Classes — check coverage regardless of specific tool**
- Logging — structured logging in place, not just console/stderr; log levels used appropriately
- Data sanitization — input validation at system boundaries (user input, external APIs, env vars); no silent coercions
- Test coverage — coverage measured and not trivially low; property/generative tests for data-heavy logic

These are not things to recommend if absent — they're tools to check for first before looking for genuinely new suggestions.

## Process

### 1. Discover What's There

```bash
# Version control
ls -la .git/ 2>/dev/null && git log --oneline -5

# Lock files / dependency management
ls package-lock.json yarn.lock pnpm-lock.yaml \
   Pipfile.lock poetry.lock Cargo.lock flake.lock go.sum 2>/dev/null

# CI/CD
ls .github/workflows/ .gitlab-ci.yml .circleci/ Jenkinsfile 2>/dev/null

# Tests
find . \( -name "*.test.*" -o -name "*.spec.*" -o -name "*_test.*" -o -name "test_*.py" \) \
  -not -path "*/node_modules/*" | head -20

# Linting / formatting / types
ls .eslintrc* .prettierrc* pyproject.toml .flake8 .rubocop.yml \
   tsconfig.json rustfmt.toml .editorconfig 2>/dev/null

# Docs
ls README* CONTRIBUTING* CHANGELOG* docs/ 2>/dev/null

```

### 2. Evaluate Each Category

| Category | What to look for |
|---|---|
| **Version control** | Git initialized, .gitignore present, history sensible |
| **Dependency locking** | Lock file committed, no `*` or `latest` versions |
| **Testing** | Any tests at all, test runner configured |
| **Tests in CI** | Tests run automatically on push/PR |
| **Test coverage** | Coverage measured, not trivially low |
| **Linting** | Linter configured and enforced |
| **Formatting** | Auto-formatter in use (prettier, black, rustfmt, gofmt) |
| **Type safety** | Type checker used where the language supports it |
| **CI/CD** | Pipeline exists, runs on PRs |
| **Reproducible builds** | Dockerfile, devcontainer, Nix flake, or similar |
| **Secrets hygiene** | No secrets in code, .env in .gitignore |
| **Dependency security** | Vulnerability scanning (npm audit, pip audit, cargo audit) |
| **Observability** | Structured logging or error tracking — not just console.log |
| **Pre-commit hooks** | Lint/test runs locally before commit |
| **Documentation** | README explains how to run and develop the project |

### 3. Prioritize Gaps

**P0 — Fix immediately (safety/correctness)**
- Secrets in code or committed .env files
- No version control
- Dependency versions unpinned (supply chain risk)

**P1 — High value (reliability)**
- No tests
- No CI (tests never run automatically)
- No lock file

**P2 — Developer experience**
- No linter or formatter
- No type checking in a typed language
- No pre-commit hooks

**P3 — Long-term maintainability**
- Coverage not measured
- No README or contribution guide
- No CHANGELOG

### 4. Present Findings

```
## Project Health Audit

### Already in place
- [what's there]

### Gaps Found

**P0 — Fix immediately**
- [ ] Secrets in version control: anyone with repo access has your credentials → run git-filter-repo to purge, rotate all secrets, add .env to .gitignore

**P1 — High value**
- [ ] No tests: regressions will be caught by users, not by CI → add [framework] and write one test for the riskiest path first

[etc.]
```

Each item: what's missing, why it matters in one sentence, concrete first step.

## Calibrate to Stack and Scale

Adapt recommendations to what's appropriate:

| Stack | Typical tooling |
|---|---|
| Python | mypy/pyright, ruff/black, pytest, pip audit |
| JS/TS | TypeScript, ESLint, Prettier, vitest, npm audit |
| Rust | clippy, rustfmt, cargo test, cargo audit |
| Go | vet, staticcheck, gofmt, govulncheck |
| Nix | nixfmt, statix, flake checks |

**Scale matters.** Don't recommend a 10-tool pipeline for a 200-line personal script. A small project might only need git + a README + one test. The question is: given the project's size and audience, what's the gap between what's there and what a well-run project of this type would have?

## When the Project Passes Everything Listed

If the project already handles all the categories above, don't stop — keep looking. Some directions to go deeper:

- **Test quality vs. test presence** — tests exist, but do they test the right things? Are they brittle? Do they give false confidence (mocking everything, never hitting real I/O)?
- **Dependency hygiene** — outdated packages, abandoned libraries, transitive dependencies with known issues
- **Error handling patterns** — are errors surfaced to the right places, or silently swallowed?
- **Configuration management** — hardcoded values that should be config, environment-specific logic scattered through code
- **Build/deploy reproducibility** — works on one machine but fragile elsewhere
- **Test isolation** — tests that pass individually but fail in certain orders (shared global state, filesystem pollution)
- **Missing edge case coverage** — obvious failure modes with no test (empty input, network timeout, concurrent writes)
- **Documentation drift** — README describes a setup that no longer works
- **Dead code and feature flags** — old branches of logic that are never exercised
- **Operational readiness** — how does someone know when this is broken in production?

These are examples, not another exhaustive list. The skill is to look at the specific project with fresh eyes and ask: *"If I were handed this codebase to maintain for the next two years, what would I wish they'd done?"*

## Scope

**In scope:** Anything that affects long-term maintainability, reliability, developer experience, or safety — regardless of whether it appears in the categories above.

**Out of scope:** Whether the business logic is correct, architectural choices specific to the domain, feature completeness, performance optimization.

The guiding question: *"What does a well-run software project of this size have that this one doesn't?"* — and if you can't find an answer in the obvious places, look until you find one.