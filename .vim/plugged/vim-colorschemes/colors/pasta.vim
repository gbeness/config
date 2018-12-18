" ██████╗  █████╗ ██████╗████████╗ █████╗
" ██╔══██╗██╔══██╗██╔═══╝╚══██╔══╝██╔══██╗
" ██████╔╝███████║██████╗   ██║   ███████║
" ██╔═══╝ ██╔══██║╚═══██║   ██║   ██╔══██║
" ██║     ██║  ██║██████║   ██║   ██║  ██║
" ╚═╝     ╚═╝  ╚═╝╚═════╝   ╚═╝   ╚═╝  ╚═╝
" A Terminal Vim colorscheme
" Author:       Andrew Huh
" Maintainer:   Andrew Huh

set background=dark

highlight clear
if exists("syntax_on")
    syntax reset
endif

" Colors:
"----------------------------------------------------------------
let s:pasta = {}

let s:pasta.Lilac       = [ '5f5f87', 60  ]
let s:pasta.Dusk        = [ '875f5f', 95  ]
let s:pasta.Heather     = [ '8787af', 103 ]
let s:pasta.Marsh       = [ '87af87', 108 ]
let s:pasta.Oasis       = [ '87afaf', 109 ]
let s:pasta.Azure       = [ '87afd7', 110 ]
let s:pasta.Bluebells   = [ 'af5f00', 130 ]
let s:pasta.Firecracker = [ 'af5f5f', 131 ]
let s:pasta.Evening     = [ 'af8787', 138 ]
let s:pasta.Flats       = [ 'afaf87', 144 ]
let s:pasta.Lavender    = [ 'afafd7', 146 ]
let s:pasta.Rose        = [ 'd75f5f', 167 ]
let s:pasta.Bellflower  = [ 'd78787', 174 ]
let s:pasta.Mallow      = [ 'dfaf5f', 179 ]
let s:pasta.Dune        = [ 'dfdfaf', 187 ]
let s:pasta.Stars       = [ 'dfdfdf', 188 ]
let s:pasta.Claret      = [ 'ff8787', 210 ]
let s:pasta.Sunset      = [ 'ffafaf', 217 ]
let s:pasta.Salt        = [ 'ffffff', 231 ]
let s:pasta.Pitch       = [ '080808', 232 ]
let s:pasta.Midnight    = [ '121212', 233 ]
let s:pasta.Twilight    = [ '1c1c1c', 234 ]
let s:pasta.Shadow      = [ '262626', 235 ]
let s:pasta.Day         = [ '303030', 236 ]
let s:pasta.Shade       = [ '3a3a3a', 237 ]
let s:pasta.Pebble      = [ '4e4e4e', 239 ]
let s:pasta.Graphite    = [ '585858', 240 ]
let s:pasta.Slate       = [ '767676', 243 ]
let s:pasta.Stone       = [ '8a8a8a', 245 ]
let s:pasta.Cloud       = [ 'c0c0c0', 7]


function! s:HL(group, fg, ...)
    " Arguments: group, guifg, guibg, gui, guisp

    let highlightString = 'hi ' . a:group . ' '

    " Settings for highlight group ctermfg & guifg
    if strlen(a:fg)
        if a:fg == 'fg'
            let highlightString .= 'guifg=fg ctermfg=fg '
        else
            let color = get(s:pasta, a:fg)
            let highlightString .= 'guifg=#' . color[0] . ' ctermfg=' . color[1] . ' '
        endif
    endif

    " Settings for highlight group termbg & guibg
    if a:0 >= 1 && strlen(a:1)
        if a:1 == 'bg'
            let highlightString .= 'guibg=bg ctermbg=bg '
        else
            let color = get(s:pasta, a:1)
            let highlightString .= 'guibg=#' . color[0] . ' ctermbg=' . color[1] . ' '
        endif
    endif

    " Settings for highlight group cterm & gui
    if a:0 >= 2 && strlen(a:2)
        let highlightString .= 'gui=' . a:2 . ' cterm=' . a:2 . ' '
    endif

    " Settings for highlight guisp
    if a:0 >= 3 && strlen(a:3)
        let color = get(s:pasta, a:3)
        let highlightString .= 'guisp=#' . color[0] . ' '
    endif

    " echom highlightString

    execute highlightString
endfunction


" Editor Settings:
"--------------------------------------------------------------------------------
call s:HL( 'Normal', 'Cloud', 'Day', 'none' )
call s:HL( 'CursorLine', '', 'Shade', 'none' )
call s:HL( 'LineNr', 'Lilac', 'Day','none' )
call s:HL( 'CursorLineNR', 'Lavender', '', 'none' )
"TODO
call s:HL( 'CursorIM', '', 'Heather', '' )


" Number Column:
"--------------------------------------------------------------------------------
call s:HL( 'Folded', 'Cloud', 'Graphite', 'none' )
call s:HL( 'FoldColumn', 'Oasis', 'Lavender', '' )
call s:HL( 'SignColumn', 'Marsh', 'Day', 'none' )
call s:HL( 'CursorColumn', '', 'Shade', '' )


" WindowTab Delimiters:
"--------------------------------------------------------------------------------
"Color of the border of split windows
call s:HL( 'VertSplit', 'Shade', 'Graphite', 'none' )
"The one that is not selected
call s:HL( 'TabLine', 'Stone', 'Shadow', 'none' )
"the empty part of the tab status line
call s:HL( 'TabLineFill', '', 'Shadow', 'none' )

"Column that show when character limit is exceeded
"call s:HL( 'ColorColumn', '', 'Sunset', '' )
"The tab that is selected
"call s:HL( 'TabLineSel', '', '', 'none' )



" File Navigation:
"--------------------------------------------------------------------------------
call s:HL( 'Directory', 'Evening', '', 'none' )
call s:HL( 'Search', 'Twilight', 'Lilac', 'none' )
call s:HL( 'IncSearch', 'Twilight', 'Azure', 'none' )


" Prompt Status:
"--------------------------------------------------------------------------------
call s:HL( 'StatusLine', 'Shadow', 'Flats', 'none' )
call s:HL( 'StatusLineNC', 'Slate', 'Shadow', 'none' )
call s:HL( 'WildMenu', 'Dune', 'Dusk', 'none' )
call s:HL( 'Title', 'Bellflower', '', 'none' )
call s:HL( 'ModeMsg', 'Flats', '', 'none' )
call s:HL( 'Question', 'Mallow', '', '' )
call s:HL( 'MoreMsg', 'Mallow', '', 'none' )


" Visual Aid:
"-------------------------------------------------------------------------------
call s:HL( 'MatchParen', 'Midnight', 'Stone', 'none' )
call s:HL( 'Visual', 'Oasis', 'Graphite', 'none' )
call s:HL( 'NonText', 'Pebble', '', 'none' )
call s:HL( 'Todo', 'Flats', 'Twilight', 'italic' )
call s:HL( 'Error', 'Firecracker', 'Shadow', 'reverse' )
call s:HL( 'ErrorMsg', 'Firecracker', 'Shadow', 'reverse' )
call s:HL( 'SpecialKey', 'Twilight', '', '' )
call s:HL( 'Underlined', 'Azure', '', 'none' )
call s:HL( 'WarningMsg', 'Bluebells', '', 'none' )
"TODO
"call s:HL( 'Ignore', '', '', '' )
"call s:HL( 'VisualNOS', '', '', 'underline' )



" Variable Types:
"--------------------------------------------------------------------------------
call s:HL( 'Constant', 'Claret', '', 'none' )
call s:HL( 'String', 'Mallow', '', 'none' )
call s:HL( 'Identifier', 'Oasis', '', 'none' )
call s:HL( 'Function', 'Azure', '', 'none' )
"TODO
"call s:HL( 'StringDelimiter', '', '', '' )
"call s:HL( 'Character', '', '', 'none' )
"call s:HL( 'Number', '', '', 'none' )
"call s:HL( 'Boolean', '', '', 'none' )
"call s:HL( 'Float', '', '', 'none' )


" Language Constructs:
"--------------------------------------------------------------------------------
call s:HL( 'Statement', 'Marsh', '', 'none' )
call s:HL( 'Operator', 'Dune', '', 'none' )
call s:HL( 'Comment', 'Slate', '', 'none' )
call s:HL( 'Special', 'Firecracker', '', 'none' )
"TODO
"call s:HL( 'SpecialChar', '', '', '' )
"call s:HL( 'Tag', '', '', '' )
"call s:HL( 'Delimiter', '', '', '' )
"call s:HL( 'SpecialComment', '', '', '' )
"call s:HL( 'Debug', '', '', '' )
"call s:HL( 'Conditional', '', '', 'none' )
"call s:HL( 'Repeat', '', '', 'none' )
"call s:HL( 'Label', '', '', 'none' )
"call s:HL( 'Keyword', '', '', 'none' )
"call s:HL( 'Exception', '', '', 'none' )


" C Like:
"--------------------------------------------------------------------------------
call s:HL( 'PreProc', 'Rose', '', 'none' )
call s:HL( 'Type', 'Evening', '', 'none' )
"TODO
"call s:HL( 'Include', '', '', 'none' )
"call s:HL( 'Define', '', '', 'none' )
"call s:HL( 'Macro', '', '', 'none' )
"call s:HL( 'PreCondit', '', '', 'none' )
"call s:HL( 'StorageClass', '', '', 'none' )
"call s:HL( 'Structure', '', '', 'none' )
"call s:HL( 'Typedef', '', '', 'none' )


" HTML:
"--------------------------------------------------------------------
call s:HL( 'htmlItalic', 'Rose', '', 'none' )
call s:HL( 'htmlArg', 'Mallow', '', 'none' )
"TODO
"call s:HL( 'htmlTagName', '', '', 'none' )
"call s:HL( 'htmlTag', '', '', 'none' )
"call s:HL( 'htmlEndTag', '', '', 'none' )
"call s:HL( 'htmlSpecialTagName', 'Mallow', '', 'none' )


" Diff:
"--------------------------------------------------------------------
call s:HL( 'DiffAdd', 'Twilight', 'Flats', 'none' )
call s:HL( 'DiffChange', 'Twilight', 'Heather', 'none' )
call s:HL( 'DiffDelete', 'Twilight', 'Firecracker', 'none' )
call s:HL( 'DiffText', 'Twilight', 'Heather', 'none' )


" Completion Menu:
"--------------------------------------------------------------------
call s:HL( 'Pmenu', 'Slate', 'Shadow', 'none' )
call s:HL( 'PmenuSel', 'Mallow', '', 'bold' )
call s:HL( 'PmenuSbar', '', 'Shadow', 'none' )
call s:HL( 'PmenuThumb', '', 'Graphite', '' )

" Spelling:
"--------------------------------------------------------------------
call s:HL( 'SpellBad', 'Firecracker', '', 'undercurl' )
"TODO
"call s:HL( 'SpellCap', '', '', '' )
"call s:HL( 'SpellLocal', '', '', '' )
"call s:HL( 'SpellRare', '', '', '' )

