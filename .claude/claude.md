# Global Claude Code Guidelines

This file provides guidance to Claude Code across all projects.

## Code Documentation Guidelines

When adding comments to code, follow these principles from *A Philosophy of Software Design*:

**Write comments at a different level of abstraction than the code itself.** Avoid comments that simply restate what the code does - these add no value. Instead, write comments that either:

1. **Add intuition (higher level)**: Explain design rationale, architectural decisions, or the "why" behind the approach
2. **Add precision (lower level)**: Clarify edge cases, performance constraints, invariants, or subtle implementation details

**Examples:**

Avoid - restates the code:
```typescript
// Loop through users and filter by active status
const activeUsers = users.filter(u => u.isActive);
```

Good - adds intuition:
```typescript
// We filter to active users to exclude deactivated accounts from billing calculations
const activeUsers = users.filter(u => u.isActive);
```

Good - adds precision:
```typescript
// isActive is false for users who haven't completed email verification (edge case in user lifecycle)
const activeUsers = users.filter(u => u.isActive);
```
