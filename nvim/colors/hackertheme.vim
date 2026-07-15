" Vim color file
" Maintainer: Kishore Newton <contact+vimneovim@kishorenewton.com>
" Last Change: 2024-09-01
" License: MIT
hi clear
if exists("syntax_on")
    syntax reset
endif
let g:colors_name = "hackertheme"
" Hacker Theme Color Scheme 
"
" Popup Menu / Autocomplete
hi Visual term=none cterm=none guibg=#FFFFFF  guifg=#000000
highlight Pmenu guibg=#0a0a0f guifg=#e0e0e0
highlight PmenuSel guibg=#00ff00 guifg=#000000 gui=bold
highlight PmenuSbar guibg=#151520
highlight PmenuThumb guibg=#00ff00

" Completion Menu (nvim-cmp)
highlight CmpItemAbbr guifg=#e0e0e0
highlight CmpItemAbbrDeprecated guifg=#808080 gui=strikethrough
highlight CmpItemAbbrMatch guifg=#00ff00 gui=bold
highlight CmpItemAbbrMatchFuzzy guifg=#00dd00 gui=bold
highlight CmpItemKind guifg=#00ff88
highlight CmpItemMenu guifg=#808080 gui=italic

" Completion Item Kinds
highlight CmpItemKindText guifg=#e0e0e0
highlight CmpItemKindMethod guifg=#9DE0AD
highlight CmpItemKindFunction guifg=#9DE0AD
highlight CmpItemKindConstructor guifg=#FB7BBE
highlight CmpItemKindField guifg=#FFE5B4
highlight CmpItemKindVariable guifg=#00ff00
highlight CmpItemKindClass guifg=#FB7BBE
highlight CmpItemKindInterface guifg=#86E3CE
highlight CmpItemKindModule guifg=#A9D0F5
highlight CmpItemKindProperty guifg=#FFE5B4
highlight CmpItemKindUnit guifg=#EFF0EB
highlight CmpItemKindValue guifg=#EFF0EB
highlight CmpItemKindEnum guifg=#CCABD8
highlight CmpItemKindKeyword guifg=#A9D0F5
highlight CmpItemKindSnippet guifg=#FF9CDA
highlight CmpItemKindColor guifg=#FFF066
highlight CmpItemKindFile guifg=#4FC1FF
highlight CmpItemKindReference guifg=#AAB6FB
highlight CmpItemKindFolder guifg=#4FC1FF
highlight CmpItemKindEnumMember guifg=#CCABD8
highlight CmpItemKindConstant guifg=#EFF0EB gui=bold
highlight CmpItemKindStruct guifg=#FB7BBE
highlight CmpItemKindEvent guifg=#FAA7B8
highlight CmpItemKindOperator guifg=#FFDCA2
highlight CmpItemKindTypeParameter guifg=#86E3CE

" Float Window
highlight NormalFloat guibg=#0a0a0f guifg=#e0e0e0
highlight FloatBorder guifg=#00ff00 guibg=#0a0a0f
highlight FloatTitle guifg=#00ff00 guibg=#0a0a0f gui=bold
" General Text — guibg=NONE keeps the terminal background showing through.
highlight Normal guifg=#00ff00 guibg=NONE ctermbg=NONE
highlight NormalNC guifg=#00ff00 guibg=NONE ctermbg=NONE
" Everything that frames the text must be transparent too, or you get bars.
highlight SignColumn guibg=NONE ctermbg=NONE
highlight FoldColumn guibg=NONE ctermbg=NONE
highlight EndOfBuffer guibg=NONE ctermbg=NONE
highlight LineNrAbove guibg=NONE ctermbg=NONE
highlight LineNrBelow guibg=NONE ctermbg=NONE
highlight CursorLineNr guifg=#00ff00 guibg=NONE gui=bold
highlight VertSplit guibg=NONE ctermbg=NONE
highlight Comment guifg=#D1D1D1 gui=italic
highlight String guifg=#FFF066
" Syntax Elements
highlight Number guifg=#EFF0EB gui=bold
highlight Boolean guifg=#86E3CE
highlight Float guifg=#EFF0EB gui=italic
highlight Function guifg=#9DE0AD
highlight Conditional guifg=#CFF4D2 gui=italic
highlight Repeat guifg=#CCABD8 gui=italic
highlight Label guifg=#D3E7EE gui=italic
highlight Operator guifg=#FFDCA2 gui=bold
highlight Keyword guifg=#A9D0F5 gui=italic
highlight Identifier guifg=#FFE5B4
highlight Exception guifg=#AAB6FB gui=bold
highlight StorageClass guifg=#FAA7B8 gui=italic
highlight Structure guifg=#FB7BBE gui=italic
highlight Special guifg=#FF9CDA gui=italic
highlight SpecialComment guifg=#9B9B9B gui=bold
highlight netrwDir guifg=#4FC1FF 
" Line Numbers and Status Bar
highlight LineNr guifg=#FDE4E3
highlight StatusLine guifg=#FDE4E3 guibg=#000000 ctermfg=NONE ctermbg=NONE cterm=italic
highlight StatusLineNC guifg=#FF5733
" Cursor Line, Search and Matching Brackets
highlight CursorLine guibg=#1a1a1a
highlight Search guifg=#0a0a0a guibg=#9DE0AD
highlight IncSearch guifg=#0a0a0a guibg=#FFDCA2 gui=bold
highlight CurSearch guifg=#0a0a0a guibg=#FFF066 gui=bold
highlight MatchParen guifg=#0a0a0a guibg=#FFDCA2 gui=bold
" Tab Line
highlight TabLine guibg=#355C7D ctermfg=NONE ctermbg=NONE cterm=italic
highlight TabLineSel guifg=#05386B guibg=#5CDB95 gui=bold ctermfg=NONE ctermbg=NONE cterm=bold
highlight TabLineFill guifg=#111111 guibg=#000000 ctermfg=254 ctermbg=238
" LSP Colors
" hi @lsp.type.function guifg=Yellow
" hi @lsp.type.variable.lua guifg=Green
hi @lsp.type.variable guifg=#00ff00
" hi @lsp.mod.deprecated gui=strikethrough
" hi @lsp.typemod.function.async guifg=#FF0000
" Spell Checking
hi SpellBad ctermfg=black
hi SpellCap ctermfg=black
hi SpellLocal ctermfg=black
hi SpellRare ctermfg=black
hi SpellRareUnderlined ctermfg=black cterm=underline
hi SpellLocalUnderlined ctermfg=black cterm=underline
hi SpellCapUnderlined ctermfg=black cterm=underline
hi SpellBadUnderlined ctermfg=black cterm=underline
hi NonText guifg=#C9BBC8 gui=bold
" Copilot Suggestion
highlight CopilotSuggestion guifg=#d1001c ctermfg=8
hi WinSeparator guibg=None

" ═══════════════════════════════════════════════════════════════════════════
"  Treesitter + LSP layers  (added 2026-06-20)
"
"  Everything above styles LEGACY :syntax groups. That was enough when JS/TS
"  were highlighted by Vim's regex syntax files — javaScript* groups link to
"  Function/Identifier/Keyword/Conditional/… so the whole file got colour.
"
"  On Neovim 0.11+ two newer layers paint instead, and they were unstyled:
"    · @treesitter captures     — what paints most buffers now
"    · @lsp.type.* semantic tokens — ts_ls tags nearly every JS/TS identifier,
"      and these OVERRIDE treesitter (priority 125 vs 100)
"
"  Lua/Rust/Python lean on @keyword/@function/@string, which Neovim links to
"  the legacy groups above by default — so they kept their colours. JS/TS lean
"  on @type, @variable.member, @punctuation and @constructor, which link to
"  legacy groups this file never defined (Type, Delimiter, Constant …) — so
"  they fell back to Neovim's grey #e0e2ea. Hence "TS/JS lost all the colour".
" ═══════════════════════════════════════════════════════════════════════════

" ── Legacy groups the newer layers fall back to (were missing) ──────────────
hi Type           guifg=#86E3CE
hi Typedef        guifg=#86E3CE gui=italic
hi Constant       guifg=#EFF0EB gui=bold
hi Character      guifg=#FFF066
hi Statement      guifg=#A9D0F5 gui=italic
hi PreProc        guifg=#CCABD8
hi Include        guifg=#A9D0F5 gui=italic
hi Define         guifg=#CCABD8
hi Macro          guifg=#FF9CDA
hi PreCondit      guifg=#CCABD8
hi SpecialChar    guifg=#FF9CDA
hi Tag            guifg=#FB7BBE
hi Title          guifg=#9DE0AD gui=bold
hi Todo           guifg=#0a0a0f guibg=#FFF066 gui=bold
hi Error          guifg=#FF5F5F gui=bold
hi Directory      guifg=#4FC1FF
" Punctuation stays base-green: unhighlighted text read as Normal under the
" old regex syntax, so this keeps braces/semicolons looking the way they did.
hi! link Delimiter Normal

" ── Treesitter captures (Neovim resolves @a.b.c → @a.b → @a) ────────────────
hi! link @variable              Normal
hi @variable.builtin            guifg=#FB7BBE gui=italic
hi @variable.parameter          guifg=#FFE5B4 gui=italic
hi @variable.member             guifg=#FFE5B4
hi! link @property              @variable.member
hi! link @field                 @variable.member

hi! link @constant              Constant
hi @constant.builtin            guifg=#86E3CE gui=bold
hi @module                      guifg=#4FC1FF
hi! link @namespace             @module
hi! link @label                 Label

hi! link @string                String
hi @string.escape               guifg=#FF9CDA gui=bold
hi @string.special              guifg=#FF9CDA
hi! link @string.regexp         @string.special
hi! link @character             Character
hi! link @number                Number
hi! link @number.float          Float
hi! link @boolean               Boolean

" Types: everywhere in TS, nearly absent from Lua/Python — the single biggest
" reason TS looked unthemed while other languages were fine.
hi! link @type                  Type
hi @type.builtin                guifg=#86E3CE gui=italic
hi! link @type.definition       Typedef
hi! link @type.qualifier        StorageClass
hi @constructor                 guifg=#FB7BBE
hi @attribute                   guifg=#CCABD8 gui=italic

hi! link @function              Function
hi @function.builtin            guifg=#9DE0AD gui=italic
hi! link @function.call         Function
hi! link @function.method       Function
hi! link @function.macro        Macro
hi! link @method                Function

hi! link @keyword               Keyword
hi! link @keyword.function      Keyword
hi! link @keyword.operator      Operator
hi! link @keyword.conditional   Conditional
hi! link @keyword.repeat        Repeat
hi! link @keyword.exception     Exception
hi! link @keyword.import        Include
hi! link @keyword.storage       StorageClass
hi! link @keyword.directive     PreProc

hi! link @operator              Operator
hi! link @punctuation.delimiter Delimiter
hi! link @punctuation.bracket   Delimiter
hi @punctuation.special         guifg=#FF9CDA

hi! link @comment               Comment
hi! link @comment.documentation SpecialComment
hi @comment.todo                guifg=#0a0a0f guibg=#FFF066 gui=bold
hi @comment.note                guifg=#0a0a0f guibg=#86E3CE gui=bold
hi @comment.warning             guifg=#0a0a0f guibg=#f5ed05 gui=bold
hi @comment.error               guifg=#0a0a0f guibg=#FF5F5F gui=bold

" JSX / TSX / HTML tags
hi @tag                         guifg=#FB7BBE
hi @tag.builtin                 guifg=#FB7BBE gui=bold
hi @tag.attribute               guifg=#FFE5B4 gui=italic
hi! link @tag.delimiter         Delimiter

" Markdown
hi! link @markup.heading        Title
hi @markup.strong               gui=bold
hi @markup.italic               gui=italic
hi @markup.strikethrough        gui=strikethrough
hi! link @markup.link           Directory
hi! link @markup.raw            String
hi! link @markup.list           Operator
hi @markup.quote                guifg=#D1D1D1 gui=italic

hi @diff.plus                   guifg=#9DE0AD
hi @diff.minus                  guifg=#FF5F5F
hi @diff.delta                  guifg=#FFDCA2

" ── LSP semantic tokens — these WIN over treesitter, so every one ts_ls emits
"    is mapped to the same colour as its treesitter twin. Whichever layer
"    paints, the result is identical. (@lsp.type.variable stays green above.)
hi! link @lsp.type.parameter        @variable.parameter
hi! link @lsp.type.property         @variable.member
hi! link @lsp.type.function         @function
hi! link @lsp.type.method           @function.method
hi! link @lsp.type.class            Structure
hi! link @lsp.type.struct           Structure
hi! link @lsp.type.interface        Type
hi! link @lsp.type.type             Type
hi! link @lsp.type.typeAlias        Type
hi! link @lsp.type.typeParameter    Typedef
hi! link @lsp.type.builtinType      @type.builtin
hi! link @lsp.type.enum             Repeat
hi! link @lsp.type.enumMember       Constant
hi! link @lsp.type.namespace        @module
hi! link @lsp.type.decorator        @attribute
hi! link @lsp.type.macro            Macro
hi! link @lsp.type.keyword          Keyword
hi! link @lsp.type.modifier         StorageClass
hi! link @lsp.type.string           String
hi! link @lsp.type.number           Number
hi! link @lsp.type.regexp           @string.regexp
hi! link @lsp.type.operator         Operator
hi! link @lsp.type.comment          Comment
hi! link @lsp.type.event            @variable.member
hi! link @lsp.type.selfKeyword      @variable.builtin
hi! link @lsp.type.lifetime         StorageClass
hi! link @lsp.type.unresolvedReference @variable
" console / window / Array … read as builtins; deprecated APIs get struck out.
hi! link @lsp.typemod.variable.defaultLibrary  @variable.builtin
hi! link @lsp.typemod.function.defaultLibrary  @function.builtin
hi! link @lsp.typemod.method.defaultLibrary    @function.builtin
hi! link @lsp.typemod.class.defaultLibrary     @type.builtin
hi! link @lsp.typemod.interface.defaultLibrary @type.builtin
hi @lsp.mod.deprecated          gui=strikethrough

" ── Diagnostics ────────────────────────────────────────────────────────────
"  The old config set these from lua/kishorenewton/lspconfig.lua; that file is
"  gone, so they belong here. Same four colours it used.
hi DiagnosticError              guifg=#FF5F5F
hi DiagnosticWarn               guifg=#f5ed05
hi DiagnosticInfo               guifg=#80c3d9
hi DiagnosticHint               guifg=#e3e3e3
hi DiagnosticOk                 guifg=#9DE0AD
hi DiagnosticUnderlineError     guisp=#FF5F5F gui=undercurl
hi DiagnosticUnderlineWarn      guisp=#f5ed05 gui=undercurl
hi DiagnosticUnderlineInfo      guisp=#80c3d9 gui=undercurl
hi DiagnosticUnderlineHint      guisp=#e3e3e3 gui=undercurl
hi DiagnosticVirtualTextError   guifg=#FF5F5F gui=italic
hi DiagnosticVirtualTextWarn    guifg=#f5ed05 gui=italic
hi DiagnosticVirtualTextInfo    guifg=#80c3d9 gui=italic
hi DiagnosticVirtualTextHint    guifg=#e3e3e3 gui=italic
" virtual_lines is what config/lsp.lua actually renders on the cursor line.
hi! link DiagnosticVirtualLinesError DiagnosticVirtualTextError
hi! link DiagnosticVirtualLinesWarn  DiagnosticVirtualTextWarn
hi! link DiagnosticVirtualLinesInfo  DiagnosticVirtualTextInfo
hi! link DiagnosticVirtualLinesHint  DiagnosticVirtualTextHint
hi! link DiagnosticFloatingError DiagnosticError
hi! link DiagnosticFloatingWarn  DiagnosticWarn
hi! link DiagnosticFloatingInfo  DiagnosticInfo
hi! link DiagnosticFloatingHint  DiagnosticHint
hi! link DiagnosticSignError    DiagnosticError
hi! link DiagnosticSignWarn     DiagnosticWarn
hi! link DiagnosticSignInfo     DiagnosticInfo
hi! link DiagnosticSignHint     DiagnosticHint
hi! link DiagnosticUnnecessary  Comment
hi LspInlayHint                 guifg=#5c6b5c gui=italic
hi LspSignatureActiveParameter  guifg=#FFDCA2 gui=bold
hi LspReferenceText             guibg=#1f2f1f
hi! link LspReferenceRead       LspReferenceText
hi! link LspReferenceWrite      LspReferenceText
hi! link LspReferenceTarget     LspReferenceText

