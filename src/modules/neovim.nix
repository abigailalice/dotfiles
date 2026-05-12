
{ lib, config, pkgs, ... }: {
  home.packages = [ pkgs.neovim ];
  home.sessionVariables.EDITOR = "nvim";

  home.activation.linkNvimConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -e "$HOME/.config/nvim" ]; then
      run ln -s "${config.home.homeDirectory}/gits/dotfiles/src/nvim" "$HOME/.config/nvim"
    fi
  '';

  # home.packages = with pkgs; [
  #   gcc gnumake ripgrep fd
  #   rust-analyzer haskell-language-server nil lua-language-server
  #   stylua nixpkgs-fmt
  #   tree-sitter
  # ];

  # xdg.configFile."nvim" = {
  #   source = ../nvim;
  #   recursive = true;
  # };
  # xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink
  #   (toString "${config.home.homeDirectory}/gits/dotfiles/src/nvim");
}
