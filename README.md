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

The course is organised into four sections. Here is the file you work with in
every lecture — clone this repo and open the matching file as you follow along.

**Section 1 — Introduction** (no files yet; clone the repo and you're ready)
| Lecture | File(s) |
|---|---|
| 1. Introduction | *this repository — clone it now* |
| 2. Installing Vim on Any OS | — |
| 3. Getting Started with Modes | `demo/sample.py` (practice buffer) |

**Section 2 — Core Vim Skills**
| Lecture | File(s) |
|---|---|
| 4. Configuring Vim with vimrc | `stages/03-essential-vimrc/vimrc` |
| 5. Advanced Navigation and Motions | `demo/app.py` |
| 6. Editing Basics – Operators and Text Objects | `demo/app.py`, `demo/sample.py` |
| 7. Advanced Editing – Registers and Macros | `demo/sample.py` |
| 8. File Management with netrw | `stages/07-netrw/vimrc` |
| 9. The Leader Key and Custom Mappings | `stages/07-netrw/vimrc` |

**Section 3 — Moving to Neovim**
| Lecture | File(s) |
|---|---|
| 10. Switching to Neovim | `stages/10-neovim-switch/init.vim` |
| 11. Colorschemes and Appearance | `stages/10-neovim-switch/colors/hackertheme.vim` |
| 12. Installing Plugins | `stages/12-lua-config/` |
| 13. Configuring Neovim with Lua | `stages/12-lua-config/init.lua`, `lua/myconfig/init.lua` |
| 14. Native LSP and Autocompletion | `stages/13-lsp/` |

**Section 4 — Building a Modern IDE** (all from `nvim/`, the final config)
| Lecture | File(s) |
|---|---|
| 15. Quick Reference and Cheatsheet | this README + `nvim/README.md` |
| 16. A Modern Modular Config | `nvim/init.lua`, `nvim/lua/config/` |
| 17. The Complete IDE Setup | `nvim/lua/plugins/` (editor, lsp, completion, ui) |
| 18. Debugging and Testing | `nvim/lua/plugins/dap.lua`, `nvim/lua/plugins/neotest.lua` |
| 19. Git Inside the Editor | `nvim/lua/plugins/git.lua`, `nvim/lua/plugins/octo.lua` |
| 20. Power Tips and Next Steps | `nvim/` (the whole config) |

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
