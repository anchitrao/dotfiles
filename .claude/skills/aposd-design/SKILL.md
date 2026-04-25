---
name: aposd-design
description: Design a new module or feature using John Ousterhout's design-it-twice discipline. Sketches two structurally different approaches, compares them on interface simplicity, depth, and where complexity lives, then commits to one with rationale. Use when designing a new component, redesigning an existing module, deciding module boundaries, or asked "design it twice" or "sketch two approaches".
argument-hint: [task description]
allowed-tools: Read Grep Glob Write Bash(mkdir *)
---

# aposd-design — design it twice

Forces a structural comparison between at least two designs before committing. Your first design is almost never the best one; the discipline of sketching a second — and genuinely comparing — often reveals a superior third.

## When to invoke

- Before writing a new module or public interface
- When redesigning an existing module whose shape is suspect
- When stuck between two approaches and needing structured comparison
- After `aposd-explore` has produced a complexity map and the next step is redesign

## Procedure

### 1. State the task

Extract from `$ARGUMENTS`:
- The primary operation callers will perform
- Existing callers or consumers (read the relevant ones)
- Hard constraints (performance, compat, deploy target, existing dependencies)
- Any complexity map from a prior `aposd-explore` run (check `.claude/aposd/*.map.md`)

If any of these are unclear, ask ONE clarifying question, then proceed. Do not ask three.

### 2. Generate two structurally different designs

Not two names for the same shape. **Two different shapes.** Examples of structural differences:

- Push complexity up vs. pull it down
- One rich class vs. multiple collaborating classes
- Stateless procedural vs. stateful object
- Event-driven vs. request-response
- Flat single-layer vs. layered

For each design, answer (bluntly, one line each):
- Key abstraction (what does this module *represent*?)
- Interface (signatures only — no implementation)
- What it hides vs. what it exposes
- Where complexity lives (module or caller)
- Failure modes (what's genuinely hard with this shape?)

If you cannot produce two truly different designs, load [PRINCIPLES.md](PRINCIPLES.md) for generative moves (pull-down, push-specialization-up, define-errors-away, deep-module, somewhat-general-purpose).

### 3. Compare along fixed axes

| Axis | Design A | Design B |
|------|----------|----------|
| Interface simplicity | concrete: # params, # methods, # concepts callers must hold | |
| Depth | hidden complexity vs exposed surface | |
| Information hiding | what each module needs to know about others | |
| Generality | somewhat-general? over-specialized? | |
| Complexity lives in | module / caller | |
| Worst failure mode | | |

Each cell must be concrete, not "A is simpler." Reference specific signatures, specific decisions.

### 4. Commit or synthesize

Pick A, B, or produce a synthesized C that inherits the strengths of both. Always state rationale tied to the comparison.

**Stop condition**: if every design pushes complexity onto callers, the module boundary is wrong. Return to step 2 with a different decomposition.

### 5. Write the design artifact

Run `mkdir -p .claude/aposd` and write to `.claude/aposd/<slug>.design.md`:

```
# <task> — design

## Task
<1 paragraph: what's being designed, for whom, under what constraints>

## Design A: <name>
- Key abstraction: ...
- Interface:
    <signatures>
- Hides: ... / Exposes: ...
- Complexity lives in: module | caller — <one line why>
- Failure modes: ...

## Design B: <name>
<same structure>

## Comparison
<table with concrete cells>

## Chosen approach: <A | B | C (synthesized)>
<rationale rooted in the comparison>

## Implementation hints
- Module ownership: <who owns what>
- Invariants to preserve: <short list>
- Deliberate simplifications: <what we're choosing NOT to handle, and why>
```

## Output contract

- The two designs MUST differ structurally, not cosmetically
- Every comparison cell MUST be concrete (reference signatures, counts, decisions)
- The chosen approach MUST state rationale tied to the comparison table
- If a synthesized C emerges, label it clearly and show what it inherits from A and B
- Implementation hints are the handoff to whoever builds the code; be specific enough to review against
