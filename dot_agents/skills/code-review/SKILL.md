---
name: code-review
description: Use after you are done doing a task. ONLY used when running from T3 Code.
---

# Guidelines

If the model is Claude, spin up a codex subagent and the other way around if it is OpenAI/Codex model.

# Review

After being done with a task, spin up a subagent to review the code. You must tell the agent to review the code for complexity, readability, correctness, and security. You should also explain to the subagent your overall intent with the changes so it has context to know the code does and can validate it correctly.
Once the subagent is done address the comments and spin up a new subagent again.
Go back and forth like this until you get two runs in a row that don't have any comments/issues with the code.


