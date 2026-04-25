---
name: aposd-review
description: Review code through the A Philosophy of Software Design (APOSD) lens. Walks a diff, PR, or file checking for shallow modules, information leakage, pass-through methods, non-obvious code, naming drift, and tactical-vs-strategic changes. Use when reviewing a PR, auditing a change, checking for tactical drift, self-reviewing before pushing, or critiquing recently-written code.
argument-hint: [scope — defaults to unstaged diff]
allowed-tools: Read Grep Glob Write Bash(git diff *) Bash(git status *) Bash(git log *) Bash(git show *) Bash(git merge-base *) Bash(gh pr view *) Bash(gh pr diff *) Bash(mkdir *) Bash(date *)
---

# aposd-review — critique through APOSD lens

Walks a code change with four passes, looking for specific patterns Ousterhout names: shallow modules, information leakage, obscurity, tactical drift. Produces a line-anchored review, not a summary.

## When to invoke

- Reviewing a diff, staged change, branch, or PR
- Auditing recent work (yours or a colleague's) for tactical drift
- Self-review before pushing

## Procedure

### 1. Determine scope

Interpret `$ARGUMENTS`:
- empty or `unstaged` → `git diff`
- `staged` → `git diff --cached`
- `branch` → `git diff $(git merge-base HEAD main)...HEAD`
- `#<N>` or a PR URL → `gh pr view <N>` then `gh pr diff <N>`
- a file path → `git diff <path>` if tracked; else read the file

Verify with `git status` or `gh pr view` before walking. If the scope is ambiguous (e.g., "review this" with no diff and no arg), ask ONE clarifying question.

### 2. Four-pass walk

Do ALL four passes. Skipping a pass is how drift slips through.

**Pass 1 — Module depth.** Does this diff make modules deeper or shallower?
Watch for: new wrapper methods, new small classes, pass-through methods, opt-in behaviors that should be default, interface growth disproportionate to capability, `Manager`/`Helper`/`Util` class names, getter/setter pairs.

**Pass 2 — Information flow.** Does this diff hide or leak knowledge?
Watch for: the same design decision now in 2+ files, methods returning internal collections, temporal decomposition (separate `parse` / `transform` classes both knowing the format), configuration parameters that expose implementation choices, multi-call initialization sequences.

**Pass 3 — Obviousness.** Can a reader predict behavior without reading the implementation?
Watch for: generic names (`data`, `result`, `handler`, `process`), constructors spawning threads or doing I/O, positional tuple returns, missing units, undocumented invariants, comments that restate the code, stale comments left uncorrected, inconsistent naming or style versus surrounding code.

**Pass 4 — Strategic vs tactical.** Does this change improve structure or accumulate debt?
Watch for: "we'll clean this up later" in commit messages or PR descriptions, patches on top of shortcuts, bug fixes via special-case branches with no comment, new features requiring edits across many unrelated files, new exception types without meaningful handlers, stale comments not updated in the same commit, `TODO` / `FIXME` without owner or scope.

### 3. Confirm with RED-FLAGS.md

For each suspicion, load [RED-FLAGS.md](RED-FLAGS.md) to confirm the pattern name, the verification check, and the suggested fix. Do not load up front — only when a match is likely. The catalog is organized by pass, so you can jump directly.

### 4. Write the review

Run `mkdir -p .claude/aposd` and write to `.claude/aposd/$(date +%Y%m%d-%H%M%S).review.md` with this exact structure:

```
# Review — <scope>

## Must-fix
<clear violations with cheap fixes — block merge on these>
- [<flag-name>] <file:line> — <observed pattern; why it hurts>. Suggested: <concrete change>.

## Should-consider
<tradeoffs worth discussion — not blockers>
- [<flag-name>] <file:line> — <observation>. Options: <A or B, with tradeoff>.

## Observations
<patterns to watch but not act on now>
- <file:line or general note>.

## Strategic vs tactical
<1-3 sentences: does the system now look like it was designed this way from the start? Or did this change leave it slightly messier than before?>
```

## Output contract

- Every entry references file:line. No "somewhere in module X."
- Must-fix items are genuine APOSD violations, not style preferences.
- Every must-fix has a concrete suggested change, not "consider improving."
- If nothing of consequence is found, say so in one line and stop. Do not pad.
- Do NOT review things a linter enforces (whitespace, semicolons, import order). Focus on design.
- Do NOT rehash file-by-file — group by flag, not by file.
