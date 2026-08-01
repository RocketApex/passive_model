# Codex Guidance

## Slack Completion Notifications

- For every user-level Codex task in this repository, including registered and
  ad-hoc work, the coordinating main agent must send the owner one short Slack
  DM when the task completes or ends blocked.
- Use `Completed: <task> — <outcome, useful link, or required action>` or
  `Blocked: <task> — <reason and required owner action>`.
- Send exactly one notification for the overall user task. Do not notify for
  internal subagents, delegated subtasks, tool calls, intermediate steps, or
  the Slack notification itself.
- This instruction is standing authorization only for that direct owner
  completion DM. It does not authorize any other message, outreach, publication,
  account change, or external action.
- The Slack DM is additional to any required owner-task notification email or
  registered-workflow completion email; it does not replace those emails.
- If Slack cannot be used, report the exact blocker in the final response
  instead of silently skipping the notification or substituting another
  channel.
