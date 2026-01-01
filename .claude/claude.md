## Commit Conventions

All commits should use [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/).

All commits must follow the format: `type(scope): description`

Common types: feat, fix, docs, style, refactor, test, chore

## Code Documentation Guidelines

Follow these principles when commenting code:

**DO NOT** use emojis when writing comments.

**Write comments at a different level of abstraction than the code itself.** Avoid comments that restate what the code does - these add no value. Instead, write comments that either:

1. **Add intuition (higher level)**: Explain design rationale, architectural decisions, or the "why" behind the approach
2. **Add precision (lower level)**: Clarify edge cases, performance constraints, invariants, or subtle implementation details

If you do not have enough information to write either of these, refrain from adding uninformed comments.
