# dotfiles

My personal terminal setup — Ghostty, tmux, Starship, fastfetch, btop — captured so it can be
rebuilt on a new machine in one command instead of redoing everything by hand.

## What's in here

| Path | Installs to | What it is |
|---|---|---|
| `ghostty/config` | `~/.config/ghostty/config` | Catppuccin Mocha theme, transparency, font |
| `tmux/tmux.conf` | `~/.tmux.conf` | Catppuccin Mocha status bar, `prefix+b` toggles the btop pane |
| `starship/starship.toml` | `~/.config/starship.toml` | catppuccin-powerline prompt preset |
| `fastfetch/config.jsonc` | `~/.config/fastfetch/config.jsonc` | daily-driver system-info banner |
| `fastfetch/umersprofile-simple.jsonc` | `~/.config/fastfetch/umersprofile-simple.jsonc` | curated banner for the tmux dashboard / recordings |
| `fastfetch/hero-video.jsonc` | `~/.config/fastfetch/hero-video.jsonc` | curated banner for the docker-factory hero-video recording |
| `btop/btop.conf` + `btop/themes/catppuccin_mocha.theme` | `~/.config/btop/` | Catppuccin Mocha theme ([catppuccin/btop](https://github.com/catppuccin/btop)) |
| `bin/dashboard` | `~/.local/bin/dashboard` | launches the 2-pane tmux dashboard (fastfetch left, btop right) |
| `bin/tmux-toggle-btop` | `~/.local/bin/tmux-toggle-btop` | bound to `prefix+b`, hides/shows the btop pane |
| `zsh/tmux-guard-snippet.sh` | appended to `~/.zshrc` | runs fastfetch on shell start, but skips it inside tmux (avoids duplicating the banner in every pane) |

## Setup on a new machine

```
git clone https://github.com/jawaniii/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

The script installs the required tools via Homebrew (`ghostty`, `tmux`, `btop`, `fastfetch`,
`starship`), then symlinks each config file above into place. Safe to re-run — anything
already in place gets backed up (`<file>.bak.<timestamp>`) before being replaced, never
silently overwritten. It does not blindly overwrite your whole `~/.zshrc`: it only appends
the fastfetch/starship snippet, and only if it isn't already there.

Once installed, open Ghostty and run `dashboard`.

## Editing

These files are the source of truth — the real config paths (`~/.tmux.conf`, etc.) are
symlinks back into this repo. Edit here, commit, and every machine that's run `install.sh`
picks it up on next `git pull`.
