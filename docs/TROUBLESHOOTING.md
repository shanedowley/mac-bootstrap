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

## Known Problems

### Bare Dotfiles Checkout Hangs

**Symptoms**

- `git checkout` against the bare dotfiles repository does not complete.
- No dotfiles are written to the working tree.
- The Git process remains running with an `index.lock`.
- The process may also hold a Unix socket.

**Cause**

The effective Git configuration enables filesystem monitoring:

```text
core.fsmonitor=true
```

This may be inherited from the global Git configuration.

For the dotfiles architecture used here — a bare repository with the home directory supplied separately as the working tree — filesystem monitoring must be disabled locally before checkout.

**Diagnosis**

Inspect the effective Git configuration:

```bash
git --git-dir="$HOME/.dotfiles" config --list --show-origin
```

Inspect the repository-local setting:

```bash
git --git-dir="$HOME/.dotfiles" config --get core.fsmonitor
```

If a checkout is already hanging, inspect the Git process:

```bash
ps -ax -o pid,ppid,stat,etime,command | grep -E '[g]it.*checkout'
```

**Resolution**

Stop the hanging checkout if required.

Configure the bare repository to disable filesystem monitoring locally:

```bash
git --git-dir="$HOME/.dotfiles" config core.fsmonitor false
```

Retry the checkout:

```bash
git --git-dir="$HOME/.dotfiles" \
  --work-tree="$HOME" \
  checkout
```

**Verification**

Confirm the repository-local setting:

```bash
git --git-dir="$HOME/.dotfiles" config --get core.fsmonitor
```

Expected:

```text
false
```

Verify that repository status completes normally and is clean:

```bash
git --git-dir="$HOME/.dotfiles" \
  --work-tree="$HOME" \
  status --short
```

Expected: no output.

## General Recovery

If the cause of a failure is unclear:

- Stop before making unrelated changes.
- Read the command output carefully.
- Confirm the current system state.
- Check the relevant runbook.
- Prefer fixing the failed step rather than bypassing it.
- Re-run the step and verify the result.

Do not store credentials, tokens, private keys or other secrets in troubleshooting examples.
