
" {{{ syntax highlighting

" these two predefined syntax elements conflict with the qualifier conceal code
syntax clear purescriptType
syntax clear purescriptFunctionDecl

" hide qualified names
syntax match purescriptQualifiedName /\([A-Z][A-Za-z0-9]*\.\)\+\([A-Za-z0-9_']\+\)/ contains=purescriptQualifierName
syntax match purescriptQualifierName /\([A-Z][A-Za-z0-9]*\.\)\+/ conceal contained
highlight purescriptQualifiedName

setlocal conceallevel=2
setlocal concealcursor=

" }}}

