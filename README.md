# macOS dotfiles

## One-click install

On a fresh macOS machine:

```bash
git clone <your-fork-of-this-repo> ~/.dotfiles
cd ~/.dotfiles
make bootstrap
```

`make bootstrap` runs [`bootstrap.sh`](./bootstrap.sh) and takes care of the
whole setup, idempotently:

1. Install **Xcode Command Line Tools**
2. Install **Homebrew**
3. `brew bundle` against [`Brewfile`](./Brewfile) — every formula and cask
4. Install **fzf** shell integration
5. Clone **tmux plugin manager** (tpm) into `~/.tmux/plugins/tpm`
6. Apply dotfiles from this repo to `$HOME` (see mapping below)
7. `chsh` default shell to the brew-installed `zsh`
8. Headlessly sync **Neovim plugins** via `lazy.nvim`

`zinit` (zsh plugin manager) auto-installs the first time `zshrc` is sourced,
so nothing to do for that. After the bootstrap finishes:

- Open a new shell.
- Inside `tmux`, press `prefix + I` once to install tmux plugins.

## Optional bundles

Some package groups are kept out of the main `Brewfile` because they're not
part of the everyday environment. Install on demand:

```bash
brew bundle --file=Brewfile.k8s        # kubectl, helm, k9s, argocd, skaffold, lima, podman, ...
brew bundle --file=Brewfile.pentest    # nmap, sqlmap, hashcat, subfinder, amass, hydra, ...
```

- [`Brewfile.k8s`](./Brewfile.k8s) — Kubernetes / container ecosystem.
- [`Brewfile.pentest`](./Brewfile.pentest) — security / pentest / CTF.

## Daily commands

```bash
make backup    # Capture current $HOME config + Brewfile back into this repo
make install   # Re-apply this repo's dotfiles to $HOME
make help      # Show all targets
```

`make backup` regenerates `Brewfile` via `brew bundle dump` and rsyncs every
config listed in [`tools/dot_configs.sh`](./tools/dot_configs.sh) from `$HOME`
back into the repo. Add new configs there as a `repo_path|home_path` entry —
trailing slash on both sides means "directory" (rsynced with `--delete`),
no slash means a single file.

## What's tracked

| Repo path                     | Home path                          |
| ----------------------------- | ---------------------------------- |
| `aliases`                     | `~/.aliases`                       |
| `functions`                   | `~/.functions`                     |
| `zshrc`                       | `~/.zshrc`                         |
| `zprofile`                    | `~/.zprofile`                      |
| `zshenv`                      | `~/.zshenv`                        |
| `gitconfig`                   | `~/.gitconfig`                     |
| `tmux.conf`                   | `~/.tmux.conf`                     |
| `nvim/`                       | `~/.config/nvim/`                  |
| `alacritty/`                  | `~/.config/alacritty/`             |
| `clash/start_clash.sh`        | `~/.config/clash/start_clash.sh`   |
| `yabai/`                      | `~/.config/yabai/`                 |
| `skhd/`                       | `~/.config/skhd/`                  |
| `sketchybar/`                 | `~/.config/sketchybar/`            |

## Key bindings

| Short key | Description |
| --- | ----------- |
| `dev` | Open a new tmux session; auto-restores last dev when re-run |
| `Ctrl-w \|` or `Ctrl-w —` | Split tmux window |
| `Ctrl-w` + `h/j/k/l` | Resize tmux pane |
| `Ctrl-w` + `<` or `>` | Switch tmux window |
| `Esc` then `v` then `h/j/k/l` then `y` | Copy in tmux |
| `Ctrl` + `h/j/k/l` | Navigate panes in tmux/vim |
| `tr` | NERDTree in vim |
| `tb` | Tagbar in vim |
| `gd` | Go to definition in vim |
| `Ctrl-p` | File search in vim |
| `Cmd-[` / `Cmd-]` | Buffer switch in vim |
| `Cmd-/` | Toggle comment in vim |
