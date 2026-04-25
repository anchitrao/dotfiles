---
name: aposd-explore
description: Diagnose complexity in existing code before modifying it. Produces a complexity map (shallow modules, hidden dependencies, red flags) that feeds aposd-design or informs a refactor. Use when onboarding to unfamiliar code, before a significant refactor, or when asked "what am I walking into" or "map out the complexity here".
argument-hint: [path — defaults to cwd]
allowed-tools: Read Grep Glob Write Bash(find *) Bash(ls *) Bash(wc *) Bash(git log *) Bash(mkdir *)
---

# aposd-explore — diagnose complexity

Produces a complexity map of existing code through the APOSD lens, grounded in John Ousterhout's symptoms of complexity: change amplification, cognitive load, unknown unknowns.

## When to invoke

- Before touching unfamiliar code (onboarding, inherited service, bug in unexplored module)
- Before a refactor, to separate real problems from code that is already working as designed
- When the user asks "what am I walking into" or "map out the complexity here"

## Procedure

### 1. Scope the target

Default to `$ARGUMENTS` or the current working directory. If scope is a directory with more than ~50 files, walk structure (not contents) for 3 levels and pick the 3-5 highest-leverage modules to read in depth. Say which modules you picked and why.

### 2. Three diagnostic passes

**Structural.** For each module or class: interface size (public names) vs. implementation size (non-blank body lines). Depth ratio ≤ 0.1 methods/line suggests deep; ≥ 0.3 suggests shallow. Flag pass-through methods, wrappers, always-paired classes.

**Semantic.** For each module boundary: what knowledge does each side need about the other? Same format, protocol, or invariant referenced in two or more files is information leakage. Generic names (`data`, `result`, `handler`, `Manager`, `Util`) are obscurity markers.

**Behavioral.** Run `git log --oneline -20 <path>` if available. Do unrelated files change together (change amplification)? Do fixes cluster in one module (cognitive-load hotspot)?

### 3. Confirm with FLAGS.md

When you observe a suspicious pattern, load [FLAGS.md](FLAGS.md) and match against the catalog to name it and attach a verification check. Do not load FLAGS.md up front — only when a symptom warrants lookup.

### 4. Write the map

Run `mkdir -p .claude/aposd` and write to `.claude/aposd/<scope-basename>.map.md`:

```
# <scope> complexity map

## Depth assessment
- <module>: shallow | deep | mixed — <one-line reason with file:line>

## Red flags
- [<flag-name>] <file:line> — <observed pattern; why it hurts>

## Change-amplification evidence
- <from git log, if any>

## Recommendations
- Leave alone: <modules with genuine depth>
- Worth refactoring: <highest-leverage targets>
- Do not modify blind: <modules with undocumented invariants>
```

## Output contract

- Every red flag cites a file:line. No "consider reviewing X" without a concrete observation.
- No depth rating without evidence ("shallow: 23 public methods over 28 body lines").
- Stop at ~150 lines of map. If the scope is too large, recommend sub-scoping and say which subdirs to prioritize.
- End with one sentence naming the single highest-leverage thing to fix, if asked to pick one.
