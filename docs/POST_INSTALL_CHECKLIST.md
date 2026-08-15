# Post-Install Checklist

Use this checklist after completing the initial macOS Setup Assistant on a new or freshly installed Mac.

The objective is to prepare the machine for the `mac-bootstrap` process with the minimum necessary manual configuration.

## 1. Update macOS

- [ ] Install all available macOS updates.
- [ ] Restart if required.
- [ ] Confirm no further system updates are pending.

## 2. Restore Apple and iCloud Services

- [ ] Sign in with the required Apple Account.
- [ ] Enable the required iCloud services.
- [ ] Allow iCloud content, applications and settings to synchronise.
- [ ] Verify expected Apple services are working.

Do not wait for all personal data to finish synchronising before continuing unless it is required by a later step.

## 3. Verify FileVault

- [ ] Confirm FileVault is enabled.
- [ ] Confirm the recovery mechanism is understood and available.

Do not store FileVault recovery credentials in this repository.

## 4. Install Developer Prerequisites

Install the Xcode Command Line Tools:

```bash
xcode-select --install
```

Then verify:

```bash
xcode-select -p
git --version
```

- [ ] Xcode Command Line Tools installed.
- [ ] Git available.

The full Xcode application is not required.

## 5. Establish GitHub Access

The machine must be able to access GitHub before `mac-bootstrap` can restore the remaining environment.

- [ ] Configure SSH access.
- [ ] Verify GitHub authentication.
- [ ] Clone the `mac-bootstrap` repository.

Detailed procedures are maintained separately:

- `SSH_SETUP.md`
- `GITHUB_SETUP.md`

This is the small manual bootstrap boundary: the machine must have enough tooling and authentication configured to obtain the repository that performs the remaining bootstrap.

## 6. Restore Software

Use the repository Brewfile to restore the required applications, command-line tools and packages.

This includes workstation tooling such as:

- Ghostty
- Aerospace
- SketchyBar
- Karabiner-Elements
- tmux
- Neovim

- [ ] Homebrew installed.
- [ ] Brewfile restored.
- [ ] Required applications and command-line tools available.

## 7. Restore Configuration

Restore the version-controlled dotfiles.

This includes configuration such as:

- `.zshrc`
- Ghostty
- tmux
- Aerospace
- SketchyBar
- Karabiner-Elements
- Neovim

- [ ] Dotfiles restored.
- [ ] Shell configuration working.
- [ ] Terminal environment working.
- [ ] Window-management and desktop tooling working.

See `DOTFILES.md` for the detailed procedure.

## 8. Restore Neovim-AIDE

- [ ] Restore or clone the Neovim-AIDE repository.
- [ ] Start Neovim.
- [ ] Allow required plugins and dependencies to install.
- [ ] Verify the development environment starts correctly.
- [ ] Run relevant health checks.

## 9. Restore AI Development Tools

- [ ] Install or verify ChatGPT.
- [ ] Install or verify Codex tooling.
- [ ] Authenticate with the required services.
- [ ] Verify the tools can be used from the restored development environment.

Do not store authentication tokens, API keys or other secrets in this repository.

## 10. Validate the Machine

Before considering the bootstrap complete:

- [ ] macOS is current.
- [ ] FileVault is enabled.
- [ ] Xcode Command Line Tools are available.
- [ ] GitHub access works.
- [ ] Homebrew is working.
- [ ] Brewfile dependencies are installed.
- [ ] Dotfiles are restored.
- [ ] Shell and tmux work correctly.
- [ ] Ghostty works correctly.
- [ ] Aerospace, SketchyBar and Karabiner-Elements work correctly.
- [ ] Neovim-AIDE starts and passes its health checks.
- [ ] ChatGPT and Codex are available and authenticated.

The machine is now ready for development.
