
syntax match tickedVariable /'\([A-Za-z0-9_]\)\+/ contains=tick
syntax match tick /'/ conceal contained
highlight! tickedVariable cterm=italic gui=italic ctermfg=170 guifg=#ffffff

" these are superficial, they just make things pretty
syntax match OpenOxford '\[|' conceal cchar=⟦
syntax match CloseOxford '|]' conceal cchar=⟧
syntax match OpenBanana '(|' conceal cchar=⟬
syntax match CloseBanana '|)' conceal cchar=⟭
syntax match OpenCurly '{|' conceal cchar=⦃
syntax match CloseCurly '|}' conceal cchar=⦄
highlight Conceal ctermfg=None ctermbg=None

" let digraphs be entered with {char}<BS>{char}, instead of just CTRL-K
digraph \"< 171 " «
digraph \"> 187 " »
digraph '< 8249 " ‹
digraph '> 8250 " ›
" ‹ › « » ｢ ｣ ⟨ ⟩ ⟪ ⟫ ⟮ ⟯ ⟬ ⟭ ⌈ ⌉ ⌊ ⌋ ⦇ ⦈ ⦉ ⦊

" conceals work in every mode, except for the current line, in which case they
" are revealed
setlocal concealcursor=
setlocal conceallevel=2

