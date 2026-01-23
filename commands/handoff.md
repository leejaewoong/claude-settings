Custom command

Create handoff document to transfer work context to a new session.

## Process

1. Create `HANDOFF.md` file in project root (overwrite if exists)
2. Document current session work following the template below
3. Display manual instructions to user:
   - "`/clear` 명령으로 새 세션을 시작한 뒤, `Read HANDOFF.md and continue work`를 붙여넣으세요."

## HANDOFF.md Location
- Location: Project root
- Reason: Directly connected to project work context
- Recommended: Add HANDOFF.md to .gitignore

## HANDOFF.md File Management
- File not exists: Create new
- File exists: Overwrite (keep only latest state)
- After work completion: Recommend deletion

## HANDOFF.md Template

```markdown
# Session Handoff

## Work Context
- Project: [Project name]
- Original request: [User's original request]

## Attempted
- [Task 1]
- [Task 2]

## Succeeded
- [Completed task 1]
- [Completed task 2]

## Failed
- [Failed task 1]: [Failure reason]

## Next Steps
1. [Next task 1]
2. [Next task 2]

## Related Files
- [Important file paths]
```
