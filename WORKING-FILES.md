# What You Work On — Folder & Files by Lecture

Everything lives in this one repo. Clone it once and open the matching file as
you follow along.

```bash
git clone https://github.com/KishoreNewton/vim-course
cd vim-course
```

**The three places you work:**

| Folder | What it is |
|---|---|
| `demo/` | The practice files you edit on camera. Break them freely — `git checkout -- .` restores them. |
| `~/.config/nvim/` | Your Neovim config. You build this up from scratch across Sections 3–4. |
| `~/projects/scratchpad.nvim/` | The plugin you build with your own hands in Section 5. |

**The files inside `demo/`:**

| File | What it is |
|---|---|
| `sample.py` | A scratch file — greet / calculate / Logger / DataProcessor. The one to abuse: break it however you like. |
| `app.py` | A small task-management app (TaskFlow). The realistic file you navigate and refactor. |
| `guide.md` | A Markdown command handbook — used for text-object and search-and-replace practice. |
| `test_app.py` | The test suite. Matters in the Debugging & Testing lecture. |

Behind on config? Copy the matching snapshot from [`stages/`](stages/) and you
are instantly caught up.

---

## Section 1 — Introduction

| Lecture | Work in | File(s) | What you do |
|---|---|---|---|
| Installing Vim on Any OS | — | — | Install Vim; nothing to open yet |
| **Course Files** | repo root → `demo/` | `demo/sample.py` | Clone the repo, tour it, open your first file in plain Vim, learn `:q` and `git checkout -- .` |
| Getting Started with Modes | `demo/` | just `vim` (an empty buffer) | Normal / Insert / Visual / Command modes — the four modes explained |

## Section 2 — Core Vim Skills

| Lecture | Work in | File(s) | What you do |
|---|---|---|---|
| Configuring Vim with vimrc | `~/` | `~/.vimrc` | Write your first vimrc (numbers, search, indent) |
| Advanced Navigation and Motions | `demo/` | `guide.md` | `w b e`, `f t`, `0 $ ^`, `gg G`, `%`, counts |
| Editing Basics – Operators and Text Objects | `demo/` | `guide.md` | `d c y` + text objects (`iw`, `i"`, `ip`, …) |
| Advanced Editing – Registers and Macros | `demo/` | `guide.md` | Registers, `.` repeat, record & replay macros |
| **Power Editing: Repeat, Block, and Shape** | `demo/` | `sample.py`, `guide.md` | The dot command, `Ctrl-v` visual block, `J` / `>>` / `gq` line shaping |
| **Power Navigation: Marks, Jumps, and the Global Command** | `demo/` | `sample.py`, `app.py` | Marks (`` `a ``), the jumplist (`Ctrl-o` / `Ctrl-i`), `*` / `#` / `%`, `:g` / `:v` |
| File Management with netrw | `demo/` | *(netrw explorer)* | Browse, create, rename, delete files without leaving Vim |
| The Leader Key and Custom Mappings | `~/` + `demo/` | `~/.vimrc`, `sample.py` | Set a leader key and build your own mappings |

## Section 3 — Moving to Neovim

| Lecture | Work in | File(s) | What you do |
|---|---|---|---|
| Switching to Neovim | `~/.config/nvim/` + `demo/` | `~/.config/nvim/init.vim`, `sample.py` | Install Neovim (0.11+), migrate your settings, meet the built-in terminal & `:checkhealth` |
| Colorschemes and Appearance | `~/.config/nvim/colors/` | `hackertheme.vim`, `sample.py` | Build a custom colorscheme highlight-group by highlight-group |
| **A Permanent Theme and a Plugin Manager** | `~/.config/nvim/` | `init.vim` | Add `colorscheme hackertheme` to the config; install vim-plug with the official curl command; write the empty `plug#begin`/`plug#end` block |
| Installing Plugins | `~/.config/nvim/` | `init.vim` | Add plugins with vim-plug (surround, treesitter, gitsigns, …) |
| Configuring Neovim with Lua | `~/.config/nvim/` + `demo/` | `init.lua`, `lua/myconfig/init.lua`, `lua/wordcount/init.lua` | Learn Lua, migrate `init.vim` → `init.lua`, write your first plugin module |
| Native LSP and Autocompletion | `~/.config/nvim/` + `demo/` | `init.lua`, `learn.lua` | Mason + native LSP, completion, go-to-definition, diagnostics |

## Section 4 — Building a Modern IDE

| Lecture | Work in | File(s) | What you do |
|---|---|---|---|
| Quick Reference and Cheatsheet | — | *(recap)* | A consolidated cheat-sheet of everything so far |
| A Modern Modular Config | `~/.config/nvim/` | `init.lua`, `lua/config/{options,keymaps,lazy}.lua`, `lua/plugins/`, `lsp/` | Split the flat config into a real modular layout; switch to lazy.nvim |
| **Install the Finished Config** | `~/.config/nvim/` + `demo/` | swaps in `~/vim-course/nvim/`; opens `app.py` | Back up your build, install the finished editor, first boot (`:Lazy`, `:Mason`) |
| The Complete IDE Setup | `~/.config/nvim/` + `demo/` | `lua/config/options.lua`, `app.py` | Grand tour of the finished editor — pickers, git signs, statusline |
| **Format, Fix, and Select Smarter** | `demo/` | `app.py` | Format-on-save (conform), LSP code actions, treesitter text objects, snippets |
| Debugging and Testing | `demo/` | `sample.py`, `test_app.py` | DAP breakpoints & stepping; run the test suite from the editor |
| Git Inside the Editor | `demo/` (a git repo) | `app.py` | gitsigns, lazygit, diffview |
| **Merge Conflicts** | `demo/` (mid-merge) | `app.py` | Read `<<<<<<<` / `=======` / `>>>>>>>`, resolve both sides, conclude the merge |
| Power Tips and Next Steps | `demo/` | `scratch.lua` | Buffer tricks, quickfix, and where to go next |
| **Quickfix, Project Replace, and Sessions** | `demo/` | `app.py`, `worker.py`, `sample.py` | `:grep` → quickfix → `:cfdo`, grug-far project replace, persistence sessions |

## Section 5 — Build Your Own Plugin

The section opens with a tour of the documentation (nothing to clone). The build
itself happens in your own `~/projects/scratchpad.nvim/`, with the loader spec at
`~/.config/nvim/lua/plugins/scratchpad.lua`.

| Lecture | Work in | File(s) | What you do |
|---|---|---|---|
| **What The Editor Gives You** | — *(the built-in manual)* | `:h lua-guide`, `:h write-plugin`, `:h runtimepath`, `:h news`, `:h help-summary` | What Neovim exposes (`api`, `fn`, `opt`, `keymap`, `lsp`, `treesitter`, `diagnostic`, `uv`, `ui`) and how to find the docs for any function — `:h <name>`, `Ctrl-]` / `Ctrl-o`, `gO`, `<leader>fh`, `:helpgrep` → quickfix |
| Your First Plugin | `~/projects/scratchpad.nvim/` | `lua/scratchpad/init.lua`, `~/.config/nvim/lua/plugins/scratchpad.lua` | A plugin is just a folder: runtimepath, the module pattern, a lazy `dir=` spec |
| Config, Commands, and Keymaps | `~/projects/scratchpad.nvim/` | `lua/scratchpad/init.lua` | Defaults + config merge, `:Scratch`, `<leader>j` |
| The Floating Window | `~/projects/scratchpad.nvim/` | `lua/scratchpad/init.lua` | Buffers vs windows, `nvim_open_win`, toggle, save-on-`q` |
| Ship Your Plugin | `~/projects/scratchpad.nvim/` | `README.md`, `doc/scratchpad.txt` | A README, a real `:help` file + helptags, publish to git |

---

*Bold lectures are the newest additions. Every `demo/` file is safe to wreck —
`git checkout -- .` from inside the repo restores all of them at once.*
