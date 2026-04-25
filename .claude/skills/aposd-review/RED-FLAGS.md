# APOSD Red Flag Catalog (review mode)

Each flag has a pattern (what you see), a verification check (how to confirm), and a fix (what to suggest). Organized by review pass. Jump directly to the pass matching your suspicion.

---

## Pass 1 — Module depth

### Shallow class / classitis
- Pattern: small classes that always appear together (Java stream chains, `Manager` + `Helper` + `Util` trios); public method count close to body line count
- Verify: count public methods vs. non-blank body lines; ratio ≥ 0.3 methods/line
- Fix: merge into a richer class; absorb the orchestration callers perform

### Pass-through method
- Pattern: method body is a single delegation with a matching or near-matching signature
- Verify: body is 1-2 lines, calling another method with the same args
- Fix: delete it; expose the lower-level method directly, or merge the classes. (Exception: a dispatcher selecting among implementations based on args is legitimate.)

### Opt-in common case
- Pattern: sensible defaults (buffering, retries, error logging) require explicit caller setup
- Verify: grep call sites; all callers wrap the call the same way
- Fix: make the default behavior default; surface an opt-out, not an opt-in

### Wrapper with no value
- Pattern: decorator or wrapper whose `__init__` and every method just forward to the wrapped object
- Verify: read the class; does it add observable behavior?
- Fix: remove the wrapper; merge any added behavior upstream

### Added interface with no added capability
- Pattern: new public method that only renames or rearranges existing functionality
- Verify: existing callers could compose existing primitives to achieve the same result
- Fix: delete; document the composition if non-obvious

### Getter/setter pair on every field
- Pattern: public `getFoo` + `setFoo` for every private field
- Verify: grep `getFoo`/`setFoo`; count pairs; check if any meaningful behavior lives in the accessors
- Fix: either the field is genuinely part of the contract (document it) or it's implementation (remove accessors; expose behavior methods instead)

---

## Pass 2 — Information flow

### Information leakage
- Pattern: the same design decision (format, protocol, invariant) is encoded in 2+ files
- Verify: grep for format-specific tokens; both files would need to change for the same logical reason
- Fix: consolidate knowledge into one module; the other reads through the contract

### Temporal decomposition
- Pattern: classes organized around *when* operations happen (read class, parse class, write class) when they share format knowledge
- Verify: would a format change force edits across multiple files?
- Fix: decompose by knowledge, not by time. One class owns the format.

### Returning internal representation
- Pattern: method returns a reference to an internal collection or structure (`return this.params`)
- Verify: signature exposes a mutable type; callers mutate it
- Fix: return an immutable view, or expose query methods (`getParameter(name)` vs. `getParams().get(name)`)

### Config parameter exposing implementation
- Pattern: config option whose meaning requires knowing the implementation
- Verify: can the module derive a better value itself? Does any real caller ever set it to a non-default value?
- Fix: remove the parameter; use an internal default or derived value

### Multi-call sequence
- Pattern: callers must call `initX()` then `doX()` then `closeX()` in order
- Verify: grep call sites; the sequence is consistent
- Fix: one method that does the full operation; use context managers, RAII, or an explicit session object

### Exception as interface leak
- Pattern: new exception type thrown but not handled meaningfully by any caller — it just propagates
- Verify: grep for the exception; handler sites either re-wrap or ignore
- Fix: define the error out of existence at the source, mask it lower, or aggregate handlers at the highest common layer. Every exception is part of the interface.

---

## Pass 3 — Obviousness

### Generic name
- Pattern: identifier so broad it could match multiple things (`data`, `info`, `result`, `status`, `handler`, `process`, `Manager`, `Util`, `Helper`)
- Verify: can a reader guess the entity's role from the name alone?
- Fix: rename to describe purpose (`parsedConfig`, `remainingRetries`)

### Same word, different meanings
- Pattern: same identifier (`block`, `account`) used for distinct concepts in the same codebase
- Verify: grep the name; contexts diverge in non-trivial ways
- Fix: distinct names per concept. One concept, one name. Consider distinct types.

### Boolean with non-predicate name
- Pattern: `blinkStatus`, `mode`, `flag` — name does not tell you what `true` means
- Verify: can you infer the meaning of `true` from the name?
- Fix: rename to a predicate (`cursorVisible`, `isReadOnly`)

### Missing unit
- Pattern: `timeout`, `interval`, `size` with no unit in name or type
- Verify: grep uses; are they all in the same unit?
- Fix: rename (`timeoutMs`, `sizeBytes`) or wrap in a typed value

### Tuple or pair return
- Pattern: method returns `Pair<A, B>` or `Tuple[...]` with positional access
- Verify: callers use `.first` / `[0]` / destructuring
- Fix: named struct/dataclass with meaningful field names

### Action at a distance
- Pattern: constructor or method does something its name does not imply — spawns a thread, opens a file, mutates a global, registers a callback, starts I/O
- Verify: read the body; does it exceed what the name suggests?
- Fix: move the side effect to an explicitly-named method (`startWorker()`), or document it in the interface comment at every call site a reader might visit

### Supertype declaration, subtype allocation
- Pattern: `List<X> xs = new ArrayList<>();` — caller sees `List`, gets `ArrayList` semantics
- Verify: declaration type differs from allocation type in ways callers might depend on
- Fix: declare what you mean, or use `var`/`auto` to force the allocation type to travel

### Comment restates code
- Pattern: comment is the identifier name translated into English (`// gets the normalized resource name` above `getNormalizedResourceName`)
- Verify: can the comment be deleted without losing information?
- Fix: delete, or replace with information the code cannot express (preconditions, units, edge cases, rationale)

### Missing interface comment on non-trivial API
- Pattern: public method or class with no doc; callers must read the body to use it correctly
- Verify: walk public interfaces; note undocumented ones
- Fix: interface comment capturing preconditions, result semantics, edge cases, ownership. Write before implementing next time.

### Undocumented invariant
- Pattern: multiple call sites maintain a rule (e.g., "order fields must be set together") with no central documentation
- Verify: find 2-3 usages; infer the rule; confirm it is not written down
- Fix: add the invariant to the data structure's interface doc — better, enforce it in the type system

### Inconsistency introduction
- Pattern: new code uses a different style, pattern, or convention than surrounding code without a stated reason
- Verify: compare new choices (naming, error-handling pattern, declaration order) against the file's existing patterns
- Fix: conform to local convention. If the new convention is genuinely better, adopt it everywhere in a separate PR.

---

## Pass 4 — Strategic vs tactical

### Patch on patch
- Pattern: special-case branch added to work around a known issue, no comment, no broader fix
- Verify: new `if` guards a narrow condition; commit message describes a symptom, not a root cause
- Fix: document the workaround at the site and file a follow-up, OR refactor the design that caused the symptom

### Comment stale after edit
- Pattern: behavior changed; the nearest comment still describes the old behavior
- Verify: read the comment; read the code; they disagree
- Fix: update (or delete) the comment in the same commit. Stale comments are worse than no comment.

### Commit message does the commenting
- Pattern: subtle behavior explained in the commit message; nothing at the code site
- Verify: `git log -p` shows rich rationale, the code has none
- Fix: move the explanation into a code comment at the site. Commit messages are invisible to future debuggers.

### "We'll clean this up later"
- Pattern: explicit or implicit deferral in PR description, commit message, or `TODO` comment
- Verify: grep for `TODO`, `FIXME`, "later", "follow-up"
- Fix: either do it now, or the TODO must name a specific scope and an owner. "Later" without specifics is a lie.

### Change amplification
- Pattern: a single logical feature required edits in 5+ unrelated-looking files
- Verify: `git diff --stat` shows wide fan-out; the files have no shared abstraction
- Fix: usually not fixable in the current PR — flag as an observation. The design-quality issue is elsewhere.

### Tactical tornado evidence
- Pattern: PRs consistently ship features quickly but leave the system slightly messier than before
- Verify: read the commit history; watch for a pattern of special-case additions without generalization
- Fix: not a per-PR fix. Surface to leadership; this is a developer-habit issue, not a code issue.

---

## Meta: what NOT to flag

- Style / whitespace a linter would catch — skip
- Matters of taste with no APOSD grounding — skip
- Hypothetical future problems — skip; review the code that exists
- "Consider extracting a method" without a concrete reason — skip

## Meta: how to write fixes

- **Concrete, not aspirational.** "Rename `data` to `parsedConfig` at `foo.py:42`" beats "use a better name."
- **Minimal.** Suggest the smallest change that addresses the flag.
- **Honest about tradeoffs.** Some must-fixes have costs. Name them.
- **Author-agnostic.** The feedback is about the code, not the person.
