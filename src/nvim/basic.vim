
let mapleader="\<Space>"
inoremap jk <Esc>
inoremap kj <Esc>
nnoremap <leader>s :source $MYVIMRC<cr>

" navigate splits or create splits
noremap <c-h> <c-w><left>
noremap <c-j> <c-w><down>
noremap <c-k> <c-w><up>
noremap <c-l> <c-w><right>
nnoremap <leader>- <c-w>s
nnoremap <leader><bar> <c-w>v

set showmatch                   " show matching parens
set formatoptions+=o            " continue comment marker in new line

" {{{ Terminal settings

autocmd TermOpen * set nonumber norelativenumber
tnoremap jk <c-\><c-n>
tnoremap kj <c-\><c-n>
tnoremap <c-h> <c-\><c-n><c-w><left>
tnoremap <c-j> <c-\><c-n><c-w><down>
tnoremap <c-k> <c-\><c-n><c-w><up>
tnoremap <c-l> <c-\><c-n><c-w><right>
tnoremap <c-space>- <c-w>s
tnoremap <c-space><bar> <c-w>v
autocmd BufEnter * if &buftype == 'terminal' | :startinsert | endif
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


" }}}

" {{{ Whitespace handling
set expandtab
set tabstop=4                   " render tab as 4 spaces
set softtabstop=4
set shiftwidth=4                " width for > < commands
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


