# Post-Install Checklist

Use this checklist when rebuilding a new or freshly installed Mac.

The checklist spans the complete rebuild: the small manual bootstrap boundary, automated restoration, and final human verification.

The detailed end-to-end procedure is maintained in:

`NEW_MAC_SETUP.md`

## 1. Prepare macOS

- [ ] Complete the initial macOS Setup Assistant.
- [ ] Install all available macOS updates.
- [ ] Restart if required.
- [ ] Confirm no further required system updates are pending.
- [ ] Sign in with the required Apple Account.
- [ ] Enable the required iCloud services.
- [ ] Verify FileVault is enabled.
- [ ] Confirm the FileVault recovery mechanism is understood and available.

Do not store FileVault recovery credentials in this repository.

## 2. Install Developer Prerequisites

Install the Xcode Command Line Tools if required:

```bash
xcode-select --install
```

Verify:

```bash
xcode-select -p
git --version
```

- [ ] Xcode Command Line Tools installed.
- [ ] Git available.

The full Xcode application is not required.

## 3. Establish SSH and GitHub Access

The machine must be able to access GitHub before `mac-bootstrap` can restore the remaining environment.

- [ ] Create the machine-specific SSH identity.
- [ ] Register the public key with GitHub.
- [ ] Verify GitHub SSH authentication.
- [ ] Clone the `mac-bootstrap` repository.

Detailed procedures are maintained in:

- `SSH_SETUP.md`
- `GITHUB_SETUP.md`

At this point the minimum manual bootstrap boundary is complete.

## 4. Run the Automated Bootstrap

From the `mac-bootstrap` repository, optionally inspect the intended actions first:

```bash
./bootstrap.sh --dry-run
```

Then run:

```bash
./bootstrap.sh
```

The bootstrap restores or verifies Homebrew, Brewfile dependencies, dotfiles, Neovim-AIDE and the Neovim runtime link before performing automated system validation.

- [ ] `./bootstrap.sh` completes successfully.
- [ ] Automated validation reports `System validation passed.`

If the bootstrap fails, diagnose the failed stage before continuing.

See `TROUBLESHOOTING.md` for guidance.

## 5. Verify Shell and Terminal Environment

Start a new shell or terminal session after dotfiles restoration.

- [ ] Restored Zsh configuration loads correctly.
- [ ] Ghostty starts and behaves as expected.
- [ ] tmux starts and behaves as expected.
- [ ] Expected shell commands and aliases are available.

## 6. Verify Desktop Tooling

Confirm the restored workstation applications and configuration operate correctly.

- [ ] Aerospace works correctly.
- [ ] SketchyBar works correctly.
- [ ] Karabiner-Elements works correctly.
- [ ] Required macOS permissions have been granted.

Complete any first-launch or macOS security/privacy prompts manually where required.

## 7. Verify Neovim-AIDE

Confirm the restored repository and runtime environment work in actual use.

- [ ] Neovim starts successfully.
- [ ] `~/.config/nvim` resolves to `~/Projects/neovim-codex`.
- [ ] Required plugins and dependencies are installed.
- [ ] Neovim-AIDE loads correctly.
- [ ] Relevant Neovim-AIDE health checks pass.
- [ ] Normal editing and development workflows operate correctly.

## 8. Restore and Verify AI Development Tools

Complete any required interactive installation or authentication that cannot be safely automated.

- [ ] ChatGPT is installed and available.
- [ ] ChatGPT authentication is complete.
- [ ] Codex tooling is available.
- [ ] Codex authentication is complete.
- [ ] AI development tools work from the restored environment.

Never store authentication tokens, API keys or other secrets in this repository.

## 9. Restore Required Secrets

Restore additional credentials and secrets from their appropriate secure source.

These may include:

- application credentials,
- API keys,
- service tokens,
- and other private configuration.

- [ ] Required secrets restored.
- [ ] Applications or tools depending on those secrets work correctly.
- [ ] No secrets have been added to version-controlled repositories.

## 10. Final Machine Acceptance

Before considering the rebuild complete:

- [ ] macOS is current.
- [ ] FileVault is enabled.
- [ ] GitHub access works.
- [ ] Homebrew is working.
- [ ] Brewfile dependencies are satisfied.
- [ ] Dotfiles are restored and clean.
- [ ] Shell and terminal environment work correctly.
- [ ] Desktop tooling works correctly.
- [ ] Neovim-AIDE works correctly.
- [ ] ChatGPT and Codex are available and authenticated.
- [ ] Required secrets are restored securely.
- [ ] `./scripts/validate-system.sh` passes.

The machine is now ready for development.

The machine is replaceable.

The environment is reproducible.
