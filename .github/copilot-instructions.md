# Copilot Instructions

## What this repo is

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/). chezmoi is a dotfile manager that copies files from a source directory (`home/`, set by [`.chezmoiroot`](https://www.chezmoi.io/reference/special-files/chezmoiroot/)) into `$HOME`, with support for:

- **[Templates](https://www.chezmoi.io/user-guide/templating/)** (`.tmpl` suffix) — Go text/template files rendered at apply time using per-machine variables stored in `~/.config/chezmoi/chezmoi.toml`
- **[Scripts](https://www.chezmoi.io/user-guide/use-scripts-to-perform-actions/)** (`run_onchange_` prefix) — Shell scripts chezmoi runs automatically; re-executed only when their file content changes (chezmoi tracks a hash)
- **[Externals](https://www.chezmoi.io/reference/special-files/chezmoiexternal-format/)** (`.chezmoiexternal.toml`) — Remote archives/files fetched and unpacked at apply time, not committed to the repo
- **[Ignore rules](https://www.chezmoi.io/reference/special-files/chezmoiignore/)** (`.chezmoiignore.tmpl`) — Template-rendered gitignore-style file that controls which source files are applied per OS/profile

The source root maps directly to `$HOME`: `home/dot_zshrc` becomes `~/.zshrc`, `home/dot_config/nvim/` becomes `~/.config/nvim/`, etc.

## Applying dotfiles

```sh
chezmoi apply          # apply changes to $HOME
chezmoi diff           # preview what would change
chezmoi edit <file>    # edit a managed file and apply in one step
```

See the reference docs for [`chezmoi apply`](https://www.chezmoi.io/reference/commands/apply/), [`chezmoi diff`](https://www.chezmoi.io/reference/commands/diff/), and [`chezmoi edit`](https://www.chezmoi.io/reference/commands/edit/).

To re-run a `run_onchange_*` script manually, change its content (e.g. add a comment) so chezmoi detects it as changed, then run `chezmoi apply`.

## chezmoi file naming conventions

chezmoi encodes metadata in filenames (see [source state attributes](https://www.chezmoi.io/reference/source-state-attributes/) for the full reference):

| Prefix/Suffix | Meaning |
|---|---|
| `dot_` | Becomes `.` in `$HOME` (e.g. `dot_zshrc` → `~/.zshrc`) |
| `.tmpl` | Go template — rendered before writing |
| `run_onchange_` | Script re-run only when its content changes |
| `run_onchange_after_` | Same, but runs after all files are applied |
| `private_` | Written with mode 0600 |

## Template variables

Defined in `home/.chezmoi.toml.tmpl`, available in all `.tmpl` files (see [templating guide](https://www.chezmoi.io/user-guide/templating/)):

| Variable | Values / Notes |
|---|---|
| `.profile` | `"personal"` or `"work"` — controls Brewfile sections and zprofile extras |
| `.email` | Used in `dot_gitconfig.tmpl` |
| `.gpg_signingkey` | GPG/SSH key ID; commit signing is skipped when empty |
| `.additional_path_entries` | List of extra `$PATH` entries added in `dot_zprofile.tmpl` |
| `.chezmoi.os` | `"darwin"`, `"linux"`, etc. — used in `.chezmoiignore.tmpl` |

Use `{{ .profile }}`, `{{ .email }}`, etc. in any `.tmpl` file.

## OS-specific files

- Scripts under `home/.chezmoiscripts/darwin/` run on macOS only.
- `home/.chezmoiignore.tmpl` excludes the `darwin/` scripts and `dot_Brewfile.tmpl` on non-macOS systems.
- There are no Linux- or Windows-specific files currently; add them under a matching `home/.chezmoiscripts/<os>/` directory and guard with `{{ if ne .chezmoi.os "darwin" }}` blocks in `.chezmoiignore.tmpl`.

## Key files and their roles

- [`home/.chezmoi.toml.tmpl`](https://www.chezmoi.io/reference/special-files/chezmoi-format-tmpl/) — chezmoi config template; prompts for variables on first `chezmoi init`
- [`home/.chezmoiexternal.toml`](https://www.chezmoi.io/reference/special-files/chezmoiexternal-format/) — declares oh-my-zsh as an external archive (downloaded, not committed)
- `home/dot_Brewfile.tmpl` — Homebrew bundle; split by `.profile` for personal vs. work packages
- `home/.chezmoiscripts/darwin/run_onchange_install_packages.sh.tmpl` — installs Homebrew and runs `brew bundle --global`; re-triggered whenever `dot_Brewfile.tmpl` changes (its SHA256 is embedded in a comment)
- `home/.chezmoiscripts/darwin/run_onchange_after_configure-defaults.sh` — sets macOS `defaults` for Finder and Dock
- `home/.chezmoiscripts/darwin/run_onchange_after_configure-dock.sh` — removes stock Apple apps from the Dock via `dockutil`

## Neovim config

`home/dot_config/nvim/` is a [LazyVim](https://www.lazyvim.org/) setup:

- `lua/config/lazy.lua` — bootstraps lazy.nvim and imports `lazyvim.plugins` then the local `plugins/` module
- `lua/config/` — `options.lua`, `keymaps.lua`, `autocmds.lua`
- `lua/plugins/` — plugin overrides/additions: `colorscheme.lua`, `conform.lua`, `nvim-lint.lua`, `lsp-extras.lua`, `git-plugins.lua`, `ui.lua`

Add new plugins by creating a file in `lua/plugins/`. LazyVim extras are enabled via `lazyvim.json`.

## oh-my-zsh customizations

Custom aliases and functions live in `home/dot_oh-my-zsh/custom/`:

- `aliases.zsh`
- `functions.zsh`

oh-my-zsh itself is not committed — it's fetched as an external archive defined in `.chezmoiexternal.toml`.
