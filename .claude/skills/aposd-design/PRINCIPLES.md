# APOSD Design Principles (design mode)

Each principle is a generative move. Use during alternative generation (step 2) or when a design feels wrong but you cannot name why.

---

## Deep modules

Interface size is the cost a module imposes on the system; functionality is the benefit. Maximize the ratio.

- A small interface that hides significant complexity is the goal.
- Unix I/O (5 syscalls, millions of lines behind them) is the canonical deep module.
- Anti-pattern: Java's `FileInputStream` + `BufferedInputStream` + `ObjectInputStream` — callers must know about buffering, opt into it, and compose three classes for one logical operation.
- **Generative move**: before exposing a new method, ask "what of this implementation can I absorb that callers currently handle?"

## Information hiding

Each module encapsulates design decisions. Callers depend on *what* a module does, not *how*.

- Hide: data structure, algorithm, format choice, ordering assumptions, concurrency mechanism.
- Expose: the contract — behavior, not representation.
- `private` is not hiding. Getter/setter pairs leak the representation under a thin disguise.
- **Generative move**: for every method name and parameter, verify it expresses the contract, not the implementation (e.g., `getParameter(name)` not `getParams()`).

## Pull complexity downwards

When uncertain where a piece of logic belongs, put it in the module, not the caller.

- Every configuration parameter is a decision you declined to make, multiplied across every operator.
- Good defaults > required parameters. Derive values when the module has better information than the caller (e.g., retry timeout from observed RTT, not a config knob).
- **Generative move**: every required parameter must answer "does the caller genuinely know this better than the module?" If no, remove it.

## Somewhat general-purpose

Over-specialization is the largest source of complexity. A somewhat general-purpose interface is usually simpler than a special-purpose one.

Three questions to ask:
- What is the simplest interface that covers current needs?
- Is this method called from exactly one place? (Probably too special-purpose.)
- Is the API easy to use for today's needs? (If yes, not over-generalized.)

- **Generative move**: for a text editor's storage class, prefer `insert(pos, str)` / `delete(start, end)` over `backspace()` / `deleteSelection()`. The UI layer translates user actions into primitives; the storage class stays general.

## Different layer, different abstraction

Each layer should expose a meaningfully different abstraction than its neighbors.

- Pass-through methods (body is a single delegation with matching signature) = a layer with no value. Delete, or merge the classes.
- API shape should NOT mirror internal storage. `insertLine` / `deleteLine` over line-based storage is wrong; `insert(pos, str)` / `delete(start, end)` is right.
- **Generative move**: if every public method of a wrapper class just forwards, collapse the wrapper.

## Define errors out of existence

Most exceptions are defensive, not necessary. Prefer redefining the contract.

- `unset(var)` should mean "ensure var does not exist" — not "delete existing var, error if missing."
- `substring(s, i, j)` should clamp out-of-range indices, not throw.
- Mask exceptions at the lowest layer that can resolve them (TCP retransmission hides packet loss entirely).
- Aggregate: find the highest layer where all instances of an exception class result in the same response; put one handler there; remove the lower ones.
- Last resort for unrecoverable, rare errors (OOM, disk hard errors, internal inconsistency): crash with a diagnostic. Do not propagate complexity through every call site.
- **Generative move**: before throwing, ask "can I redefine the contract so this input is valid?"

## Better together or apart

Default to "apart." Combine only when there is a concrete reason.

Combine when:
- Both pieces depend on the same format/protocol/invariant (shared knowledge)
- Combining simplifies the interface (eliminates an intermediate data structure)
- It eliminates repeated call-site boilerplate

Keep apart when:
- Each piece is independently understandable (isolation test passes)
- One is general-purpose and the other is special-case — push the special up

- **Generative move**: if you need to flip between two files to reason about behavior, they're conjoined. Merge, or redraw the boundary so each side is self-contained.

## Push specialization up (or down)

Lower-level modules stay general. Higher-level (application) code owns the special cases.

- Text storage class: general `insert` / `delete` primitives.
- UI layer: translates backspace / delete keys into those primitives.
- Device drivers: the inverse — abstract interface at the top, device-specific knowledge pushed into sub-modules that implement it.
- **Generative move**: if you're tempted to add a UI-flavored method to a data class, stop. That method belongs above.

## Eliminate special cases

Design the normal-case path so edge cases fall out of it naturally, with no extra `if` checks.

- Represent "no selection" as an empty-range selection, not a nullable state variable.
- Represent "no value yet" as a zero-valued instance, not a separate boolean `hasValue`.
- A single sentinel check at the top of a hot path often collapses three scattered edge-case tests.
- **Generative move**: for every `if (isEmpty / isNull / hasValue)` guard you write, ask whether the representation could absorb the case and remove the branch.

## Leverage (what matters)

Design decisions that resolve many problems at once are higher leverage.

- General-purpose interfaces have more leverage than special-purpose ones.
- Invariants that eliminate many special cases (empty-selection sentinel) are high leverage.
- **Generative move**: for each design decision, ask "does this solve one problem or multiple?" Optimize for decisions that solve multiple.

## The design-it-twice move itself

You will not produce your best design on the first attempt. This is structural, not a talent issue. Generate at least two designs that *differ in shape*, not in naming.

Different shapes might include:
- Push complexity up vs. down
- One rich class vs. multiple collaborating classes
- Stateless procedural vs. stateful object
- Event-driven vs. request-response
- Flat vs. layered

If you cannot find two different shapes, you haven't yet understood the problem. Go back and read the callers, the existing code, or the constraints.
