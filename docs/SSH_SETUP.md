# SSH Setup

This runbook establishes SSH identity on a new Mac.

Use a separate SSH key for each machine. This allows access for an individual Mac to be revoked without affecting other machines.

Private SSH keys must never be stored in this repository.

## 1. Check Existing SSH Configuration

Before creating anything:

```bash
ls -la ~/.ssh
```

If `~/.ssh` does not exist, that is expected on a new Mac.

Do not overwrite an existing key without understanding what it is used for.

## 2. Generate an SSH Key

Generate a new Ed25519 key:

```bash
ssh-keygen -t ed25519 -C "your-email@example.com"
```

Accept the default location:

```text
~/.ssh/id_ed25519
```

Use a passphrase unless there is a specific reason not to.

The command creates:

```text
~/.ssh/id_ed25519
~/.ssh/id_ed25519.pub
```

The first file is the private key.

The `.pub` file is the public key and may be registered with services such as GitHub.

## 3. Start the SSH Agent

Start the agent:

```bash
eval "$(ssh-agent -s)"
```

## 4. Configure SSH for macOS

Create or edit:

```text
~/.ssh/config
```

Add:

```text
Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
```

Protect the configuration:

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/config
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub
```

## 5. Add the Key to the Apple Keychain

Add the private key to the SSH agent and store its passphrase in the Apple Keychain:

```bash
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
```

Verify:

```bash
ssh-add -l
```

The new Ed25519 key should be listed.

## 6. Inspect the Public Key

Display the public key:

```bash
cat ~/.ssh/id_ed25519.pub
```

Or copy it to the macOS clipboard:

```bash
pbcopy < ~/.ssh/id_ed25519.pub
```

Only the public key should be copied to external services.

Never copy or expose:

```text
~/.ssh/id_ed25519
```

## 7. Verify Local SSH Setup

Check the files:

```bash
ls -la ~/.ssh
```

Check the loaded identities:

```bash
ssh-add -l
```

Confirm:

- [ ] A new Ed25519 key exists.
- [ ] The private key is protected.
- [ ] The public key is available.
- [ ] SSH configuration exists.
- [ ] The key is loaded by the SSH agent.
- [ ] The passphrase is stored securely in the Apple Keychain.

## Next Step

SSH identity is now established on the Mac.

Register the public key with GitHub and verify authentication using `GITHUB_SETUP.md`.
