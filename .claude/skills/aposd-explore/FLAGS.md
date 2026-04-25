# APOSD Flag Catalog (explore mode)

Lookup during the explore pass. Each flag has a pattern (what it looks like), a verification check (how to confirm), and the symptom it produces.

---

## Change-amplification markers

### Parallel magic values
- Pattern: same literal (`1024`, `"admin"`, a timeout) appears in 3+ files
- Verify: `grep -rn <literal> <scope>`; count hits
- Symptom: future changes must touch every site; one will be missed

### Coupled format knowledge
- Pattern: two or more classes reference the same wire/file/protocol internals
- Verify: search for format-specific tokens; confirm both modules parse or construct them
- Symptom: format changes force coordinated edits across the boundary (classic temporal decomposition)

### Repeated call-site boilerplate
- Pattern: every caller wraps a module call in the same pre- or post-processing
- Verify: grep call sites; the surrounding lines are near-identical
- Symptom: complexity pushed up instead of absorbed by the module

---

## Cognitive-load markers

### Shallow module
- Pattern: public interface roughly the size of the implementation; method bodies 1-3 lines; methods are thin wrappers
- Verify: count public methods; count non-blank body lines; ratio ≥ 0.3 methods/line
- Specific form: **classitis** — many small classes that always appear together (e.g., Java stream chains)

### Pass-through method
- Pattern: method body is a single delegation with a matching or near-matching signature
- Verify: body is 1-2 lines calling another method with the same args
- Symptom: layer with no abstraction change; pure overhead. (Dispatchers that select among implementations based on args are the exception.)

### Pass-through variable
- Pattern: parameter threaded through 3+ frames, unused in intermediate frames
- Verify: trace a parameter through the call graph; count frames that pass it without reading it
- Symptom: every intermediate layer now knows about something it doesn't use

### Conjoined methods
- Pattern: method A cannot be understood or used correctly without reading method B
- Verify: call sites always pair A with B, or A's doc must reference B's contract
- Symptom: one responsibility was split into two; readers must hold both in their head

### Generic name
- Pattern: identifier so broad it matches multiple things (`data`, `info`, `result`, `handler`, `Manager`, `Util`, `Helper`)
- Verify: can a first-time reader guess the entity's role from the name alone?
- Symptom: every reference requires a context lookup

### Similar-but-different names
- Pattern: two names differ by a single letter or word, but denote different things (`block` vs `blockNum`; `struct socket` vs `struct sock`)
- Verify: see if code mixes them in ways that would be incorrect
- Symptom: silent misuse that no compiler catches

---

## Unknown-unknown markers

### Undocumented unit
- Pattern: numeric field/parameter with no unit in name or type (`timeout`, `size`, `interval`)
- Verify: grep the field; check whether all uses agree on unit
- Symptom: Mars Climate Orbiter class of bug — discoverable only at integration time

### Undocumented invariant
- Pattern: multiple call sites maintain a relationship (e.g., "if `x.foo` is set, `x.bar` must be set") with no written rule
- Verify: find 2-3 usages; infer the rule; confirm it is not documented anywhere
- Symptom: invariant lives in culture, not code; breaks when culture turns over

### Action at a distance
- Pattern: constructor or seemingly-simple method spawns threads, registers handlers, mutates globals, opens files, initiates I/O
- Verify: read the body; does it exceed what the name implies?
- Symptom: readers cannot reason locally; behavior appears out of nowhere

### Hidden dependency
- Pattern: module A relies on module B via shared global, file, or implicit ordering — never imports or calls B directly
- Verify: remove B and trace what breaks in A
- Symptom: dependency is invisible until you remove it

### Information leakage
- Pattern: the same design decision (format, protocol, invariant, algorithm choice) is present in 2+ modules
- Verify: grep for key tokens or the decision's shape; confirm both modules would need to change for the same reason
- Symptom: temporal decomposition, usually — modules organized by *when* rather than by *what knowledge they own*

### Returning internal representation
- Pattern: method returns a reference to an internal collection or structure (`return this.params`)
- Verify: signature shows a mutable type; callers can (and do) mutate it
- Symptom: representation becomes part of the contract; you cannot change it

---

## Depth verification checks

When torn between calling a module deep or shallow:

1. **Interface-vs-implementation gap.** For each public method, how many internal branches + helper calls does it mediate? A 1-line method with a 1-line doc is shallow. A 2-line doc with a 150-line, well-encapsulated body is deep.
2. **Single-reason-to-change.** Does one caller requirement change one module only (deep), or cascade (shallow)?
3. **Usable from the doc alone.** Can you correctly invoke this without reading the body? Private/protected keywords are irrelevant — hiding is behavioral, not syntactic.

---

## What to include in the map

- Every flag with a file:line citation and a one-line observation
- At least one concrete verification quote per flag (code excerpt, grep count, git-log summary)
- Skip "possibly" flags. If you cannot point at the code, you cannot flag it.
- Where two flags have the same root cause, group them — one root cause, multiple symptoms is common
