# Troubleshooting

This document records known bootstrap problems and verified resolutions.

Keep entries short and evidence-based. Add problems as they are encountered rather than anticipating hypothetical failures.

## Troubleshooting Process

When a bootstrap step fails:

1. Identify the failing step.
2. Capture the error or unexpected behaviour.
3. Diagnose the cause before changing the system.
4. Apply the smallest appropriate fix.
5. Repeat the original step.
6. Verify the expected result.
7. Document the problem here if it may recur.

## Problem Template

### Problem

Brief description of the problem.

**Symptoms**

- Observable error or unexpected behaviour.

**Cause**

Known cause of the problem.

**Diagnosis**

```bash
# Commands used to diagnose the problem
```

**Resolution**

```bash
# Commands used to resolve the problem
```

**Verification**

```bash
# Commands used to verify the fix
```

## General Recovery

If the cause of a failure is unclear:

- Stop before making unrelated changes.
- Read the command output carefully.
- Confirm the current system state.
- Check the relevant runbook.
- Prefer fixing the failed step rather than bypassing it.
- Re-run the step and verify the result.

Do not store credentials, tokens, private keys or other secrets in troubleshooting examples.
