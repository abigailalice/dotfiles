# taken from http://dev.stephendiehl.com/hask/
alias ghc-sandbox="ghc -no-user-package-db -package-db .cabal-sandbox/*-packages.conf.d"
alias ghci-sandbox="ghci -no-user-package-db -package-db .cabal-sandbox/*-packages.conf.d"
alias runhaskell-sandbox="runhaskell -no-user-package-db -package-db .cabal-sandbox/*-packages.conf.d"
alias ghci-core="ghci -ddump-simpl -dsuppress-idinfo -dsuppress-coercions -dsuppress-type-applications -dsuppress-uniques -dsuppress-module-prefixes"
alias dry-run="cabal install --dry-run -v3"

if [ $(uname) = "Darwin" ]; then
    # osx

    # the -G flag adds color on osx, on linux the color is enabled by default, and -G removes some information when combined with -l
    alias ls='ls -AG'

    # add cabal binaries to path
    export PATH=$HOME/Library/Haskell/bin:$PATH

    # replace a few commands in child shells
    function vim {
        /usr/local/Cellar/vim/7.4.430_1/bin/vim "$@"
    }
    export -f vim
    function ctags {
        /usr/local/Cellar/ctags/5.8/bin/ctags "$@"
    }
    export -f ctags
else
    # linux

    alias ls='ls -A'

    # not sure if these are unix specific, need to test that
    alias mount='mount |column -t'
    alias jobs='jobs -l'
fi
