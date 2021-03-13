" ln -s $HOME/gits/dotfiles/src/nvim/main.vim ~/.config/nvim/init.vim
" ln -s 
 
" TODO
" choose between having a line number bg color distinct from the file
" contents, or having a fold bg color the same as the file contents. this is
" an issue because the fold bg color extends into its line number, so they
" have to be the same to avoid clashing

" {{{ PLUGINS/VIM-PLUG BOILERPLATE

" There was an issue with the boilerplate as provided by the vim-plug README,
" but changing the filepaths to use .config/nvim rather than /.local/...
" fixed it.
"
" This link seems to go over some of the same issues
" https://github.com/junegunn/vim-plug/issues/245
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
   \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.local/share/nvim/plugged')
" }}}
" {{{ PLUGINS/VISUAL
" Plug 'junegunn/goyo.vim'
" Plug 'junegunn/limelight.vim'
" Plug 'blueyed/vim-diminactive'
Plug 'tyru/eskk.vim'
Plug 'chrisbra/unicode.vim'
Plug 'morhetz/gruvbox'
Plug 'romainl/Apprentice'
Plug 'junegunn/seoul256.vim'
Plug 'joshdick/onedark.vim'
Plug 'NLKNguyen/papercolor-theme'
Plug 'nanotech/jellybeans.vim'
Plug 'kristijanhusak/vim-hybrid-material'
Plug 'jdkanani/vim-material-theme'
Plug 'zeis/vim-kolor'
Plug 'gosukiwi/vim-atom-dark'
Plug 'reedes/vim-colors-pencil'
Plug 'cocopon/iceberg.vim'
Plug 'jonathanfilip/vim-lucius'
" Plug 'base16-papercolor-dark-syntax'
" }}}
" {{{ PLUGINS/STATUSBAR
"Plug itchyny/lightline.vim
Plug 'vim-airline/vim-airline'
" }}}
" {{{ PLUGINS/BEST-IN-CLASS
" These are plugins which I think should be the default behaviour for Vim
" itself.
Plug 'moll/vim-bbye'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-unimpaired'
Plug 'justinmk/vim-sneak'
" }}}
" {{{ PLUGINS/EXPENSIVE PLUGINS
Plug 'christoomey/vim-tmux-navigator'
Plug 'junegunn/vim-peekaboo'
Plug 'Shougo/deoplete.nvim'
Plug 'Shougo/denite.nvim'
Plug 'tpope/vim-fugitive'
Plug 'sjl/gundo.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" }}}
" {{{ PLUGINS/FILE BROWSER
" Choices I've looked at are dirvish, netrw/vinegar, vimfiler, and NERDTree
Plug 'tpope/vim-vinegar'
Plug 'justinmk/vim-dirvish'
" }}}
" {{{ PLUGINS/LANGUAGE SPECIFIC
Plug 'dag/vim-fish'
Plug 'donRaphaco/neotex', { 'for': 'tex' }
Plug 'ndmitchell/ghcid', { 'rtp': 'plugins/nvim' }
Plug 'Twinside/vim-haskellFold'
" }}}
" {{{ PLUGINS/COMPILER
Plug 'w0rp/ale'
call plug#end()
" }}}
" {{{ PLUGINS/AUTO-INSTALL
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif
" }}}
" {{{ SETTINGS/DIGRAPHS
" in insert mode hit <c-k>code, where code is the 2-digit digraph code
" to enter by numerical value in insert mode
" <c-q>
"   nnn       where nnn in [000,255]
"   0nnn      where nnn in [000,377]
"   Xnn       where nn in [00,FF]
"   unnnn     where nnnn in [0000,FFFF]
"   unnnnnnnn where nnnnnnnn in [000000000,FFFFFFFF]
"
digraphs SM 8726

" }}}
" {{{ SETTINGS/KEYMAPS

map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

nnoremap <leader>} :lnext<cr>
nnoremap <leader>{ :lprev<cr>

let mapleader="\<Space>"
let maplocalleader="\\"
noremap j gj
noremap k gk
inoremap jk <Esc>
inoremap kj <Esc>
nnoremap ; :
command! W w !sudo tee "%" > /dev/null
command! Reset :source $MYVIMRC
" the default Y command behaves like yy, yanking the entire line. this change
" makes it consistent with C and D, though I may change those too, as it
" seems
" like a waste of a mapping
nnoremap Y y$

" plugin-specific bindings
nnoremap <leader>c :BCommits<cr>
nnoremap <leader>b :Buffers<cr>
nnoremap <leader>f :GFiles<cr>
nnoremap <leader>F :Files<cr>
nnoremap <leader>H :Helptags<cr>
nnoremap <leader>: :Commands<cr>
nnoremap <leader>M :Maps<cr>
nnoremap <leader>e :Dirvish<cr>
nnoremap <leader>u :GundoToggle<cr>

" navigate splits or create splits
let g:tmux_navigator_disable_when_zoomed = 1
noremap <silent> <c-h> :TmuxNavigateLeft<cr>
noremap <silent> <c-j> :TmuxNavigateDown<cr>
noremap <silent> <c-k> :TmuxNavigateUp<cr>
noremap <silent> <c-l> :TmuxNavigateRight<cr>
nnoremap <leader>- <c-w>s
nnoremap <leader><bslash> <c-w>v

" augroup NonWriteableQuitOnQ
"     autocmd!
"     autocmd BufWinEnter,BufEnter,WinEnter *
"         \ if &l:buftype ==# 'help' |
"         \ noremap <buffer> q :q<cr> |
"         \ elseif %l:buftype ==# 'netrw' |
"         \ noremap <buffer> q :Rexplore<cr> |
"         \ endif
" augroup END

set helpheight=0
" function! OpenHelpInCurrentWindow(topic) 
"     view $VIMRUNTIME/doc/help.txt 
"     setl filetype=help 
"     setl buftype=help 
"     setl nomodifiable 
"     exe 'keepjumps help ' . a:topic 
" endfunction 
" command! -nargs=? -complete=help Help call OpenHelpInCurrentWindow(<q-args>)
" }}}
" {{{ SETTINGS/OPTIONS

" statusbar
set noshowmode
" set path+=,$HOME/gits/dotfiles/src/nvim/,
set autoread
set showcmd
set nohlsearch
set incsearch
set showmatch                   " show matching parens
set formatoptions+=o            " continue comment marker in new line
set formatoptions-=t            " dont wrap text
set formatoptions+=c            " wrap comments
set textwidth=80                " wrap at 80 characters
" set formatoptions+=a
set fillchars+=vert:│,stlnc:-

" splits/buffers
set hidden
set splitright
set splitbelow
" }}}
" {{{ SETTINGS/SCRIPTS

" let &colorcolumn="80".join(range(81,999),",")
" augroup ColorColumnWhenWritable
"     autocmd!
"     autocmd BufEnter,BufWinEnter *
"         \ if !&modifiable |
"         \ setlocal colorcolumn=0 |
"         \ endif
" augroup END }}}
" {{{ SETTINGS/TERMINAL

augroup TerminalBehaviour
    autocmd!
    autocmd BufNew * if &buftype != 'terminal' | :set number | endif
    autocmd BufEnter,WinEnter,TermOpen * if &buftype == 'terminal' | :startinsert | endif
    autocmd TermOpen * set nonumber norelativenumber
augroup END

tnoremap jk <c-\><c-n>
tnoremap kj <c-\><c-n>
tnoremap <c-h> <c-\><c-n><c-w><left>
tnoremap <c-j> <c-\><c-n><c-w><down>
tnoremap <c-k> <c-\><c-n><c-w><up>
tnoremap <c-l> <c-\><c-n><c-w><right>
tnoremap <c-space>- <c-w>s
tnoremap <c-space><bar> <c-w>v

" this should also work upon starting a new terminal
" }}}
" {{{ SETTINGS/WHITESPACE, LINES AND COLUMNS, 
set expandtab tabstop=4 shiftwidth=4 softtabstop=4
set number ruler

" http://nerditya.com/code/guide-to-neovim/

" show extra whitespace with different character
set listchars=
set listchars+=tab:│\ ,nbsp:␣
set listchars+=trail:⋅
" set listchars+=extends:»
" set listchars+=precedes:«
" set listchars+=eol:¶ " ¶↵ ↩ ↵ ↲    ↵  

" These are options which change the numbering of lines, such as showing the
" line/column numbers in the bottom right, changing between absolute/relative
" line numbering, or showing the line 80 column
" Sets hybrid numbers when in insert mode and absolute numbers when out
" https://jeffkreeftmeijer.com/vim-number/
set number
augroup NumberToggle
    autocmd!
    autocmd InsertLeave * set norelativenumber
    autocmd InsertEnter * set relativenumber
    autocmd BufWinEnter * if &buftype != 'terminal' | set number | endif
augroup END

nnoremap <leader><leader> :set cursorline!<cr>
                         \:set cursorcolumn!<cr>
                         \:sleep 1<cr>
                         \:set cursorline!<cr>
                         \:set cursorcolumn!<cr>





" }}}
" {{{ SETTINGS/FOLDS
set foldmethod=marker
autocmd FileType gitcommit set foldmethod=syntax
" set foldtext=MyFoldText()
" function MyFoldText()
"     let line = getline(v:foldstart)
"     let sub = substitute(line, "^.* {{" . "{ ", "", 'g')
"     return v:folddashes . v:folddashes . v:folddashes . sub
" endfunction
" }}}
" {{{ SETTINGS/PLUGIN OPTIONS

" tree view
let g:netrw_listtyle=3

" open FZF current window rather than split
let g:fzf_layout = { 'window' : 'enew' }
" let g:airline_focuslost_inactive = 1
" let g:airline_inactive_collapse = 1

" }}}
" {{{ SETTINGS/PERSISTENCE (FOLDS AND .SWP FILE)
set noswapfile
" augroup AutoSaveFolds
"   autocmd!
"   autocmd BufWinLeave * mkview
"   autocmd BufWinEnter * silent loadview
" augroup END
" }}}
" {{{ SETTINGS/THEMES

" only the active pane:
"   shows whitespace characters
augroup PaneChanged
    autocmd!
    autocmd BufEnter,BufWinEnter,WinEnter,FocusGained *
        \ if &modifiable |
        \ setlocal list |
        \ endif
    autocmd BufLeave,BufWinLeave,WinLeave,FocusLost *
        \ setlocal nolist |
augroup END

" i prefer the highlight approach to coloring long lines compared to color
" column, but it doesn't seem to work with conceals, coloring based on the
" actual text of the buffer rather than the post-concealed buffer. adjusting
" the regex might fix this.
"
" highlight Bang ctermfg=red guifg=red cterm=underline gui=underline
" match Bang /\%>79v.*.\%<255v/
set colorcolumn=81

" hi StatusLineNC

" this is some haskell stuff
" set conceallevel=2
" syntax match QualifiedName /\S*\./ conceal
" highlight FullQualifiedName ctermfg=red term=underline
" match FullQualifiedName /\S*\.\S*/

highlight NormalNC ctermbg=236
highlight EndOfBuffer ctermbg=NONE
highlight LineNr ctermfg=60 ctermbg=NONE
highlight CursorLineNr ctermfg=60 ctermbg=NONE

highlight Comment ctermfg=DarkGrey
highlight NonText ctermbg=None ctermfg=60
" this is used by vim-diminactive to dim the inactive pane
highlight Normal guifg=NONE guibg=NONE
highlight Folded ctermfg=60 ctermbg=NONE guibg=NONE
highlight CursorLine cterm=NONE ctermbg=7 guibg=Grey90
" highlights lines greater than 80 lines. the regex ignores the last
" character, which vim adds

" mark colors past 79 in red

" }}}



function! IndentLevel(lnum)
    return indent(a:lnum) / 2
endfunction
function! HaskellFold(lnum)
    if getline(a:lnum) =~? '\v^\s*where\s*$'
        " a line consisting only of 'where' starts a fold
        return '>' . (IndentLevel(a:lnum) + 1)
    elseif getline(a:lnum) =~? '\v^\s*-- \|.*$'
        " a line starting with a doc comment starts a fold
        return '>' . (IndentLevel(a:lnum) + 1)
    else
        return '='

    if getline(a:lnum - 1) =~? ""
        let line = getline(a:lnum)
        let z = a:lnum
        " lookahead to the first non-comment in an equally indented block
        while (getline(l:z) =~? '\v^\s*--.*$') && (IndentLevel(z) == IndentLevel(a:lnum))
            z = z + 1
        endwhile
        " If the line starts with 'ident ::' start a fold
        if getline(l:z) =~? "^\\s*[A-Za-z0-9_']\\+\\s\\+::.*$"
            return '>' . (IndentLevel(a:lnum) + 1)
        endif
        " if the line contains only 'ident' and the next line starts with '::'
        " start a fold
        if (getline(l:z) =~? "^\\s*[A-Za-z0-0_']\\+\\s*$") && (getline(l:z + 1) =~? '^\s*::.*$')
            return '>' . (IndentLevel(a:lnum) + 1)
        endif
        return '='
    else
        return '='

    "
    " if 
    " let line = getline(a:lnum)
    " let starstring = substitute(line, '-- \(\*\+\) .*', '\1', '')
    " if line == ''
    "     return '-1'
    " elseif line == starstring
    "     return '='
    " else
    "     return '>' . len(starstring)
    " endif
endfunction
function! s:haskell()
    " stops vim from using error highlighting on lines which begin with #
    hi link cError NONE

    let g:ale_enabled=0
    " setlocal foldmethod=expr
    " setlocal foldexpr=HaskellFold(v:lnum)

    set nowrap
    " matches the qualifier part of a concealed variable
    "syntax match Qualified /`\?\([A-Z][A-Za-z0-9]*\.\)\+\([A-Za-z0-9_']\+\|[:|-~!@#$%^&*\-+=\\<>\.?/]\+\)`\?/ contains=Qualifier,hsBackTick,hsQualifiedName
    "syntax match Qualifier /\([A-Z][A-Za-z0-9]*\.\)\+/ conceal contained
    "syntax match hsQualifiedName /\([A-Za-z0-9_']\+`\)\|\([:|-~!@#$%^&*\-+=\\<>\.?/]\+\)`/ contained

    "" this hides the 'do' when using explicit layout, where the brace begins
    "" immediately after 1 space after the do, as in 'do { x <- m ; x }'
    "" this is /slightly/ nice when writing a do block in one line, where you can
    "" use it like rust block syntax
    syntax match hsInlineDo /do {/ contains=hsInlineDo2
    syntax match hsInlineDo2 /do / conceal contained

    """ QUALIFICATION/INFIX CONCEALS
    " this section achieves teh following
    "
    " 1. qualifiers are hidden
    " 2. infix operators are colored yellow
    " 3. the identifier part of a qualified name is underlined
    "
    " due to the way these conditions overlap and my limited knowledge of vim
    " conceals/syntax highlighting, i haven't been able to get these conditions
    " in an elegent way, so this code feels needlessly complicated

    " this prevents import/module declarations from being hidden
    syntax match hsModuleLine /^module.*/ contains=hsModuleKeyword
    syntax match hsModuleKeyword /^module / contained
    highlight hsModuleKeyword ctermfg=2 guifg=SeaGreen gui=bold
    " any identifier, qualified or not, which is wrapped in a backtick is found
    syntax match hsBackTick /`\([A-Z][A-Za-z0-9]*\.\)*\([A-Za-z0-9_']\+\)`/ contains=hsTick,hsBackTickQualified
    " the backtick is hidden
    syntax match hsTick /`/ contained conceal
    " if it is qualified, hide the qualifier, and color/underline the region
    syntax match hsBackTickQualified /\([A-Z][A-Za-z0-9]*\.\)\+\([A-Za-z0-9_']\+\)/ contains=hsBackTickQualifier contained
    syntax match hsBackTickQualifier /\([A-Z][A-Za-z0-9]*\.\)\+/ conceal contained
    " this needs to be kept in sync with operator. i couldn't find a way to
    " link to operator + add undercurl
    highlight hsBackTickQualified ctermfg=11 guifg=#ffff60
    " if it's not qualified we can just color the region
    highlight! link hsBackTick Operator
    " if a region has a qualified infix operator hide/color/underline it
    syntax match hsQualifiedOp /\([A-Z][A-Za-z0-9]*\.\)\+[:|-~!@#$%^&*\-+=\\<>\.?/]\+/ contains=hsQualifierOp
    syntax match hsQualifierOp /\([A-Z][A-Za-z0-9]*\.\)\+/ conceal contained
    highlight! link hsQualifiedOp hsBackTickQualified
    " if a region has a qualified identifier hide and underline it
    syntax match hsQualifiedName /\([A-Z][A-Za-z0-9]*\.\)\+\([A-Za-z0-9_']\+\)/ contains=hsQualifierName
    syntax match hsQualifierName /\([A-Z][A-Za-z0-9]*\.\)\+/ conceal contained
    highlight hsQualifiedName
    """ END QUALIFICATION/INFIX CONCEALS

    " hide labels
    syntax match hsLabel /#\([A-Za-z0-9]\+\)/ contains=hsLabelName,hsLabelHash
    syntax match hsLabelName /\([A-Za-z0-0]\+\)/ contained
    syntax match hsLabelHash /#/ contained conceal
    highlight! hsLabelName ctermfg=74

    " replace coneals with their conceal character (or hide them entirely when
    " not defined), even for the current line in normal mode
    setlocal conceallevel=2
    setlocal concealcursor=
endfun
augroup haskell_group
    autocmd!
    autocmd Syntax haskell call s:haskell()
augroup END

function! s:syrup()
    syntax match tickedVariable /'\([A-Za-z0-9_]\)\+/ contains=tick
    syntax match tick /'/ conceal contained
    highlight! tickedVariable cterm=italic gui=italic
    setlocal concealcursor=n
endfunction

au BufRead,BufNewFile *.srp set filetype=syrup
au! Syntax syrup source ~/Home/gits/dotfiles/src/nvim/plugins/syrup.vim

