
set showcmd
set nohlsearch
set incsearch

" {{{ File management

set noswapfile
" augroup AutoSaveFolds
"   autocmd!
"   autocmd BufWinLeave * mkview
"   autocmd BufWinEnter * silent loadview
" augroup END

" }}}


let mapleader="\<Space>"
map <leader>so :source $MYVIMRC<cr>
inoremap jk <Esc>
inoremap kj <Esc>
nnoremap <leader>s :source $MYVIMRC<cr>

" the default Y command behaves like yy, yanking the entire line. this change
" makes it consistent with C and D, though I may change those too, as it seems
" like a waste of a mapping
nnoremap Y y$

" {{{ Split/Buffer management

set hidden

" navigate splits or create splits
noremap <c-h> <c-w><left>
noremap <c-j> <c-w><down>
noremap <c-k> <c-w><up>
noremap <c-l> <c-w><right>
nnoremap <leader>- <c-w>s
nnoremap <leader><bar> <c-w>v

" }}}

set showmatch                   " show matching parens
set formatoptions+=o            " continue comment marker in new line



" {{{ Terminal settings

" 2 bugs with terminals
" 2) dont return to absolute line numbers when replacing term with file

autocmd TermOpen * set nonumber norelativenumber
autocmd BufNew * if &buftype != 'terminal' | :set number | endif
tnoremap jk <c-\><c-n>
tnoremap kj <c-\><c-n>
tnoremap <c-h> <c-\><c-n><c-w><left>
tnoremap <c-j> <c-\><c-n><c-w><down>
tnoremap <c-k> <c-\><c-n><c-w><up>
tnoremap <c-l> <c-\><c-n><c-w><right>
tnoremap <c-space>- <c-w>s
tnoremap <c-space><bar> <c-w>v

" this should also work upon starting a new terminal
autocmd BufEnter,WinEnter,TermOpen * if &buftype == 'terminal' | :startinsert | endif
" }}}

" {{{ Line numbering
" These are options which change the numbering of lines, such as showing the
" line/column numbers in the bottom right, changing between absolute/relative
" line numbering, or showing the line 80 column
set number
set ruler
set colorcolumn=81

" Sets hybrid numbers when in insert mode and absolute numbers when out
" https://jeffkreeftmeijer.com/vim-number/
set number relativenumber
augroup NumberToggle
    autocmd!
    autocmd InsertLeave * set norelativenumber
    autocmd InsertEnter * set relativenumber
    autocmd BufWinEnter * if &buftype != 'terminal' | set number | endif
augroup END

" autocmd WinEnter,InsertLeave * set cursorline cursorcolumn
" autocmd WinLeave,InsertEnter * set nocursorline nocursorcolumn
"
nnoremap <leader><leader> :set cursorline!<cr>
                         \:set cursorcolumn!<cr>
                         \:sleep 1<cr>
                         \:set cursorline!<cr>
                         \:set cursorcolumn!<cr>
hi CursorLine cterm=NONE ctermbg=7 guibg=Grey90

" set updatetime=5000
" autocmd CursorHold,CursorHoldI * 


" }}}

" {{{ Whitespace handling
set expandtab tabstop=4 shiftwidth=4 softtabstop=4
"
" http://nerditya.com/code/guide-to-neovim/

" highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
" match ExtraWhitespace /\s\+$\|\t/

" show extra whitespace with different character
set list
set listchars=
set listchars+=tab:--
set listchars+=trail:⋅
set listchars+=extends:»
set listchars+=precedes:«

" }}}

set foldmethod=marker

" splits show up to the right/below the current pane
set splitright
set splitbelow


