# Dotfiles Setup

This runbook restores the version-controlled user configuration on a new Mac.

The dotfiles repository uses a bare Git repository with the home directory as its working tree.

```text
Git directory: ~/.dotfiles
Working tree:  ~
Remote:        git@github.com:shanedowley/dotfiles.git
Branch:        main
```

This allows configuration files to remain in their normal locations without maintaining a separate dotfiles working directory.

## 1. Prerequisites

Before restoring the dotfiles:

- [ ] Git is installed.
- [ ] SSH is configured.
- [ ] GitHub authentication works.
- [ ] The home directory does not contain configuration files that would be unintentionally overwritten.

See:

- `SSH_SETUP.md`
- `GITHUB_SETUP.md`

## 2. Clone the Bare Repository

Clone the repository without creating a working directory:

```bash
git clone --bare git@github.com:shanedowley/dotfiles.git ~/.dotfiles
```

Verify that the repository is bare:

```bash
git --git-dir="$HOME/.dotfiles" config --get core.bare
```

Expected:

```text
true
```

Verify the remote:

```bash
git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" remote -v
```

Expected remote:

```text
git@github.com:shanedowley/dotfiles.git
```

## 3. Configure the Bare Repository

Before inspecting or checking out the home-directory working tree, configure the repository-local Git settings required by this dotfiles setup.

Disable filesystem monitoring for the bare repository:

```bash
git --git-dir="$HOME/.dotfiles" config core.fsmonitor false
```

A global Git configuration may enable filesystem monitoring. For this bare-repository and external-working-tree configuration, it must be disabled locally before checkout.

The home directory also contains many files that do not belong in the dotfiles repository.

Configure Git not to display those untracked files:

```bash
git --git-dir="$HOME/.dotfiles" \
  --work-tree="$HOME" \
  config status.showUntrackedFiles no
```

Verify both repository-local settings:

```bash
git --git-dir="$HOME/.dotfiles" config --get core.fsmonitor

git --git-dir="$HOME/.dotfiles" \
  --work-tree="$HOME" \
  config --get status.showUntrackedFiles
```

Expected:

```text
false
no
```

## 4. Check Out the Configuration

Before checkout, inspect the current state:

```bash
git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" status
```

Then restore the tracked files:

```bash
git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" checkout
```

If checkout reports that existing files would be overwritten, stop.

Do not delete or overwrite those files blindly. Inspect them and decide whether they should be backed up, removed or retained before retrying the checkout.

## 5. Verify the Repository

Check repository status:

```bash
git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" status
```

Expected result:

```text
On branch main
Your branch is up to date with 'origin/main'.

nothing to commit
```

Verify that the repository remains configured as bare:

```bash
git --git-dir="$HOME/.dotfiles" config --get core.bare
```

Expected:

```text
true
```

Verify that filesystem monitoring is disabled locally:

```bash
git --git-dir="$HOME/.dotfiles" config --get core.fsmonitor
```

Expected:

```text
false
```

Verify that untracked home files are hidden:

```bash
git --git-dir="$HOME/.dotfiles" \
  --work-tree="$HOME" \
  config --get status.showUntrackedFiles
```

Expected:

```text
no
```

Verify the remote:

```bash
git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" remote -v
```

Expected remote:

```text
git@github.com:shanedowley/dotfiles.git
```

Verify the current branch:

```bash
git --git-dir="$HOME/.dotfiles" \
  --work-tree="$HOME" \
  branch --show-current
```

Expected:

```text
main
```

## 6. Verify Restored Configuration

Confirm that the expected configuration has been restored.

Examples include:

```text
~/.zshrc
~/.gitconfig
~/.config/
~/bin/
```

Start a new shell and verify that the environment loads correctly.

Do not restore secrets from the dotfiles repository.

Files containing credentials, tokens, private keys or other secrets must be restored separately through an appropriate secure mechanism.

## 7. Validation

Confirm:

- [ ] `~/.dotfiles` exists.
- [ ] The repository is bare.
- [ ] `core.fsmonitor` is `false`.
- [ ] `status.showUntrackedFiles` is `no`.
- [ ] The repository uses `main`.
- [ ] `origin` points to the expected GitHub repository.
- [ ] The home directory is used as the working tree.
- [ ] Tracked configuration files are restored.
- [ ] Untracked home files are hidden from repository status.
- [ ] `git status` is clean.
- [ ] A new shell starts correctly.
- [ ] No secrets have been restored from Git.

The version-controlled user configuration is now restored.
