# Vim Course — Companion Files

Everything you watched in the course runs from this repository: the demo files
typed on camera, the configuration at every stage of the journey, and — the
main event — the complete modern Neovim setup from Sections 15–19.

```
demo/     the files edited on camera (app.py, sample.py, tests, todo demos)
stages/   configuration snapshots at each milestone of the course
nvim/     the final, complete modern config (Sections 15–19) ← clone target
```

## The modern config (Sections 15–19)

Requirements:

- **Neovim 0.11+** (0.12 recommended — the config uses native `vim.lsp.config`)
- `git`, a C compiler (`gcc`), and `make` (treesitter parsers)
- `ripgrep` (live grep picker) and `fd` (file picker) — optional but recommended
- A [Nerd Font](https://www.nerdfonts.com/) for icons
- `node` and `python3` if you want the JS/TS and Python language servers

Install:

```sh
# 1. Back up whatever you have — this replaces your config
mv ~/.config/nvim ~/.config/nvim.backup 2>/dev/null
mv ~/.local/share/nvim ~/.local/share/nvim.backup 2>/dev/null

# 2. Put this repo's nvim/ directory in place
git clone <this-repo-url> ~/vim-course
cp -r ~/vim-course/nvim ~/.config/nvim

# 3. Launch. lazy.nvim bootstraps itself, restores the exact plugin
#    versions from lazy-lock.json, and Mason installs the language servers.
nvim
```

The first launch downloads plugins and language servers — give it a minute,
then restart Neovim once. `lazy-lock.json` is committed, so you get the exact
plugin versions from the videos, identically, on any machine.

Key layout, as covered in Section 15:

```
nvim/
├── init.lua              4 lines of intent: leader, core modules, lazy
├── lazy-lock.json        every plugin pinned to the tested version
├── lua/config/           options · keymaps · autocmds · lsp (native wiring)
├── lua/plugins/          one file per concern, auto-imported by lazy.nvim
├── lsp/                  per-server settings (vim.lsp.config format)
└── colors/               hackertheme — the green-on-black from the course
```

## Stage snapshots

Want to follow along from the middle? Each stage is the configuration exactly
as it stands at that point in the course:

| Stage | Sections | What it is |
|---|---|---|
| `stages/03-essential-vimrc/` | 3–6 | The `~/.vimrc` built in Section 3 |
| `stages/07-netrw/` | 7–9 | Same, plus the netrw split setting |
| `stages/10-neovim-switch/` | 9–11 | First `init.vim` + the hackertheme colorscheme |
| `stages/12-lua-config/` | 12 | The pure-Lua `init.lua` conversion |
| `stages/13-lsp/` | 13–14 | vim-plug, Mason, and native LSP wiring |
| `nvim/` | 15–19 | The complete modern config |

Vim-era stages: copy `vimrc` to `~/.vimrc`.
Neovim stages: copy the stage's contents to `~/.config/nvim/`
(e.g. `cp -r stages/12-lua-config/* ~/.config/nvim/`).
Sections 11–13 use [vim-plug](https://github.com/junegunn/vim-plug) — install
it first, then run `:PlugInstall`.

## Demo files

The files typed and edited on camera. Copy them anywhere and play:

- `app.py` — the TaskFlow app used from Section 4 onward (navigation, editing,
  git hunks, lazygit, diffview)
- `sample.py` — editing practice: functions, classes, the Section 17 debugger
  demo and the Section 19 argument-splitting demo
- `test_app.py` — the pytest suite from Section 17 (one test deliberately
  fails — fixing it on camera is the point)
- `todos.py` / `scratch.lua` — Section 19's todo-comments and diagnostics demos

To recreate the Section 16+ playground exactly:

```sh
mkdir -p /tmp/vim-course-demo && cp demo/* /tmp/vim-course-demo/
cd /tmp/vim-course-demo && git init -q && git add -A && git commit -qm baseline
```

(A git repo is needed for the gitsigns/lazygit/diffview demos, and the config
attaches language servers by project root — the `.git` directory is the root
marker.)

Happy editing.
