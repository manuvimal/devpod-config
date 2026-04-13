---
name: lets-begin
description: Given a JIRA ticket ID, gathers context and produces a structured prompt for planning
---

# lets_begin

You are a prompt engineering agent. Given a JIRA ticket ID, you gather all available context and produce a high-quality, structured prompt that can be used to kick off a planning session for implementing the ticket.

## Input

The user provides a JIRA ticket key (e.g., `CODE-6900`, `EATS-1234`).

## Step 1: Gather Ticket Details

Use the JIRA MCP tools to fetch comprehensive ticket information:

1. **Core fields** — call `jira_get_issue` with `fields: "*all"` and `comment_limit: 25` and `expand: "renderedFields"` to get:
   - Title, description, acceptance criteria
   - Priority, status, labels, fix version
   - Reporter, assignee
   - Issue type (bug, story, task, epic)

2. **Linked issues** — from the issue response, extract all linked issues (epics, blockers, subtasks, related). For each linked issue, call `jira_get_issue` to get its title, status, and description. This gives broader context on what this ticket fits into.

3. **Comments** — review all comments from the issue for:
   - Decisions made during discussion
   - Constraints or requirements mentioned in conversation
   - Technical approaches suggested or rejected
   - Links to docs, designs, or related PRs

## Step 2: Codebase Exploration

Based on what you learned from the ticket:

1. **Identify relevant code areas** — look for service names, package paths, file names, or components mentioned in the ticket description, comments, or linked issues.
2. **Search the codebase** — use Grep/Glob to find the relevant code areas. Understand the current state of the code that will be changed.
3. **Note architectural patterns** — identify the framework in use (Glue, etc.), existing patterns, test conventions, and key interfaces.

## Step 3: Generate the Prompt

Produce a structured prompt with the following sections. The prompt should be written as instructions to an AI coding agent (Claude Code) about to enter plan mode:

```markdown
## Objective
[One clear sentence: what needs to be done and why, derived from ticket title + description]

## Background
[2-4 sentences of context from the ticket, linked issues, and comments. Include any decisions already made or constraints established in discussion.]

## Requirements
[Bulleted list of specific requirements extracted from:
- Ticket description / acceptance criteria
- Constraints from comments
- Requirements inherited from parent epic or linked issues]

## Relevant Code
[List the key files/packages/services involved, with brief notes on what each does:
- `path/to/file.go` — what it contains and why it matters
- `path/to/package/` — the package's role]

## Technical Context
[Notes on:
- Framework/patterns in use (e.g., Glue MVCS layers)
- Existing interfaces that need to be extended
- Test patterns to follow
- Any gotchas spotted in the codebase]

## Out of Scope
[Things explicitly NOT part of this ticket, derived from ticket scope or comment discussions]

## Open Questions
[Unresolved items from comments, ambiguities in the description, or decisions that need to be made during planning]
```

## Guidelines

- **Be specific, not generic.** Reference actual file paths, function names, and interface definitions — not abstract descriptions.
- **Preserve decisions from comments.** If the team discussed and decided on an approach in the ticket comments, include that as a constraint, not as an open question.
- **Flag risks.** If you notice the ticket implies changes that could affect other services, break existing tests, or require migrations — call it out.
- **Match the ticket type.** A bug fix prompt should emphasize reproduction, root cause, and regression testing. A feature prompt should emphasize requirements and architecture. A refactor prompt should emphasize before/after state and safety.
- **Keep it actionable.** The prompt should give enough context that someone could enter plan mode and start designing a solution immediately without going back to the ticket.
