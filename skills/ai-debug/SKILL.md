---
name: ai-debug
description: General debugging workflow for app and API issues using autonomous file logging and trace collection. Use when users report regressions, hard-to-reproduce bugs, API/state mismatches, Redux/reducer/selector anomalies, payload mapping issues, or ask AI to investigate and track root cause without requiring manual log collection.
---

# AI Debug

Follow this workflow to debug issues end-to-end while minimizing user effort.

## 1) Set Up File Logging (Simulator-first)

- Add scoped debug logging only in the suspected path.
- Write logs to simulator-accessible file storage (for React Native use `RNFS.DocumentDirectoryPath`).
- Use a deterministic log path and tag format:
  - Folder: `logs`
  - File: `ai-debug.log`
  - Entry format: `[TAG] <ISO time> <JSON payload>`
- Ensure directory exists before append.
- Use append mode; do not overwrite by default.

Example helper shape (adapt to project conventions):

```js
const DEBUG_DIR = `${RNFS.DocumentDirectoryPath}/logs`;
const DEBUG_FILE = `${DEBUG_DIR}/ai-debug.log`;

const appendDebugLog = async (tag, payload) => {
  const line = `${new Date().toISOString()} ${tag} ${JSON.stringify(payload)}\n`;
  await RNFS.mkdir(DEBUG_DIR);
  await RNFS.appendFile(DEBUG_FILE, line, 'utf8');
};
```

## 2) Log from All Relevant Layers

Capture high-value checkpoints across the real execution chain:

- UI trigger (user action + screen/context)
- local business logic/transformer decisions
- Redux action dispatch + reducer result summary
- selector/state-to-props output (if applicable)
- outgoing API payload and request metadata
- API response (status/body summary + error shape)
- post-response mapping/rendered state

Default to concise summaries. If root cause is still unclear, temporarily escalate to deeper structured snapshots for only the suspicious branch.

Prefer fields that make correlation possible:

- identifiers (`id`, `remoteId`, `formPageId`, request id, correlation id)
- control flags (`actionType`, `isAddNew`, `isDirty`, feature toggles)
- changed paths / diff summary
- key derived values that drive branching

## 3) Pull and Read Logs Yourself (No User Tracking)

Never ask the user to track logs if this skill is active. Retrieve and summarize logs directly.

Preferred approach:

1. Find app container path for current booted simulator.
2. Read `Documents/logs/ai-debug.log`.
3. Summarize sequence, anomalies, and candidate root cause.

If direct path access is blocked, use the best available fallback in the same environment and report that fallback explicitly.

## 4) Compare Expected vs Actual Flow

For each failure case, produce a compact sequence:

1. user action
2. computed diff/decision
3. payload sent
4. backend response
5. local state after response

Call out the first step where behavior diverges from expected and identify the owning layer (UI, local logic, Redux, API, mapping).

## 5) Patch Minimally

- Keep fixes localized to the proven fault line.
- Preserve payload contracts unless bug requires contract change.
- Remove temporary noisy logs after fix, but keep one guarded debug helper if ongoing monitoring is useful.

## 6) Report Back

Always return:

- Root cause (or strongest hypothesis with evidence)
- Exact file(s)/line area changed
- What logs proved the issue
- What validation ran and result
- Any residual risk

## Guardrails

- Avoid broad refactors during incident debugging.
- Avoid logging sensitive personal data.
- Do not commit/push unless explicitly requested.
- If multiple modules are involved, isolate one failing path first, then expand.
- Keep logs deterministic and easy to diff between runs (stable tags and ordering).
