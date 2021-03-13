
" These are variables which are preceded by a single quote
" explaination of the regex
"   \([^']\|^\) => recognize the beginning of the line or any char but '
"
" TickedVariable recognizes the string {'x} as well as the preceding character,
" since we also use double ticks as semantically relevent, and so we need to
" confirm that the previous character isn't another '
" TickedVariable2 recognizes the first tick and everything after the tick
" TickedVariable3 recognizes the variable name itself
syntax match TickedVariable /\'\([A-Za-z0-9_:~!@#$%^&*\-+=\\<>./?]\)\+/ contains=tick,TickedVariable1
syntax match TickedVariable1   /\([A-Za-z0-9_:~!@#$%^&*\-+=\\<>./?]\)\+/ contained
highlight! TickedVariable1 cterm=italic gui=italic ctermfg=170 guifg=#ffffff

syntax match TickedVariableName /'.\+/ contained contains=tick,TickedVariable2
syntax match tick /'/ conceal contained

" syntax match Punctuation /[(){}\[\],;]/
" highlight link Punctuation Syntax

highlight Syntax cterm=bold ctermfg=60

" Words preceded by a single backtick, and not ended by a backtick
syntax match KeyWord /\([A-Za-z0-9]\)\+:/ contains=KeyWordContents,KeyWordTick
syntax match KeyWordTick /:/ conceal contained
syntax match KeyWordContents /\([A-Za-z0-9]\+\)/ contained
highlight KeywordContents cterm=bold gui=bold ctermfg=39 guifg=gold1


" these are superficial, they just make things pretty
syntax match OpenOxford '\[|' conceal cchar=⟦
syntax match CloseOxford '|]' conceal cchar=⟧
syntax match OpenBanana '(|' conceal cchar=⟬
syntax match CloseBanana '|)' conceal cchar=⟭
syntax match OpenCurly '{|' conceal cchar=⦃
syntax match CloseCurly '|}' conceal cchar=⦄
syntax match RightArrow '->' conceal cchar=→
syntax match LeftArrow '<-' conceal cchar=←
syntax match DoubleRightArrow '=>' conceal cchar=⇒
highlight Conceal ctermfg=None ctermbg=None


" let digraphs be entered with {char}<BS>{char}, instead of just CTRL-K
digraph << 171 " «
digraph >> 187 " »
digraph <  8249 " ‹
digraph >  8250 " ›
digraph LA 0955 " lambda
digraph la 0923 " capital lambda
digraph CO 8728 " compose
digraph && 8743 " and
digraph \|\| 8744 " or 
" ‹ › « » ｢ ｣ ⟨ ⟩ ⟪f⟫ ⟮ ⟯ ⟬ ⟭ ⌈ ⌉ ⌊ ⌋ ⦇ ⦈  ⦉f⦊

" conceals work in every mode, except for the current line, in which case they
" are revealed
setlocal concealcursor=
setlocal conceallevel=2

