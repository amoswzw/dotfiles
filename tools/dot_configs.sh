# Mapping of <repo path>|<home path>.
# Trailing slash on both sides means "directory" — handled with rsync.
# No trailing slash means "single file" — handled with cp.
# Indexed array (works on macOS system bash 3.2).
mapping=(
  # Shell
  "aliases|$HOME/.aliases"
  "functions|$HOME/.functions"
  "zshrc|$HOME/.zshrc"
  "zprofile|$HOME/.zprofile"
  "zshenv|$HOME/.zshenv"

  # NOTE: gitconfig is intentionally NOT in this mapping.
  # It is a template seeded by bootstrap.sh on first install only,
  # so subsequent `make backup` never captures your personal identity
  # back into the repo, and `make install` never clobbers your local
  # git identity.

  # Terminal multiplexer
  "tmux.conf|$HOME/.tmux.conf"

  # Editors (whole nvim config tree — Lua-based)
  "nvim/|$HOME/.config/nvim/"

  # Terminals
  "alacritty/|$HOME/.config/alacritty/"

  # Network
  "clash/start_clash.sh|$HOME/.config/clash/start_clash.sh"

  # Window manager / hotkeys / status bar (directories)
  "yabai/|$HOME/.config/yabai/"
  "skhd/|$HOME/.config/skhd/"
  "sketchybar/|$HOME/.config/sketchybar/"
)
