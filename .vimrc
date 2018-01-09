""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Check For Different Dependencies.
" python_version = the version of python available, 205 means 2.5
" vim_verion         = the version of VIM running, 704 means 7.4
" running_tmux   = boolean value if this vim instance is running in tmux, 1 means yes.
"
" https://w.wol.ph/2015/02/17/checking-python-version-vim-version-vimrc/
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if has("python")
    python import vim; from sys import version_info as v; vim.command('let python_version=%d' % (v[0] * 100 + v[1]))
elseif has("python3")
    python3 import vim; from sys import version_info as v; vim.command('let python_version=%d' % (v[0] * 100 + v[1]))
else
    let python_version=0
endif

let vim_version=v:version

if exists('$TMUX')
    let running_tmux=1
else
    let running_tmux=0
endif

"let has_signs=
":echo has('signs')

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  Plug-ins and their settings.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin()

    " File browser
    Plug 'scrooloose/nerdtree'

    " Show git information in nerdtree
    Plug 'Xuyuanp/nerdtree-git-plugin'
    "       Note - we now have a checked-in copy of the nerdtree-git-plugin with my patches applied so it does not scroll bug.

    " Autocompletion
    let has_ycm=0
    if python_version >= 205
        if vim_version >= 704
            Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer' }
            let has_ycm=1
        endif
    endif

    " Better highlighting
    Plug 'octol/vim-cpp-enhanced-highlight'

    " Color Schemes
    Plug 'flazz/vim-colorschemes'

    " Side bar that shows tags
    Plug 'majutsushi/tagbar'

    " Shows git changes near the line number
    if vim_version >= 704
        Plug 'airblade/vim-gitgutter'
    endif

    " Shows line indentations
    if vim_version >= 703
        Plug 'Yggdroot/indentLine'
    endif

    " Debugger
    let has_conque=0
    if python_version >= 205
        if vim_version >= 703
            Plug 'vim-scripts/Conque-GDB'
                let has_conque=1
        endif
    endif

    " Fuzzy Searcher Suite
    let has_fzf_suite=0
    if vim_version >= 702
        Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
        Plug 'junegunn/fzf.vim'
        Plug 'tpope/vim-fugitive'
            let has_fzf_suite=1
    endif

    " A better way of 'marking' aka file bookmarks.
    Plug 'MattesGroeger/vim-bookmarks'

    " HIDDEN PLUGIN - there is a non-github plugin to show the nerdtree grep menu item, located in the 'after' folder.

call plug#end()

" Don't highlight any executables in NERDTree.
highlight link NERDTreeExecFile ModeMsg

" The program searches for the .ycm_extra_conf.py file on startup in the current source file directory and in its parent folders.
" If the file is not found, YCM features are not available. A global file (used as fallback when a local extra conf file is not found) may be set.
let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
let g:ycm_collect_identifiers_from_tags_files = 1
" cpp enhanced highlight
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_experimental_template_highlight = 1

" Settings for vim-bookmarks
let g:bookmark_auto_save = 1
let g:bookmark_save_per_working_dir = 1
let g:bookmark_manage_per_buffer = 1
let g:bookmark_center = 1

let g:NERDTreeDirArrows = 1
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let g:NERDTreeGlyphReadOnly = "RO"
let g:NERDTreeShowHidden = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" User setting
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"=============================================
" Filesystem and other Settings
"=============================================
" Enable filetype detection
filetype on
" Will keep hidden buffers open until user specifies
set hid
" If closing a buffer with unsaved changes, vim confirms
set confirm
" Sets how many lines of history VIM has to remember
set history=500
" Enable filetype plugins
filetype plugin on
filetype indent on
" Set to auto, read when a file is changed from the outside
set autoread
" ctags will look in current directory, then up to root, for the tags file.
set tags=./tags;/
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
" No .swp file
set noswapfile
" Use Unix as the standard file type
set ffs=unix,dos,mac
" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8
" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
if vim_version >= 703
    set wildignorecase
endif
if vim_version >= 704
    set fileignorecase
endif

"=============================================
" Searches/Autocomplete and highlighting
"=============================================
" Ignore case when searching
set ignorecase
" When searching try to be smart about cases
set smartcase
" Highlight search results
set hlsearch
" Makes search act like search in modern browsers
set incsearch
" For regular expressions turn magic on
set magic
" This will differentiate between searched-text and text under the cursor.
hi Search ctermbg=DarkGreen
hi Search ctermfg=LightYellow
" This is the command auto-completion bar that appears
set wildmenu
" Autocomplete menu color seting
highlight Pmenu ctermbg=52 ctermfg=lightyellow

" Make ENTER accept a YouCompleteMe suggestion, but also work reguarly everywhere else.
" I also slightly modified the code from the website below to actually work on my vim setup.
"https://github.com/Valloric/YouCompleteMe/issues/232
imap <expr> <CR> pumvisible() ? "<c-y>" : "<CR>"

" Auto highlight every word under the mouse curser.
" http://stackoverflow.com/questions/1551231/highlight-variable-under-cursor-in-vim-like-in-netbeans
" To see all highlight colors available, run the following :so $VIMRUNTIME/syntax/hitest.vim
autocmd CursorHold * exe printf('match IncSearch /\V\<%s\>/', escape(expand('<cword>'), '/\'))

" This underlines the entire current line that the cursor is on, but only in Normal mode.
" http://vim.wikia.com/wiki/Highlight_current_line
" https://stackoverflow.com/questions/6488683/how-do-i-change-the-vim-cursor-in-insert-normal-mode
set cul
autocmd InsertEnter,InsertLeave * set cul!

"=============================================
"  Colors and Fonts
"=============================================
" Getting the most colors available.  Drop back to 'xterm' if you have issues.
if running_tmux >= 1
    set term=screen-256color
    "set term=xterm-256color
else
    set term=xterm-256color
endif

" https://github.com/flazz/vim-colorschemes/tree/master/colors
colorscheme despacio

" Disable Background Color Erase'
" Using this to get VIM non-black backgrounds to work in tmux properly.
if running_tmux >= 1
    set t_ut=
endif

"=============================================
" Text, tab and indent related
"=============================================
" Use spaces instead of tabs
set expandtab
" Be smart when using tabs
set smarttab
" 4 spaces per tab
set shiftwidth=4
set tabstop=4
" Auto indent
set ai
" Smart indent
set si 
" do c-style indenting
set cindent
set cinoptions=g-1
" Shows tabs when using tab indentation.
" Note: Do not remove the space at the end of the command
set list lcs=tab:\|\ 

"=============================================
" Line related 
"=============================================
" Linebreak on 500 characters
set lbr
set tw=500
" No line wrapping
set nowrap
" Configure backspace so it acts as it should act
set backspace=eol,start,indent
" Wraps left and right key movements
set whichwrap+=<,>,h,l,[,],
" Line number on the side
set number
" Number of lines cursor moves before scrolling
set so=1

"=============================================
" Status line
"=============================================
" Always show the status line
set laststatus=2
" Height of the command bar
set cmdheight=1
" show the to-be-completed command in the status line.
set showcmd
" Some setting haven't looked into
set statusline=%<%f\ %h%m%r%y%=%-20.(%l/%L,%c%V%)\ %P

"=============================================
" Copy/Paste 
"=============================================
" Use linux system clipboard instead of VIMs
" https://stackoverflow.com/questions/3961859/how-to-copy-to-clipboard-invim
set clipboard=unnamedplus

" Automatically paste from the system clipboard
" no more needing to ":set paste" before you paste:
" https://coderwall.com/p/if9mda/automatically-set-paste-mode-in-vim-when-pasting-in-insert-mode
function! WrapForTmux(s)
  if !exists('$TMUX')
    return a:s
  endif
  let tmux_start = "\<Esc>Ptmux;"
  let tmux_end = "\<Esc>\\"
  return tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tmux_end
endfunction
let &t_SI .= WrapForTmux("\<Esc>[?2004h")
let &t_EI .= WrapForTmux("\<Esc>[?2004l")
function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction
inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()


"=============================================
" Misc Settings
"=============================================
" How long the CursorHold autocmd will wait before running.
set updatetime=50
" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500
" Have mouse input
set mouse=a

"Needed for SOME versions of tmux and vim to play nicely with mouse events.
" :help ttymouse
set ttymouse=xterm2

" Dont have that stupid preview 'scratch' window thing
set completeopt-=preview


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Custom Commands
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" --- :Blame ---
" Opens a new window and has the git blame info for the current file,
" starting at the current line.  Use if GBlame from FZF is not available.
if has_fzf_suite == 0
    command! -nargs=* Gblame call s:GitBlame()
endif

" --- :FunctionName ---
command! -nargs=* FunctionName call ShowFunctionName()

" --- :Buffers ---
" Use this if the fzf Buffers command is not available.
if has_fzf_suite == 0
    command! Buffers call setqflist(map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), '{"bufnr":v:val}')) | copen | execute ':redraw!'
endif

" --- Grep Commands ---
" opens search results in a window w/ links and highlight the matches, for the word under the cursor
command! -nargs=+ GrepC :execute  'silent grep -Rin --include=\*.{c,cc,cpp,cxx,h,hpp,hxx} . -e <args>' | copen | execute ':redraw!'
command! -nargs=+ FindC :execute  'silent grep -Rinl --include=\*.{c,cc,cpp,cxx,h,hpp,hxx} . -e <args>' | copen | execute ':redraw!'
command! -nargs=+ Grep  :execute  'silent grep -RIin . -e <args>' | copen | execute ':redraw!'
command! -nargs=+ Find  :execute  'silent grep -RIinl . -e <args>' | copen | execute ':redraw!'

" --- :VReplace ---
" WIP
"command! -nargs=* VReplace :"hy:%s/<C-r>h//gc<left><left><left>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Custom Key Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" --- SpaceBar ---
" Search though all commands available to you.  Very handy!
if has_fzf_suite > 0
    map <space> :Commands<CR>
endif

" --- F2 ---
" toggle and untogle Nerdtree
autocmd VimEnter * nmap <F2> :NERDTreeToggle<CR>
autocmd VimEnter * imap <F2> <Esc>:NERDTreeToggle<CR>a
" --- F3 ---
" Toggles tagbar
nmap        <F3>        :TagbarToggle<CR>
" --- F4 ---
" Shows the change history
nmap        <F4>        :Gblame<CR>

" --- F5 ---
"if has_fzf_suite > 0
"    map <F5> :GFiles?<CR>
"endif

" --- F9 ---
" clang-format, for file formatting auto-correction.
map         <F9>        :pyf ~/bin/clang-format.py<cr>
imap        <F9>        <c-o>:pyf ~/bin/clang-format.py<cr>

" --- F12 ---
" will regenerate a tag file.
map         <F12>       :!find . -type f -name '*.cpp' -o -name '*.c' 
                                                      \-o -name '*.cxx' 
                                                      \-o -name '*.h' 
                                                      \-o -name '*.hpp' 
                                                      \-o -name '*.hxx' 
                                                      \-o -name '*.cc' 
                                                      \-o -name '*.py' 
                                                      \-o -name '*.sh' 
                                                      \\| ctags -L - 
                                                      \--c++-kinds=+p 
                                                      \--fields=+liaS 
                                                      \--extra=+q<CR><CR>

" --- :W ---
" will SUDO save the file
command W w !sudo tee % > /dev/null

" --- Ctrl-f ---
" Show function name below status bar.  See function for more details.
map         <C-f>       :call ShowFunctionName() <CR>

" --- Ctrl-s ---
" Substitution in command mode
nmap        <C-s>       :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>
" In visual mode, highlighted word is selected for replacement
vnoremap    <C-s>       "hy:%s/<C-r>h//gc<Left><Left><Left>

" --- Ctrl-p ---
" YouCompleteMe jumping function
if has_ycm > 0
    nnoremap <C-p>      :YcmCompleter GoToDefinitionElseDeclaration<CR>
endif

" --- Ctrl-p-p ---
" CTags, using ctags generated with f12.
map         <C-p><C-p> <c-]>

" --- Ctrl-p-p-p ---
" Custom GREP search results, Third level of Ctrl-p-p-p.
nmap        <C-p><C-p><C-p> :GrepC <c-r>=expand("<cword>")<cr><cr>

"=============================================
" Misc keys
"=============================================
" Remap VIM 0 to first non-blank character in a line.
map         0           ^
map         -           $

" delete remapped to df
nmap        df          <Del>
" Stop delete from putting the deleted text into the clipboard
nnoremap    d           "_d
nnoremap    <Del>       "_d<Right>
" Alternatives to Escape
imap        jj          <Esc>
vmap        jj          <Esc>
imap        ;;          <Esc>
vmap        ;;          <Esc>
"=============================================
" Braces
"=============================================
" autocompletes braces
inoremap    {           {}<Left>
inoremap    {<CR>       {<CR>}<Esc>
inoremap    {{          {
inoremap    {}          {}

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

"=============================================
"  Pane/Tab Navigation
"=============================================
"Horizontal splits to the bottom
set splitbelow
" Vertical splits to the right
set splitright

" Move around using Ctrl-hjkl
nnoremap    <C-j>       <C-w>j
nnoremap    <C-k>       <C-w>k
nnoremap    <C-h>       <C-w>h
nnoremap    <C-l>       <C-w>l
" Create and delete tabs
nnoremap    <C-t>       :tabnew<CR>
nnoremap    <C-e>       :confirm bdelete<CR>

" Switch tabs
nnoremap    L           gt
nnoremap    H           gT

" Maps to nothing
nnoremap    K           <Nop>
nnoremap    J           <Nop>
vnoremap    K           <Nop>
vnoremap    J           <Nop>

" Jumps to git changes
nmap        <silent> <leader>jt        <Plug>GitGutterNextHunk
nmap        <silent> <leader>jT        <Plug>GitGutterPrevHunk

"=============================================
" Braces
"=============================================
" Toggles highlighting for trailing whitespaces
highlight ExtraWhitespace ctermbg=lightred guibg=lightred
nnoremap <silent> <leader>tw
    \ :if exists('w:trailing_whitespace_match') <Bar>
    \   silent! call matchdelete(w:trailing_whitespace_match) <Bar>
    \   unlet w:trailing_whitespace_match <Bar>
    \   echo "Whitespace Highlighting: off" <Bar>
    \ else <Bar>
    \   let w:trailing_whitespace_match = matchadd('ExtraWhitespace', '\s\+\%#\@<!$', -1) <Bar>
    \   echo "Whitespace Highlighting: on" <Bar>
    \ endif<CR>

" Deletes trailing whitespace in current line
nnoremap <silent> <leader>ds :s/\s\+$//ge<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Multi-Use Functions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Show the current function you are in right below the status bar
fun! ShowFunctionName()
    echohl ModeMsg
    call GetFuncName()
    echo  getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bWn'))
    echohl None
endfun

"======================================================
" Function runs git blame on file in current buffer and
" puts output into a new window
" move to current line in git output
" (can't edit output)
" https://stackoverflow.com/questions/33051496/custom-script-for-git-blame-from-vim
"======================================================
function! s:GitBlame()
   let cmdline = "git blame -w " . bufname("%")
   let nline = line(".") + 1
   botright new
   setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
   execute "$read !" . cmdline
   setlocal nomodifiable
   execute "normal " . nline . "gg"
   execute "set filetype=cpp"
endfunction

"======================================================
" http://vim.wikia.com/wiki/Prevent_frequent_commands_from_slowing_things_down
" Returns true if at least delay seconds have elapsed since the last time this function was called, based on the time
" contained in the variable "timer". The first time it is called, the variable is defined and the function returns
" true.
" For example, to execute something no more than once every two seconds using a variable named "b:myTimer", do this:
" if LongEnough( "b:myTimer", 2 )
"   <do the thing>
" endif
" The optional 3rd parameter is the number of times to suppress the operation within the specified time and then let it
" happen even though the required delay hasn't happened. For example:
" if LongEnough( "b:myTimer", 2, 5 )
"   <do the thing>
" endif
" Means to execute either every 2 seconds or every 5 calls, whichever happens first.
"======================================================
function! LongEnough( timer, delay, ... )
    let result = 0
    let suppressionCount = 0
    if ( exists( 'a:1' ) )
        let suppressionCount = a:1
    endif
    " This is the first time we're being called.
    if ( !exists( a:timer ) )
        let result = 1
    else
        let timeElapsed = localtime() - {a:timer}
        " If it's been a while...
        if ( timeElapsed >= a:delay )
            let result = 1
        elseif ( suppressionCount > 0 )
            let {a:timer}_callCount += 1
            " It hasn't been a while, but the number of times we have been called has hit the suppression limit, so we activate
            " anyway.
            if ( {a:timer}_callCount >= suppressionCount )
                let result = 1
            endif
        endif
    endif
    " Reset both the timer and the number of times we've been called since the last update.
    if ( result )
        let {a:timer} = localtime()
        let {a:timer}_callCount = 0
    endif
    return result
endfunction
