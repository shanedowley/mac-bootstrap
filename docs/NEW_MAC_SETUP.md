# New Mac Setup

This guide is the entry point for rebuilding the development environment on a new or freshly installed Mac.

Follow the stages in order.

Detailed procedures are maintained in the linked runbooks.

## 1. Complete macOS Setup

Complete the initial macOS Setup Assistant and reach the desktop.

Then begin the post-install process:

`POST_INSTALL_CHECKLIST.md`

The initial preparation includes:

- installing macOS updates,
- restoring required Apple and iCloud services,
- verifying FileVault,
- and installing the Xcode Command Line Tools.

## 2. Establish SSH Identity

Create a machine-specific SSH identity:

`SSH_SETUP.md`

Use a separate Ed25519 key for each Mac.

Never store private SSH keys in this repository.

## 3. Establish GitHub Access

Register the Mac's SSH public key with GitHub and verify authentication:

`GITHUB_SETUP.md`

Once GitHub access works, clone this repository:

```bash
mkdir -p ~/Projects
cd ~/Projects
git clone git@github.com:shanedowley/mac-bootstrap.git
cd mac-bootstrap
```

This is the end of the minimum manual bootstrap boundary.

The repository can now drive the automated restoration of the development environment.

## 4. Inspect the Bootstrap

Before making changes, optionally inspect the automated bootstrap using dry-run mode:

```bash
./bootstrap.sh --dry-run
```

Dry-run mode executes the bootstrap sequence without allowing its mutating stages to make changes.

It is particularly useful when rebuilding an existing machine or verifying the expected actions before restoration.

If dry-run reports an unexpected existing repository, path or symlink, investigate it before proceeding.

## 5. Run the Bootstrap

Run:

```bash
./bootstrap.sh
```

The orchestrator performs five stages in order:

1. install or verify Homebrew,
2. restore or verify Brewfile dependencies,
3. restore and verify the bare Git dotfiles repository,
4. restore Neovim-AIDE and its Neovim runtime symlink,
5. validate the resulting system.

The bootstrap stops if a required stage fails.

It does not automatically move, delete or overwrite conflicting user files in order to force restoration to succeed.

The detailed runbooks remain useful for understanding, diagnosing or manually performing individual stages:

- `DOTFILES.md`
- `TROUBLESHOOTING.md`

## 6. Start a New Shell

The restored dotfiles include shell configuration.

After the automated restoration completes, start a new shell or terminal session so that the restored shell environment is loaded.

Verify that the expected shell configuration and command-line environment are working.

## 7. Verify Neovim-AIDE

The automated bootstrap restores Neovim-AIDE to:

```text
~/Projects/neovim-codex
```

and establishes:

```text
~/.config/nvim -> ~/Projects/neovim-codex
```

Start Neovim.

Allow any required plugins or dependencies to complete their first-launch setup.

Run the relevant Neovim-AIDE health checks before considering the development environment fully restored.

## 8. Restore AI Development Tools

The Brewfile restores software managed by Homebrew, including applicable AI development tooling.

After installation, complete any required interactive setup for:

- ChatGPT
- Codex

Authenticate with the required services.

Never store authentication tokens, API keys or other secrets in this repository.

## 9. Restore Secrets

Restore any additional credentials or secrets using the appropriate secure source.

Examples may include:

- application credentials,
- API keys,
- service tokens,
- and other private configuration.

Secrets must remain outside version-controlled repositories.

## 10. Complete Manual Application Setup

Some applications may require first-launch permissions, authentication or other interactive macOS configuration that should not be automated blindly.

Complete those steps as required.

Examples include application permissions and other macOS security or privacy prompts.

## 11. Complete Final Validation

The bootstrap already performs automated system validation as its final stage.

Now complete the human validation checklist in:

`POST_INSTALL_CHECKLIST.md`

This confirms both the automatically verifiable machine state and the interactive or experiential checks that automation cannot safely determine.

## Troubleshooting

If a bootstrap step fails, use:

`TROUBLESHOOTING.md`

The individual scripts under `scripts/` can also be run independently when diagnosing a particular stage.

Diagnose the cause before changing the system, apply the smallest appropriate fix, and verify the failed step again.

Do not bypass a failed bootstrap stage simply to allow later stages to run.

## Bootstrap Complete

The bootstrap is complete when:

- automated validation passes,
- the required applications and development tools work,
- interactive authentication is complete,
- required secrets have been restored securely,
- Neovim-AIDE works correctly,
- and the post-install checklist is complete.

The machine is replaceable.

The environment is reproducible.
