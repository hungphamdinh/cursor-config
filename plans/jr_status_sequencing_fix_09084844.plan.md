---
name: JR status sequencing fix
overview: Fix JR status-group sequencing semantics for `nextAllowedGroupIds=''` and add a unit test to lock it in. Then commit and push all changes except the untracked `environment.toml`.
todos:
  - id: fix-helper-semantics
    content: Update `App/Screens/JobRequest/AddOrEditJobRequest/useJRStatusGroup.js` so `nextAllowedGroupIds=''` yields `allowedGroupIds=[]` (strict same-group), while `nextAllowedGroupIds==null` still falls back to legacy.
    status: in_progress
  - id: extend-tests-empty-next
    content: Update `App/Screens/JobRequest/AddOrEditJobRequest/__test__/statusWorkflow.helper.spec.js` with a new test asserting that `currentStatusId` whose `nextAllowedGroupIds` is `''` returns only statuses from the same `groupId`.
    status: in_progress
  - id: validate-tests
    content: Run Jest for the `AddOrEditJobRequest` specs and the helper spec to ensure the new behavior passes.
    status: pending
  - id: commit-except-env
    content: Stage all changes excluding `.codex/environments/environment.toml`, commit with a descriptive message, and verify `git status` is clean for those files.
    status: pending
  - id: push-origin
    content: Push the commit to `origin` on `features/PDHung/P3-54998-Job-request-status-sequencing`.
    status: pending
isProject: false
---

## What I’m changing

- Update `useJRStatusGroup` so empty `nextAllowedGroupIds` means “no next groups” (strictly allow same `groupId`), instead of falling back to the full legacy list.
- Extend the helper unit tests to cover the `currentStatusId` whose `nextAllowedGroupIds` is empty.

## Files

- `[App/Screens/JobRequest/AddOrEditJobRequest/useJRStatusGroup.js](App/Screens/JobRequest/AddOrEditJobRequest/useJRStatusGroup.js)`
- `[App/Screens/JobRequest/AddOrEditJobRequest/__test__/statusWorkflow.helper.spec.js](App/Screens/JobRequest/AddOrEditJobRequest/__test__/statusWorkflow.helper.spec.js)`
- (No behavior change needed) `[App/Screens/JobRequest/AddOrEditJobRequest/index.js](App/Screens/JobRequest/AddOrEditJobRequest/index.js)`, `[App/Type/jobRequest.js](App/Type/jobRequest.js)`
- Include (new tests) `[App/Screens/JobRequest/AddOrEditJobRequest/__test__/AddOrEditJobRequest.spec.js](App/Screens/JobRequest/AddOrEditJobRequest/__test__/AddOrEditJobRequest.spec.js)` and the moved spec deletion already in git.

## Implementation details (helper semantics)

In `getMoveForwardStatusOptions`, I will:

- Make `parseAllowedGroupIds()` return `null` when `nextAllowedGroupIds` is `null/undefined` (metadata missing), but return `[]` when it is an empty string `''`.
- Change the fallback condition from `allowedGroupIds.length === 0` to `allowedGroupIds == null`.
This preserves strict validation: if next groups are explicitly empty, only same-group statuses are allowed.

## Commit / Push

- Stage and commit everything except the untracked `/.codex/environments/environment.toml` (which will be ignored).
- Run Jest for the related specs.
- Commit on `features/PDHung/P3-54998-Job-request-status-sequencing` and push to `origin`.

```js
// in App/.../useJRStatusGroup.js
// old (too permissive)
if (!currentStatus || currentGroupId == null || allowedGroupIds.length === 0) return normalizedStatuses;

// new (strict)
if (!currentStatus || currentGroupId == null || allowedGroupIds == null) return normalizedStatuses;
```

