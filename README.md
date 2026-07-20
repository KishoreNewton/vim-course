# Vim Course — Companion Files

Everything you watched in the course runs from this repository: the demo files
typed on camera, the configuration at every stage of the journey, and — the
main event — the complete modern Neovim setup from Sections 15–19.

```
demo/     the files edited on camera (app.py, sample.py, tests, todo demos)
stages/   configuration snapshots at each milestone of the course
nvim/     the final, complete modern config (Sections 15–19) ← clone target
```

## Files used in each lecture

Not sure which file to open for a given lecture?
**→ [`WORKING-FILES.md`](WORKING-FILES.md)** maps every lecture to the exact
folder and file(s) you work in, across all five sections — clone this repo and
open the matching file as you follow along.

At a glance:

| Section | You work in |
|---|---|
| 1 — Introduction | clone the repo, then `demo/sample.py` |
| 2 — Core Vim Skills | `demo/` (`sample.py`, `app.py`, `guide.md`) + your `~/.vimrc` |
| 3 — Moving to Neovim | `~/.config/nvim/` (build it up) + `demo/` |
| 4 — Building a Modern IDE | the finished `~/.config/nvim/` (from `nvim/`) + `demo/` |
| 5 — Build Your Own Plugin | `~/projects/scratchpad.nvim/` |

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
git clone https://github.com/KishoreNewton/vim-course ~/vim-course
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
| `stages/21-first-plugin/` | 21 | scratchpad.nvim v1 — the module pattern + lazy `dir=` spec |
| `stages/22-commands-config/` | 22 | + config merge, `:Scratch`, `<leader>j` |
| `stages/23-floating-window/` | 23 | + the floating window, toggle, save-on-`q` |
| `scratchpad.nvim/` | 21–24 | The finished plugin — README, `:help`, MIT license |

Vim-era stages: copy `vimrc` to `~/.vimrc`.
Neovim stages: copy the stage's contents to `~/.config/nvim/`
(e.g. `cp -r stages/12-lua-config/* ~/.config/nvim/`).
Sections 11–13 use [vim-plug](https://github.com/junegunn/vim-plug) — install
it first, then run `:PlugInstall`.

## Build your own plugin (Sections 21–24)

Sections 21–24 build **scratchpad.nvim** — a floating, per-project notes pad —
from an empty folder to a shippable repo. The plugin stages hold the
`lua/scratchpad/init.lua` as it stands at the end of each section, plus the
`plugins-scratchpad.lua` spec for that stage (it belongs at
`~/.config/nvim/lua/plugins/scratchpad.lua`). To follow along:

```sh
mkdir -p ~/projects/scratchpad.nvim
cp -r stages/21-first-plugin/lua ~/projects/scratchpad.nvim/
cp stages/21-first-plugin/plugins-scratchpad.lua \
   ~/.config/nvim/lua/plugins/scratchpad.lua
```

The finished plugin lives in [`scratchpad.nvim/`](scratchpad.nvim/) — diff
your build against it, break it, extend it, and publish your own.

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
