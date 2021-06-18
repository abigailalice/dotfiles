#!/opt/homebrew/fish

function not-installed
    ! which $argv[1] > /dev/null
end

# add pi alias
#if ! grep -Fxq "ipaddress pi"
#echo "ipaddress pi" >> /etc/hosts
#end



if test (uname -s) = "Darwin" && not-installed brew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
end


# check that fish is an allowed shell
if ! grep -Fxq (which fish) /etc/shells
    # make fish allowed
    echo (which fish) >> /etc/shells
end
# make fish default
chsh -s (which fish)

# deploy scripts
# necessary for scripts/battery
if not-installed gsed
    brew install gsed
end

mkdir -p ~/.local/bin
ln -fs "$HOME/Home/gits/dotfiles/src/scripts/battery" ~/.local/bin/battery
ln -fs "$HOME/Home/gits/dotfiles/src/scripts/utils/diskusage" ~/.local/bin/diskusage
ln -fs "$HOME/Home/gits/dotfiles/src/scripts/git_status.fish" /.local/bin/gitstatus

