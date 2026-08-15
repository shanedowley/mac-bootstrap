# Working Agreement

This repository is developed using a small set of engineering principles intended to keep the bootstrap process understandable, reproducible and safe.

## Principles

- Documentation before automation.
- Understand a step before scripting it.
- Prefer small, verifiable changes.
- Prefer reproducibility over convenience.
- Prefer explicit behaviour over cleverness.
- Use infrastructure as code where practical.
- Never store secrets or credentials in Git.
- Keep scripts focused on one responsibility.
- Make scripts idempotent where practical.
- Fail clearly and print useful progress.
- Avoid hidden side effects.
- Validate results before declaring success.
- Prefer rebuilding a machine to cloning an existing one.

## How We Work

Changes should be introduced incrementally.

For each significant bootstrap step:

1. Document the manual process.
2. Perform and validate it.
3. Automate it only when the process is understood and stable.
4. Keep the automated step independently runnable where practical.
5. Update the documentation when behaviour changes.

## Definition of Success

A successful bootstrap should produce a development environment that is:

- reproducible,
- understandable,
- maintainable,
- recoverable from version-controlled sources,
- and not dependent on the history of a particular Mac.

The objective is not magic automation.

It is a well-documented, trustworthy way to rebuild the machine.
