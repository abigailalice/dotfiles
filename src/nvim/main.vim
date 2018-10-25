
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
" {{{ PLUGINS/THEMES

" }}}
" {{{ PLUGINS/VISUAL
" Plug 'junegunn/limelight.vim'
Plug 'blueyed/vim-diminactive'
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
Plug 'moria/dark'


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
" }}}
" {{{ PLUGINS/LANGUAGE SPECIFIC
Plug 'dag/vim-fish'
Plug 'donRaphaco/neotex', { 'for': 'tex' }
call plug#end()
" }}}
" {{{ PLUGINS/COMPILER
Plug 'w0rp/ale'
" }}}

" {{{ SETTINGS/KEYMAPS

let mapleader="\<Space>"
let maplocalleader="\\"
inoremap jk <Esc>
inoremap kj <Esc>
nnoremap ; :
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
nnoremap <leader>e :Explore<cr>
nnoremap <leader>u :GundoToggle<cr>

" navigate splits or create splits
let g:tmux_navigator_disable_when_zoomed = 1
noremap <silent> <c-h> :TmuxNavigateLeft<cr>
noremap <silent> <c-j> :TmuxNavigateDown<cr>
noremap <silent> <c-k> :TmuxNavigateUp<cr>
noremap <silent> <c-l> :TmuxNavigateRight<cr>
nnoremap <leader>- <c-w>s
nnoremap <leader><bar> <c-w>v

" augroup NonWriteableQuitOnQ
"     autocmd!
"     autocmd BufWinEnter,BufEnter * |
"         \ if &l:buftype ==# 'help' || &l:filetype ==# 'netrw' |
"         \ noremap <buffer> q :Bd<cr> |
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
set path+=,$HOME/gits/dotfiles/src/nvim/,
set showcmd
set nohlsearch
set incsearch
set showmatch                   " show matching parens
set formatoptions+=o            " continue comment marker in new line
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

" highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
" match ExtraWhitespace /\s\+$\|\t/

" show extra whitespace with different character
set list
set listchars=
set listchars+=tab:│\ ,nbsp:␣
set listchars+=trail:⋅
set listchars+=extends:»
set listchars+=precedes:«
set listchars+=eol:¶ " ¶↵ ↩ ↵ ↲    ↵  

" These are options which change the numbering of lines, such as showing the
" line/column numbers in the bottom right, changing between absolute/relative
" line numbering, or showing the line 80 column
" Sets hybrid numbers when in insert mode and absolute numbers when out
" https://jeffkreeftmeijer.com/vim-number/
set number relativenumber
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

" augroup ChangeSplit
"     autocmd!
"     autocmd WinLeave,BufLeave,BufWinLeave *
"         \ highlight Folded ctermbg=236 |
"         \ highlight LineNr ctermbg=236 |
"         \ highlight CursorLineNr ctermbg=236
"     autocmd WinEnter,BufEnter,BufWinEnter *
"         \ highlight Folded ctermbg=NONE |
"         \ highlight LineNr ctermbg=NONE |
"         \ highlight CursorLineNR ctermbg=NONE
" augroup END

highlight Comment ctermfg=DarkGrey

highlight NonText ctermbg=236
" this is used by vim-diminactive to dim the inactive pane
highlight ColorColumn ctermfg=248 guifg=248 ctermbg=236 guibg=236
highlight Normal guifg=NONE guibg=NONE
highlight Folded ctermfg=60 ctermbg=NONE guibg=NONE
highlight LineNr ctermfg=60 guibg=236 ctermbg=NONE
highlight FoldColumn guifg=grey guibg=236 ctermbg=236
highlight SignColumn guibg=236
highlight CursorLine cterm=NONE ctermbg=7 guibg=Grey90
highlight CursorLineNr guifg=grey guibg=236 ctermfg=60 ctermbg=NONE
" highlights lines greater than 80 lines. the regex ignores the last
" character, which vim adds
highlight Bang ctermfg=red guifg=red cterm=underline gui=underline
match Bang /\%>79v.*.\%<255v/
" }}}
