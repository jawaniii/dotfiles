# >>> dotfiles: tmux-guarded fastfetch >>>
# Show a colorful system-info banner on new terminals, but skip it inside tmux —
# the dashboard launcher (~/.local/bin/dashboard) controls exactly which pane
# shows fastfetch, so an unconditional call here would duplicate it in every pane.
# Deliberately plain fastfetch, NOT whale-spin-intro: the animated intro has proven
# too fragile to run unconditionally on every single terminal open (a real bug in
# its padding math once made every new window hang) — it's reserved for the
# deliberate `dashboard` command, where you're expecting to wait for it.
if [ -z "$TMUX" ]; then
  fastfetch --config "$HOME/.config/fastfetch/config.jsonc"
fi
# <<< dotfiles: tmux-guarded fastfetch <<<

# Starship prompt
eval "$(starship init zsh)"
