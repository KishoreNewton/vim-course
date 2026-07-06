# Neovim configuration

A modern, modular Neovim setup built on **[lazy.nvim](https://lazy.folke.io)**,
targeting **Neovim 0.11+/0.12** with native LSP. Keeps the original
green-on-black *hackertheme* aesthetic and personal touches (cursor trail, PDF
viewer) while pulling in the 2026 best-in-class plugin stack.

> Rebuilt from an older vim-plug/packer config. A timestamped backup of the
> previous setup lives at `~/.config/nvim.backup-*`.

## Layout

```
init.lua                 entry point; sets leader, loads config/ then plugins
lua/config/
  options.lua            editor options (ported & modernised from init.vim)
  keymaps.lua            global, non-plugin keymaps
  autocmds.lua           autocommands + wires up custom modules
  lazy.lua               lazy.nvim bootstrap + setup
  lsp.lua                native vim.lsp.config('*'), LspAttach maps, diagnostics
lua/plugins/             one file per concern, auto-imported by lazy.nvim
lua/custom/
  cursor-trail.lua       animated cursor trail (toggle: <leader>ut)
  pdf.lua                view PDFs as text via pdftotext
lsp/                     per-server vim.lsp settings (lua_ls, ts_ls, …)
colors/hackertheme.vim   the original colourscheme (default)
```

## Requirements

External tools (most already present on this machine):

| Tool          | Purpose                                  | Install (Arch)             |
| ------------- | ---------------------------------------- | -------------------------- |
| `git`         | lazy.nvim, gitsigns, fugitive            | `pacman -S git`            |
| `ripgrep`     | grep picker, live grep                   | `pacman -S ripgrep`        |
| `fd`          | file picker                              | `pacman -S fd`             |
| `tree-sitter` | compiling TS parsers (main branch)       | `pacman -S tree-sitter-cli`|
| `lazygit`     | `<leader>gg` git UI                      | `pacman -S lazygit`        |
| `gh`          | octo.nvim (GitHub PRs/issues)            | `pacman -S github-cli`     |
| `curl`        | kulala REST client                       | `pacman -S curl`           |
| `pdftotext`   | PDF viewer (poppler)                     | `pacman -S poppler`        |
| a C compiler  | TS parsers, LuaSnip jsregexp             | `pacman -S gcc`            |
| Go toolchain  | go.nvim codegen (gomodifytags, impl, …)  | `pacman -S go`             |
| Nerd Font     | icons in the UI                          | any Nerd Font              |

Language servers and formatters are installed automatically by **Mason** on
first launch (`:Mason` to inspect). A Nerd Font terminal is strongly recommended.

## First launch

1. `nvim` — lazy.nvim bootstraps itself and installs all plugins.
2. Mason installs the configured LSP servers, formatters and linters in the
   background (watch progress with `:Mason`).
3. Treesitter compiles parsers (needs `tree-sitter` + a C compiler).
4. Restart once everything settles. `:checkhealth` to verify.

## Highlights of the stack

- **Plugin manager:** lazy.nvim
- **Completion:** [blink.cmp](https://github.com/saghen/blink.cmp) (pinned `1.*`) + LuaSnip
- **LSP:** native `vim.lsp.config`/`vim.lsp.enable` + Mason v2 (`mason-org/*`)
- **Treesitter:** `main` branch (required for 0.12) — highlighting, indent, folds
- **Fuzzy finder / dashboard / notifier / indent / lazygit / terminal:**
  [snacks.nvim](https://github.com/folke/snacks.nvim)
- **File explorer:** netrw (built-in, preferred) on `<leader>e`/`<leader>pv`/`<leader>E`
- **File explorer (alt):** snacks explorer (`<leader>fE`), neo-tree (`<leader>fe`)
- **Format / lint:** conform.nvim + nvim-lint
- **Git:** gitsigns, fugitive, diffview, lazygit (via snacks)
- **UX:** which-key, trouble, todo-comments, noice, flash, nvim-surround
- **Rust:** rustaceanvim · **Notes:** obsidian.nvim (community fork) + render-markdown
- **Statusline:** lualine (themed to match hackertheme)
- **Debugging:** nvim-dap + nvim-dap-view — Python (debugpy), Go (delve), C/C++
  (codelldb), JS/TS/Node (js-debug/pwa-node); Rust via rustaceanvim (`<leader>dr`)
- **Testing:** neotest (+ Go / Python / Vitest adapters; Rust via rustaceanvim)
- **Folding:** nvim-ufo (LSP folding ranges + indent fallback)
- **Workflow:** smart-splits (tmux/wezterm/kitty pane nav), arrow (file jumper),
  dial (smart inc/dec), treesitter-context (sticky scroll), refactoring.nvim,
  overseer (task runner), outline.nvim, nvim-window-picker, ccc (colour picker)
- **Database:** vim-dadbod + dadbod-ui + completion (Postgres/MySQL/SQLite)
- **REST/HTTP:** kulala.nvim (run `.http` files in-editor)
- **GitHub:** octo.nvim (review PRs, manage issues; needs `gh` CLI)
- **Code nav/edit:** treewalker (AST move/swap), actions-preview (diff code actions),
  multicursor.nvim, precognition (motion hints), dap-breakpoints (conditional bp UI)
- **Language extras:** ray-x/go.nvim (Go codegen), package-info (npm versions)

## Key bindings

Leader is **`<Space>`**. Press `<leader>` and wait for **which-key** to show the
menu. Most-used:

### Find / files (snacks picker)
| Key | Action |
| --- | --- |
| `<leader><space>` | Smart find files |
| `<leader>ff` / `<leader>fg` | Find files / live grep |
| `<leader>fr` / `<leader>fb` | Recent files / buffers |
| `<leader>fd` / `<leader>fw` | Diagnostics / grep word |
| `<C-p>` | Buffers (original muscle memory) |
| `<leader>e` / `<leader>pv` | netrw explorer (current window) |
| `<leader>E` | netrw side panel (`:Lexplore`) |
| `<leader>fE` / `<leader>fe` | snacks explorer / neo-tree (alternatives) |

### LSP (native `gr*` defaults + additions)
| Key | Action |
| --- | --- |
| `gd` `gD` `gr` `gI` `gy` | definition, declaration, references, impl, type def |
| `grn` `gra` | rename, code action (Neovim defaults) |
| `K` `<C-S>` | hover, signature help (insert) |
| `[d` `]d` | prev/next diagnostic |
| `<leader>ca` `<leader>cr` `<leader>cf` | code action, rename, format |
| `<leader>uh` | toggle inlay hints |

### Git
| Key | Action |
| --- | --- |
| `<leader>gg` | Lazygit |
| `<leader>gd` `<leader>gf` | Diffview / file history |
| `]h` `[h` | next / prev hunk |
| `<leader>hs` `<leader>hr` `<leader>hp` `<leader>hb` | stage / reset / preview / blame hunk |

### Diagnostics / Trouble
| Key | Action |
| --- | --- |
| `<leader>xx` `<leader>xX` | workspace / buffer diagnostics |
| `<leader>xs` `<leader>xl` | symbols / LSP refs |

### Debug (`<leader>d…`, DAP)
| Key | Action |
| --- | --- |
| `<leader>db` `<leader>dB` | toggle / conditional breakpoint |
| `<leader>dc` `<leader>dC` | continue·start / run to cursor |
| `<leader>do` `<leader>di` `<leader>dO` | step over / into / out |
| `<leader>du` `<leader>dE` | toggle DAP UI / REPL |
| `<leader>dr` | Rust debuggables (rustaceanvim) |
| `<leader>dh` `<leader>dt` `<leader>dL` | hover value / terminate / run last |

### Test (`<leader>t…`, neotest)
| Key | Action |
| --- | --- |
| `<leader>tn` `<leader>tf` `<leader>ta` | run nearest / file / suite |
| `<leader>tl` `<leader>td` | run last / debug nearest (DAP) |
| `<leader>ts` `<leader>tO` `<leader>to` | summary / output panel / output float |
| `<leader>tw` `<leader>tS` | watch file / stop |

### Refactor & tasks
| Key | Action |
| --- | --- |
| `<leader>re` `<leader>rv` `<leader>rb` | extract function / variable / block (visual) |
| `<leader>rI` `<leader>rr` | inline variable / select refactor |
| `<leader>Rr` `<leader>Rt` `<leader>Ra` | overseer run / toggle list / quick action |
| `<leader>cs` | symbol outline panel |
| `<leader>cp` `<leader>cv` | colour picker / convert |
| `<leader>cg…` `<leader>cn…` | Go codegen / npm package (in go / package.json files) |

### Database / HTTP / GitHub
| Key | Action |
| --- | --- |
| `<leader>Bu` `<leader>Bf` `<leader>Ba` | database UI / find buffer / add connection |
| `<leader>Hs` `<leader>Ha` `<leader>Ht` `<leader>Hc` | HTTP send / send all / toggle view / copy as curl (`.http`) |
| `<leader>ghp` `<leader>ghi` `<leader>ghr` | GitHub PRs / issues / start review (octo) |

### Editing & motion
| Key | Action |
| --- | --- |
| `s` / `S` | flash jump / treesitter select |
| `<C-h/j/k/l>` | move between splits (+ tmux/wezterm/kitty panes) |
| `<A-h/j/k/l>` | resize split |
| `<M-h/j/k/l>` | move line/selection |
| `<M-arrows>` | treewalker: move by AST node |
| `<leader>K` / `<leader>J` | treewalker: swap node up / down |
| `<c-q>` / `<leader>m…` | multicursor: toggle cursor / add-match menu |
| `<C-a>` / `<C-x>` | smart increment / decrement (bools, dates, semver) |
| `;` / `M` | arrow file jumper menu / buffer bookmarks |
| `<leader>wp` | pick window by letter |
| `gS` | split/join arguments |
| `gp` / `<leader>cf` | format buffer |
| `<C-s>` | save · `<leader>U` undo tree |
| `zR` `zM` `zp` | open / close all folds · peek fold (ufo) |

### UI toggles (`<leader>u…`)
spell `us` · wrap `uw` · diagnostics `ud` · inlay hints `uh` · indent `ug` ·
format-on-save `uf` · diagnostic style `uv` · cursor trail `ut` · sticky context `ux`
· zen `<leader>z`

### Terminal / misc
`<F7>` or `<C-/>` toggle terminal · `<leader>.` scratch · `<leader>L` Lazy ·
`<leader>cm` Mason · `<F2>` yank file path

## Customisation notes

- **Colourscheme:** hackertheme is the default. catppuccin, tokyonight, kanagawa
  and rose-pine are installed — switch with `<leader>uC` or `:colorscheme`.
- **Obsidian:** edit the `workspaces` path in `lua/plugins/lang.lua` to point at
  your real vault (defaults to `~/notes`).
- **Format on save:** on by default; toggle with `<leader>uf` or `:FormatDisable`.
- **Disable a plugin:** add `enabled = false` to its spec in `lua/plugins/`.
- **Debugging:** `<leader>dc` starts a session and shows a config picker —
  Python, Go, C/C++, and JS/TS/Node are all wired (Rust via `<leader>dr`). Debug
  adapters (debugpy, delve, codelldb, js-debug-adapter) install through Mason on
  first use. For C/C++, build with debug symbols (`-g`) and point the launch
  prompt at the executable. For TS launch you need `tsx` on PATH (or debug the
  compiled `.js`); the attach config works against any `node --inspect` process.
- **Database:** define connections via `vim.g.dbs` in `lua/plugins/db.lua`, or add
  them interactively with `<leader>Ba`. Keep credentials out of git (use a
  `connections.json` under `stdpath('data')/db_ui`, not the repo).
- **GitHub (octo):** run `gh auth login` once; then `<leader>ghp` lists PRs.
- **Seamless tmux/multiplexer nav:** `<C-h/j/k/l>` move between Neovim splits *and*
  terminal multiplexer panes — but the **multiplexer side needs companion config**.
  For tmux, add to `~/.tmux.conf`:
  ```tmux
  bind-key -n C-h if -F "#{@pane-is-vim}" 'send-keys C-h' 'select-pane -L'
  bind-key -n C-j if -F "#{@pane-is-vim}" 'send-keys C-j' 'select-pane -D'
  bind-key -n C-k if -F "#{@pane-is-vim}" 'send-keys C-k' 'select-pane -U'
  bind-key -n C-l if -F "#{@pane-is-vim}" 'send-keys C-l' 'select-pane -R'
  ```
  (wezterm/kitty/zellij have equivalents — see the smart-splits.nvim README.)
