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

The remaining bootstrap process can now be driven from this repository.

## 4. Restore Software

Install Homebrew if it is not already available.

Restore the software inventory using the repository Brewfile.

```bash
brew bundle --file=./Brewfile
```

Verify that the required applications and command-line tools are available.

Automation for this stage will be introduced later.

## 5. Restore Configuration

Restore the version-controlled user configuration:

`DOTFILES.md`

The dotfiles repository uses:

```text
Git directory: ~/.dotfiles
Working tree:  ~
```

After restoration, start a new shell and verify that the expected configuration loads correctly.

## 6. Restore Development Projects

Restore the required project repositories under:

```text
~/Projects
```

This includes Neovim-AIDE.

Start Neovim and allow any required plugins or dependencies to install.

Run the relevant Neovim-AIDE health checks before considering the development environment restored.

## 7. Restore AI Development Tools

Install or verify the required AI development tools, including:

- ChatGPT
- Codex

Authenticate with the required services.

Never store authentication tokens, API keys or other secrets in this repository.

## 8. Restore Secrets

Restore any additional credentials or secrets using the appropriate secure source.

Examples may include:

- application credentials,
- API keys,
- service tokens,
- and other private configuration.

Secrets must remain outside version-controlled repositories.

## 9. Validate the Environment

Complete the validation section in:

`POST_INSTALL_CHECKLIST.md`

Confirm that the machine is ready for development and that the expected tooling, configuration and authentication are working.

## Troubleshooting

If a bootstrap step fails, use:

`TROUBLESHOOTING.md`

Diagnose the cause before changing the system, apply the smallest appropriate fix, and verify the failed step again.

## Bootstrap Complete

The bootstrap is complete when the development environment is working and can be explained entirely by the documented sources used to reconstruct it.

The machine is replaceable.

The environment is reproducible.
