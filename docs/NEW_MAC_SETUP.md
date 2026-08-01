# mac-bootstrap

A reproducible macOS development environment.

This repository documents and automates the process of provisioning a new Mac from a clean installation to a fully configured development workstation.

The goal is not to clone an old machine.

The goal is to rebuild a clean, understandable and maintainable environment from version-controlled sources.

---

## Philosophy

Treat a Mac as infrastructure, not as a handcrafted machine.

Configuration should live in Git.

Software installation should be reproducible.

Projects should be cloned.

Secrets should be restored securely.

The machine itself should be disposable.

---

## Recovery Model

The complete development environment is reconstructed from five independent sources:

```
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

| Source | Responsibility |
|---------|----------------|
| Dotfiles | Shell, Git, editor and user configuration |
| Brewfile | Applications, command-line tools and packages |
| Git repositories | Source code and projects |
| Secure credential backup | SSH keys, GPG keys, API keys and secrets |
| Personal backups | Documents, media and personal files |

---

## Repository Layout

```
mac-bootstrap/
├── README.md
├── docs/
│   ├── NEW_MAC_SETUP.md
│   ├── POST_INSTALL_CHECKLIST.md
│   └── TROUBLESHOOTING.md
├── Brewfile
├── install.sh
└── bootstrap.sh
```

Initially only the README is required.

Automation can be added incrementally.

---

## Current Environment

Hardware

- Apple Silicon Mac

Operating System

- macOS

Development

- Homebrew
- Git
- Zsh
- Neovim
- Neovim-AIDE

Configuration

- Bare Git repository (`dotfiles`)
- Home directory used as working tree

---

## Bootstrap Process

The bootstrap process consists of five stages.

### Stage 1

Prepare macOS.

- Install Xcode Command Line Tools
- Configure GitHub SSH access

### Stage 2

Restore configuration.

- Clone dotfiles
- Checkout home directory
- Restore shell configuration

### Stage 3

Restore software.

- Install Homebrew
- Restore Brewfile
- Verify installed packages

### Stage 4

Restore development projects.

- Clone repositories
- Restore Neovim-AIDE
- Install editor plugins

### Stage 5

Restore credentials and validate.

- Restore secrets
- Verify tooling
- Run health checks

---

## Design Principles

- Infrastructure as code where practical.
- Everything reproducible.
- Everything documented.
- Keep manual steps to a minimum.
- Never store secrets in Git.
- Prefer rebuilding over copying.

---

## Future Automation

This repository will gradually automate more of the bootstrap process.

Potential additions include:

- automated Homebrew installation
- automated dotfiles installation
- GitHub SSH setup validation
- repository cloning
- Neovim-AIDE installation
- post-install validation
- machine health checks

The objective is to reduce the provisioning of a new Mac to a small number of predictable, repeatable commands.

---

## Related Repositories

| Repository | Purpose |
|------------|---------|
| dotfiles | Personal configuration |
| neovim-aide | Neovim development environment |
| mac-bootstrap | Machine provisioning |

Each repository has a single responsibility.

---

## Long-Term Vision

Provisioning a new Mac should become routine.

The ideal workflow is:

1. Purchase a new Mac.
2. Complete macOS setup.
3. Clone this repository.
4. Run the bootstrap process.
5. Restore credentials.
6. Resume development.

The machine becomes replaceable.

The development environment remains permanent.