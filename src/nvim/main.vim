

" {{{ Plugin setting
" {{{ junegunn/vim-plug boilerplate

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
" }}}

call plug#begin('~/.local/share/nvim/plugged')

" {{{ themes

"Plug itchyny/lightline.vim
Plug 'vim-airline/vim-airline' " {{{
" we don't need to show the mode in the command line because airline does in
" the statusbar
set noshowmode
" }}}
" }}}

Plug 'Shougo/denite.nvim' " {{{
nnoremap ub :Denite buffer<cr>
nnoremap uc :Denite color<cr>
" FIXME
" find a way to list actions in selection better (tab works)
" find a way to close buffer on backspace

" }}}
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-fugitive'
Plug 'justinmk/vim-sneak'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'sjl/gundo.vim'
" Plug 'junegunn/limelight.vim'
" Plug 'Shougo/defx.nvim'
Plug 'Shougo/deoplete.nvim'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'scrooloose/nerdcommenter'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

Plug 'blueyed/vim-diminactive'
let g:diminactive_buftype_blacklist = []

" {{{ language plugins
Plug 'vim-syntastic/syntastic'
Plug 'dag/vim-fish'
" }}}

call plug#end()

" }}}


set path+=,$HOME/gits/dotfiles/src/nvim/,

source $HOME/gits/dotfiles/src/nvim/basic.vim

" {{{ Tmux-style pane separators
" This attempts to have Tmux-style pane separators, by changing verticle lines
" to 
set fillchars+=vert:│,stlnc:X
highlight VertSplit ctermbg=GREEN guibg=GREEN ctermfg=WHITE guifg=WHITE
autocmd BufLeave,BufWinLeave *
    \ set statusline=─ |
    \ highlight StatusLine ctermfg=green ctermbg=green |
    \ highlight StatusLineNC ctermfg=green ctermbg=green
" }}}
let &colorcolumn="80,".join(range(81,999),",")

" {{{ Keybindings
nnoremap <leader>b :Denite buffer -winheight=10<cr>
nnoremap <leader>h :Denite help<cr>
nnoremap <leader>e :NERDTreeToggle<cr>
nnoremap <leader>u :GundoToggle<cr>
" }}}

