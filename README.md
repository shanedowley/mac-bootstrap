# mac-bootstrap

A reproducible macOS development environment.

This repository documents and automates the process of rebuilding a Mac from a clean installation to a fully configured development workstation.

The goal is not to clone an old machine.

The goal is to rebuild a clean, understandable and maintainable environment from version-controlled sources.

## Start Here

To rebuild a Mac, begin with:

`docs/NEW_MAC_SETUP.md`

That guide provides the end-to-end bootstrap sequence and links to the detailed runbooks.

## Philosophy

Treat a Mac as infrastructure, not as a handcrafted machine.

Configuration should live in Git.

Software installation should be reproducible.

Projects should be cloned.

Secrets should be restored securely.

The machine itself should be disposable.

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
├── docs/
│   ├── NEW_MAC_SETUP.md
│   ├── POST_INSTALL_CHECKLIST.md
│   ├── SSH_SETUP.md
│   ├── GITHUB_SETUP.md
│   ├── DOTFILES.md
│   └── TROUBLESHOOTING.md
└── scripts/
```

Automation will be introduced incrementally under `scripts/`.

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

## Bootstrap Model

The bootstrap process follows a simple sequence:

1. Prepare macOS.
2. Install Xcode Command Line Tools.
3. Establish SSH identity.
4. Establish GitHub access.
5. Clone `mac-bootstrap`.
6. Restore software using Homebrew and the Brewfile.
7. Restore version-controlled configuration.
8. Restore development projects and Neovim-AIDE.
9. Restore and authenticate AI development tools.
10. Validate the completed environment.

Detailed instructions are maintained in `docs/NEW_MAC_SETUP.md` and the associated runbooks.

## Future Automation

The documented process will gradually be automated.

Planned automation includes:

- Homebrew installation
- Brewfile restoration
- dotfiles restoration
- project cloning
- system validation
- one-command orchestration

Automation should remain understandable, independently testable and free from hidden side effects.

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

1. Complete macOS setup.
2. Establish the minimum prerequisites required to access GitHub.
3. Clone this repository.
4. Follow the documented bootstrap process.
5. Restore credentials securely.
6. Validate the environment.
7. Resume development.

The machine becomes replaceable.

The development environment remains reproducible.
