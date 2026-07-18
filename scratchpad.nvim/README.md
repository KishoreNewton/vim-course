# scratchpad.nvim

One floating notes pad per project. Toggle it, jot, q to close.

Built from scratch in **Sections 21–24** of the course — every line is
explained on camera. `stages/21-first-plugin/`, `stages/22-commands-config/`
and `stages/23-floating-window/` hold the intermediate snapshots; this folder
is the finished plugin.

## Install (lazy.nvim)

While following the course (local checkout):

```lua
{
  dir = vim.fn.expand("~/projects/scratchpad.nvim"),
  opts = {},
  lazy = false, -- the course config lazy-loads by default
}
```

The day you publish your own copy:

```lua
{ "yourname/scratchpad.nvim", opts = {} }
```

## Defaults

```lua
{
  dir = vim.fn.stdpath("data") .. "/scratchpad", -- where notes live
  keymap = "<leader>j",                          -- j for jot
  width = 0.6,                                   -- fraction of the screen
  height = 0.6,
  border = "rounded",
  title = " Scratchpad ",
}
```

Every field can be overridden from the spec, e.g. `opts = { title = " Notes " }`.

## Usage

- `:Scratch` or `<leader>j` — toggle the pad
- `q` (inside the pad) — save and close
- Notes are one markdown file per project, named after the flattened
  working-directory path, e.g. `_home_you_projects_myapp.md`.

## Help

`:h scratchpad` — the manual ships in `doc/scratchpad.txt`.
