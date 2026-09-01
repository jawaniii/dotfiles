#!/usr/bin/env bash
# Bootstrap this dotfiles repo onto a new Mac.
# Safe to re-run: existing real files get backed up (never silently overwritten),
# already-correct symlinks are left alone, and the zshrc snippet is only appended once.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Installing packages via Homebrew (skips anything already installed)"
brew list --cask ghostty &>/dev/null || brew install --cask ghostty
brew list tmux &>/dev/null || brew install tmux
brew list btop &>/dev/null || brew install btop
brew list fastfetch &>/dev/null || brew install fastfetch
brew list starship &>/dev/null || brew install starship

link() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ]; then
    ln -sfn "$src" "$dst"
    return
  fi
  if [ -e "$dst" ]; then
    mv "$dst" "$dst.bak.$(date +%s)"
    echo "    backed up existing $dst"
  fi
  ln -sfn "$src" "$dst"
  echo "    linked $dst -> $src"
}

echo "==> Symlinking configs"
link "$DOTFILES/ghostty/config"                       "$HOME/.config/ghostty/config"
link "$DOTFILES/tmux/tmux.conf"                        "$HOME/.tmux.conf"
link "$DOTFILES/starship/starship.toml"                "$HOME/.config/starship.toml"
link "$DOTFILES/fastfetch/config.jsonc"                "$HOME/.config/fastfetch/config.jsonc"
link "$DOTFILES/fastfetch/hero-video.jsonc"            "$HOME/.config/fastfetch/hero-video.jsonc"
link "$DOTFILES/fastfetch/umersprofile-simple.jsonc"   "$HOME/.config/fastfetch/umersprofile-simple.jsonc"
link "$DOTFILES/fastfetch/whale-3d-logo.ansi"          "$HOME/.config/fastfetch/whale-3d-logo.ansi"
link "$DOTFILES/fastfetch/spin-frames"                 "$HOME/.config/fastfetch/spin-frames"
link "$DOTFILES/btop/btop.conf"                        "$HOME/.config/btop/btop.conf"
link "$DOTFILES/btop/themes/catppuccin_mocha.theme"    "$HOME/.config/btop/themes/catppuccin_mocha.theme"
link "$DOTFILES/bin/dashboard"                         "$HOME/.local/bin/dashboard"
link "$DOTFILES/bin/tmux-toggle-btop"                  "$HOME/.local/bin/tmux-toggle-btop"
link "$DOTFILES/bin/whale-spin-intro"                  "$HOME/.local/bin/whale-spin-intro"
chmod +x "$HOME/.local/bin/dashboard" "$HOME/.local/bin/tmux-toggle-btop" "$HOME/.local/bin/whale-spin-intro"

echo "==> Wiring ~/.zshrc"
MARKER=">>> dotfiles: tmux-guarded fastfetch >>>"
if [ -f "$HOME/.zshrc" ] && grep -qF "$MARKER" "$HOME/.zshrc"; then
  echo "    already present, skipping"
else
  [ -f "$HOME/.zshrc" ] && cp "$HOME/.zshrc" "$HOME/.zshrc.bak.$(date +%s)" && echo "    backed up existing ~/.zshrc"
  cat "$DOTFILES/zsh/tmux-guard-snippet.sh" >> "$HOME/.zshrc"
  echo "    appended tmux-guard + starship-init snippet to ~/.zshrc"
fi

echo ""
echo "Done. Make sure \$HOME/.local/bin is on your PATH, then open Ghostty and run: dashboard"
