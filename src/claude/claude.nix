{ config, ... }:

let
  dotfiles = "/home/abigailgooding/gits/dotfiles/src/claude";
in
{
  home.file = {
    ".claude/settings.json".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfiles}/settings.json";

    ".claude/CLAUDE.md".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfiles}/CLAUDE.md";

    ".claude/skills/prepare-squash-merge/SKILL.md".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfiles}/skills/prepare-squash-merge/SKILL.md";

    ".claude/skills/project-health-audit/SKILL.md".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfiles}/skills/project-health-audit/SKILL.md";
  };
}
