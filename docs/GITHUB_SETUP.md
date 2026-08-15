# GitHub Setup

This runbook connects a new Mac to GitHub using the SSH identity created in `SSH_SETUP.md`.

## 1. Confirm the SSH Public Key

Verify that the public key exists:

```bash
cat ~/.ssh/id_ed25519.pub
```

Copy it to the clipboard:

```bash
pbcopy < ~/.ssh/id_ed25519.pub
```

Never copy or upload the private key:

```text
~/.ssh/id_ed25519
```

## 2. Register the Key with GitHub

In GitHub:

1. Open **Settings**.
2. Open **SSH and GPG keys**.
3. Choose **New SSH key**.
4. Give the key a name that identifies this Mac.
5. Paste the contents of `~/.ssh/id_ed25519.pub`.
6. Save the key.

Only the public key should be registered with GitHub.

## 3. Verify GitHub SSH Authentication

Test the connection:

```bash
ssh -T git@github.com
```

On the first connection, SSH may ask you to confirm GitHub's host key.

Verify the fingerprint before accepting it.

A successful connection should confirm that GitHub authentication succeeded.

## 4. Configure Git Identity

Check the current Git configuration:

```bash
git config --global --list
```

If required, configure your identity:

```bash
git config --global user.name "Your Name"
git config --global user.email "your-email@example.com"
```

Verify:

```bash
git config --global user.name
git config --global user.email
```

If Git configuration is restored through dotfiles, avoid duplicating configuration unnecessarily.

## 5. Verify Repository Access

Create the development directory if required:

```bash
mkdir -p ~/Projects
cd ~/Projects
```

Clone the `mac-bootstrap` repository:

```bash
git clone git@github.com:shanedowley/mac-bootstrap.git
```

Then verify:

```bash
cd mac-bootstrap
git remote -v
git status
```

The `origin` remote should use SSH.

## 6. Validation

Confirm:

- [ ] The Mac's SSH public key is registered with GitHub.
- [ ] `ssh -T git@github.com` authenticates successfully.
- [ ] Git user name is correct.
- [ ] Git email address is correct.
- [ ] `mac-bootstrap` can be cloned over SSH.
- [ ] The repository remote uses `git@github.com:...`.

GitHub access is now ready for the remaining bootstrap process.

## Next Step

GitHub access is now established.

Return to `NEW_MAC_SETUP.md` and continue the bootstrap sequence.
