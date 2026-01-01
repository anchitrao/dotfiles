---
name: diataxis
description: Framework for creating technical documentation following the Diátaxis methodology. Use when writing documentation, organizing docs, creating tutorials, how-to guides, reference material, or explanations. Helps structure content based on user needs (learning vs working, acquiring vs applying).
---

# Diátaxis Documentation Framework

Diátaxis is a systematic approach to technical documentation that organizes content into four types based on user needs.

## The Four Documentation Types

Documentation serves users in two fundamental modes: **study** (acquiring knowledge) and **work** (applying knowledge). Combined with whether content is **practical** (action-oriented) or **theoretical** (cognition-oriented), this creates four distinct types:

```
                Learning-oriented          Goal-oriented
                (acquisition)              (application)
              ┌─────────────────┬─────────────────────┐
Practical     │   TUTORIALS     │   HOW-TO GUIDES    │
(action)      │   Learning      │   Tasks/Goals      │
              ├─────────────────┼─────────────────────┤
Theoretical   │  EXPLANATION    │    REFERENCE       │
(cognition)   │  Understanding  │   Information      │
              └─────────────────┴─────────────────────┘
```

### Tutorials (Learning-Oriented)

**Purpose**: Provide a successful learning experience for beginners

**Characteristics**:
- Takes learner by the hand through step-by-step exercises
- Teacher is responsible for learner's safety and success
- Must be reliably repeatable with guaranteed outcomes
- Single path with no choices or branches
- Focus on doing, not explaining
- Concrete, meaningful accomplishments
- Safe to restart from beginning

**Writing approach**:
- Use imperative mood: "First, do X. Now do Y."
- Provide what to do, not why (link to explanation for details)
- Allow user to learn through action, not passive reading
- Describe what learner will accomplish (not "you will learn...")
- Minimal explanation in simplest language
- No digressions or alternatives

**Example**: "Build your first web app" - Takes complete beginner through creating a functioning application

### How-To Guides (Goal-Oriented)

**Purpose**: Help competent users accomplish specific tasks

**Characteristics**:
- Addresses already-competent practitioners at work
- Focuses on solving specific problems
- Branches and forks for different approaches
- Reliability matters more than completeness
- Assumes user can join guide to their own work
- User has responsibility for success
- Defined by user needs, not machinery operations

**Writing approach**:
- Title clearly states goal: "How to [accomplish specific task]"
- Use conditional imperatives: "If X, do Y"
- Start/end at reasonable points (user provides context)
- Focus only on the task - omit extraneous details
- Show what user needs to do with tools at hand
- Address how user thinks, not just what they do

**Example**: "How to configure OAuth authentication" - Helps experienced developer solve a specific problem

### Reference (Information-Oriented)

**Purpose**: Provide accurate technical descriptions for users at work

**Characteristics**:
- Contains factual, propositional knowledge
- Neutral, unbiased technical descriptions
- Consulted while working (not read cover-to-cover)
- Free from interpretation or opinion
- Comprehensive and accurate
- Structured for quick lookup
- Describes the machinery itself

**Writing approach**:
- Use neutral tone and factual statements
- Structure consistently (alphabetically, logically)
- Be complete and accurate
- Do not explain or instruct
- Focus on technical precision
- Examples only for illustration, not expansion

**Example**: API documentation, parameter lists, class references

### Explanation (Understanding-Oriented)

**Purpose**: Illuminate topics and deepen understanding

**Characteristics**:
- Read away from the work (e.g., "in the bath")
- Higher, wider perspective than other types
- Addresses "why" questions and design decisions
- Makes connections across topics
- Can include opinion and alternatives
- Bounded by reasonable topic scope
- Understanding-oriented, not action-oriented

**Writing approach**:
- Title with implicit "About": "About X"
- Provide context, background, history
- Explain design decisions and constraints
- Consider alternatives and multiple perspectives
- Make connections to related concepts
- Discuss implications and trade-offs

**Example**: "About database indexing strategies" - Explains why different approaches exist and when to use each

## Critical Distinctions

### Tutorials vs How-To Guides

Both are practical and action-oriented, but serve different needs:

| Aspect | Tutorial | How-To Guide |
|--------|----------|--------------|
| User mode | At study | At work |
| User level | Beginner | Competent |
| Responsibility | Teacher | User |
| Path | Single linear | Branches/forks |
| Safety | Must be safe | May have risks |
| Scope | Complete lesson | Specific task |

### Reference vs Explanation

Both are knowledge-oriented, but serve different modes:

| Aspect | Reference | Explanation |
|--------|-----------|-------------|
| User mode | Working | Studying |
| Purpose | Lookup facts | Understand why |
| Tone | Neutral | Discursive |
| Reading | During work | Away from work |
| Structure | Organized facts | Topical exploration |

## Common Documentation Problems

**Mixing types causes confusion**:
- Tutorial that digresses into explanation → Interrupts learning flow
- How-to guide with reference details → Obscures the task
- Reference that becomes tutorial → Loses neutrality
- Explanation with step-by-step instructions → Confuses purpose

**Keep types separate** - If security documentation is needed:
- Reference: Facts about security features
- Tutorial: Learn to implement basic authentication
- How-to: Configure SSL certificates
- Explanation: About authentication architecture decisions

## Writing Process

1. **Identify user need**: Are they learning or working? Acquiring or applying?
2. **Choose type**: Match documentation type to that need
3. **Stay focused**: Keep content pure to its type
4. **Cross-reference**: Link between types when users need to transition
5. **Organize clearly**: Make type boundaries visible in structure

## Key Principles

- **User needs first**: Structure around what users need, not machinery features
- **Keep types distinct**: Crossing boundaries creates confused documentation
- **Serve both modes**: Support users at study AND at work
- **Enable discovery**: Clear organization helps users find what they need
- **Think systematically**: Each type has specific purpose, audience, and style
