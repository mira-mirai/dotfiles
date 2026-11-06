# New machine setup

`setup.sh` handles everything in the home folder. This list covers the rest: system
settings that need `sudo` and steps done once per machine.

## Every machine

1. Clone the repo into the usual place and run setup:
   ```bash
   git clone https://github.com/mira-mirai/dotfiles.git ~/Documents/github/mira-mirai/dotfiles
   cd ~/Documents/github/mira-mirai/dotfiles && ./setup.sh
   ```
   Use https on a machine without a GitHub key. Existing dotfiles are renamed to `.bak`;
   check them for anything worth keeping.
2. Open a new shell (or log out and back in over SSH) to load everything.
3. Optional, machine-specific files that are not in the repo:
   - `~/.gitconfig.local`: a different git email, e.g. on a work machine
     ```ini
     [user]
     	email = you@work.example
     ```
   - `~/.path.local`: extra PATH entries, e.g. `path_add /opt/some-tool/bin`
4. Optional, to push from this machine: make its own SSH key (don't copy another
   machine's private key), add the public key to GitHub, then switch the repo to SSH.
   ```bash
   ssh-keygen -t ed25519
   cat ~/.ssh/id_ed25519.pub     # paste into GitHub → Settings → SSH keys
   git remote set-url origin git@github.com:mira-mirai/dotfiles.git
   ```

## macOS

- `setup.sh` imports the Gruvbox Dark Terminal profile and makes it the default.
  Windows that were already open keep their old look until closed.
- `setup.sh` turns off Terminal's per-tab history. After closing the tabs that were open
  before setup, the old history folder can go: `command rm -r ~/.bash_sessions`
- Optional: longer sudo password timeout (default is 5 minutes), see below.

## Linux servers (Ubuntu / Debian)

1. Install the basics first:
   ```bash
   sudo apt install git vim
   ```
2. Set the hostname, so the prompt shows the right name:
   ```bash
   sudo hostnamectl set-hostname NEWNAME
   sudoedit /etc/hosts     # change the 127.0.1.1 line to: 127.0.1.1  NEWNAME
   ```
   If `/etc/cloud/cloud.cfg` exists, stop cloud-init from resetting it at reboot:
   ```bash
   echo 'preserve_hostname: true' | sudo tee /etc/cloud/cloud.cfg.d/99-keep-hostname.cfg
   ```
3. Make vim the system default editor (used by `visudo`, `sudo crontab -e`, etc.).
   `sudo` ignores your own `EDITOR`. Pick `vim.basic`:
   ```bash
   sudo update-alternatives --config editor
   ```
4. Optional: longer sudo password timeout (Ubuntu's default is 15 minutes), see below.

## Longer sudo timeout (macOS and Linux)

```bash
sudo visudo -f /etc/sudoers.d/timeout
```
Add `Defaults timestamp_timeout=60` (minutes) and save. Always use `visudo`: it checks the
syntax, and a broken sudoers file locks you out of `sudo`. The file name must not contain
a dot, or sudo skips it.
