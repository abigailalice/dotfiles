#!/usr/bin/env sh

# interacively finds a Vagrantfile, and creates a symlink to it in the current
# directory. takes an optional argument, which is a regular expression which
# can filter the Vagrantfiles.
# the workflow this is supposed to be used with is to navigate to a directory
# which contains a ./Dotfiles repo, and run this script to start up a VM. I
# typically want the Dotfiles repo to be a shared directory, and also contain
# the project Vagrantfile, but running `vagrant up` in that directory feels
# wrong for a few reasons:
# 1) I want the Vagrantfile and provisioning script to be under version
#    control (which are files that are stored on the host), and the
#    provisioning script may rely on specific files existing within the VM, so
#    the Dotfiles repo on the host and VM need to be kept in sync.
# 2) I want to be able to make changes to the Dotfiles repo, then restart the
#    VM to test those changes, without commiting those changes to git. In other
#    words, I want to be able to test changes in the working directory.
# Having the Dotfiles repo be a shared directory solves both these problems.
# However, running `vagrant up` inside the Dotfiles repo feels awkward for a
# few reasons:
# 1) It will result in the .vagrant/ folder being created in the repo, which
#    needs to be put in .gitignore (not a huge issue).
# 2) If the .vagrant/ folder contains the VMs resources (one of which is the
#    shared director), then the .vagrant/ folder would contain the Dotfiles/
#    folder, which would create a cyclic folder structure.
# I feel like the most natural solution is a structure like:
# vm-root/
#  .vagrant/
#  Dotfiles/
# Which necessitates the Vagrantfile being located in the vm-root rather than
# the Dotfiles/ folder. As a solution, this script finds the Vagrantfile in
# the Dotfiles/ folder, and creates a symlink to it in the vm-root folder.

# One major requirement of this script is that it should work without the repo
# already existing, so it can be used to bootstrap a VM. So this can be
# executed like:
#
# curl github-url-to-this-file | sh

if [ -d ./Dotfiles ]; then
    git clone https://github.com/PastelBlueJellybeans.git Dotfiles
fi

if [ "$#" -eq 1 ]; then
    ln -s $(fd Vagrantfile Dotfiles | rg $1 | fzf -0 -1 --preview='head -$LINES {}') Vagrantfile
else
    ln -s $(fd Vagrantfile Dotfiles | fzf -0 -1 --preview='head -$LINES {}') Vagrantfile
fi
vagrant up

