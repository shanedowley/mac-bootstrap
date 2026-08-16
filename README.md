# mac-bootstrap

A reproducible macOS development environment.

This repository documents and automates the process of rebuilding a Mac from a clean installation to a fully configured development workstation.

The goal is not to clone an old machine.

The goal is to rebuild a clean, understandable and maintainable environment from version-controlled sources.

## Start Here

To rebuild a Mac, begin with:

`docs/NEW_MAC_SETUP.md`

That guide provides the end-to-end bootstrap sequence and links to the detailed runbooks.

Once the minimum prerequisites and GitHub access are established, the automated portion of the rebuild is driven by:

```bash
./bootstrap.sh
```

Use dry-run mode first when you want to inspect the intended actions without making changes:

```bash
./bootstrap.sh --dry-run
```

## Philosophy

Treat a Mac as infrastructure, not as a handcrafted machine.

Configuration should live in Git.

Software installation should be reproducible.

Projects should be cloned.

Secrets should be restored securely.

The machine itself should be disposable.

Automation should remain understandable, independently testable and free from hidden side effects.

See `WORKING_AGREEMENT.md` for the engineering principles used to develop this repository.

## Recovery Model

The development environment is reconstructed from five independent sources:

```text
GitHub dotfiles repository
        +
Homebrew Brewfile
        +
GitHub project repositories
        +
Secure credential backups
        +
Personal data backups
        =
Reconstructed development environment
```

Each source has a single responsibility.

| Source                   | Responsibility                                |
| ------------------------ | --------------------------------------------- |
| Dotfiles                 | Shell, Git, editor and user configuration     |
| Brewfile                 | Applications, command-line tools and packages |
| Git repositories         | Source code and projects                      |
| Secure credential backup | SSH keys, API keys and other secrets          |
| Personal backups         | Documents, media and personal files           |

## Repository Layout

```text
mac-bootstrap/
├── README.md
├── WORKING_AGREEMENT.md
├── Brewfile
├── bootstrap.sh
├── docs/
│   ├── NEW_MAC_SETUP.md
│   ├── POST_INSTALL_CHECKLIST.md
│   ├── SSH_SETUP.md
│   ├── GITHUB_SETUP.md
│   ├── DOTFILES.md
│   └── TROUBLESHOOTING.md
└── scripts/
    ├── install-homebrew.sh
    ├── restore-brewfile.sh
    ├── restore-dotfiles.sh
    ├── clone-projects.sh
    └── validate-system.sh
```

The scripts remain independently executable so that each stage can be understood, tested and diagnosed separately.

`bootstrap.sh` provides the orchestration layer over those individual stages.

## Current Environment

Hardware:

- Apple Silicon Mac

Operating system:

- macOS

Development tooling includes:

- Homebrew
- Git
- Zsh
- Ghostty
- tmux
- Neovim
- Neovim-AIDE

Configuration uses:

- a bare Git dotfiles repository at `~/.dotfiles`
- the home directory as its working tree

Neovim-AIDE is restored to:

```text
~/Projects/neovim-codex
```

with the Neovim runtime path linked as:

```text
~/.config/nvim -> ~/Projects/neovim-codex
```

## Bootstrap Model

The complete bootstrap process deliberately has a small manual boundary.

Before the repository can automate the machine, the Mac must have enough tooling and authentication configured to obtain it.

The end-to-end sequence is:

1. Complete macOS setup.
2. Install the Xcode Command Line Tools.
3. Establish SSH identity.
4. Establish GitHub access.
5. Clone `mac-bootstrap`.
6. Optionally inspect the automated stages with `./bootstrap.sh --dry-run`.
7. Run `./bootstrap.sh`.
8. Complete any remaining interactive authentication and secret restoration.
9. Perform any required first-launch checks.
10. Confirm the completed environment using the post-install checklist.

The orchestrator runs five automated stages in order:

1. Install or verify Homebrew.
2. Restore or verify Brewfile dependencies.
3. Restore and verify the bare Git dotfiles repository.
4. Restore Neovim-AIDE and its Neovim runtime link.
5. Validate the resulting system.

The bootstrap stops on failure rather than silently continuing with an incomplete environment.

Detailed instructions are maintained in `docs/NEW_MAC_SETUP.md` and the associated runbooks.

## Manual and Interactive Steps

Some responsibilities deliberately remain outside unattended automation.

These include:

- initial macOS Setup Assistant,
- macOS updates and FileVault verification,
- Xcode Command Line Tools installation where required,
- creation and registration of machine-specific SSH credentials,
- interactive authentication for services such as ChatGPT and Codex,
- restoration of secrets from their secure source,
- application permissions or other macOS prompts,
- and first-launch verification where an application requires it.

Secrets are never stored in this repository.

## Validation

The final automated stage runs:

```bash
./scripts/validate-system.sh
```

It verifies the machine state that `mac-bootstrap` can determine safely and non-destructively, including:

- macOS and Apple Silicon,
- Homebrew,
- Brewfile dependencies,
- the dotfiles repository,
- the Neovim-AIDE repository,
- the Neovim runtime symlink,
- and required command-line tools.

Validation reports individual `PASS` or `FAIL` results and exits unsuccessfully if any required check fails.

The post-install checklist remains the final human verification of items that cannot or should not be inferred automatically.

## Related Repositories

| Repository    | Purpose                        |
| ------------- | ------------------------------ |
| dotfiles      | Personal configuration         |
| neovim-aide   | Neovim development environment |
| mac-bootstrap | Machine provisioning           |

Each repository has a single responsibility.

## Long-Term Vision

Provisioning a new Mac should become routine.

The intended workflow is:

1. Complete the small manual bootstrap boundary.
2. Clone this repository.
3. Run the bootstrap orchestrator.
4. Restore credentials and complete interactive setup securely.
5. Validate the environment.
6. Resume development.

The machine becomes replaceable.

The development environment remains reproducible.
