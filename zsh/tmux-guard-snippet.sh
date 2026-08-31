# >>> dotfiles: tmux-guarded fastfetch >>>
# Show a colorful system-info banner on new terminals, but skip it inside tmux —
# the dashboard launcher (~/.local/bin/dashboard) controls exactly which pane
# shows fastfetch, so an unconditional call here would duplicate it in every pane.
if [ -z "$TMUX" ]; then
  fastfetch
fi
# <<< dotfiles: tmux-guarded fastfetch <<<

# Starship prompt
eval "$(starship init zsh)"
