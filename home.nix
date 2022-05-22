{ config, lib, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    username = "me";
    homeDirectory = "/Users/me";
    sessionVariables = {
      EDITOR = "${pkgs.neovim}/bin/nvim";
      NIX_PROFILES = "/nix/var/nix/profiles/default /Users/me/.nix-profile";
      PATH = "/Users/me/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH";
    };
    packages = with pkgs; [
      tree
      ripgrep
      git
      fish
    ];

    stateVersion = "22.05";
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.man.generateCaches = true;

  programs.bat.enable = true;
  
  programs.git = {
    enable = true;
    userName = "exegoist";
    userEmail = "exegoist@icloud.com";
    aliases = {
      prettylog = "...";
    };
    extraConfig = {
      core = {
        editor = "nvim";
      };
      color = {
        ui = true;
      };
      push = {
        default = "simple";
      };
      pull = {
        ff = "only";
      };
      init = {
        defaultBranch = "main";
      };
    };
    ignores = [
      ".DS_Store"
      "*.pyc"
      "result"
    ];
};
  programs.neovim = {
    enable = true;
    vimAlias = true;
    extraConfig = " colorscheme gruvbox";
    plugins = with pkgs.vimPlugins; [
      vim-nix
      gruvbox
    ];
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      mkdir = "mkdir -p";
      vi = "vim";
    };
    plugins = with pkgs; [
    # https://github.com/oh-my-fish/theme-bobthefish
      {
        name = "robbyrussell";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "theme-robbyrussell";
          rev = "HEAD";
          sha256 = "l/fctaS58IZKM5/MsYC+WQZ0GWZGZ6SWT+bA5QoODbU=";
          fetchSubmodules = true;
        };
      }
    ];
  };
  xdg.configFile."fish/conf.d/plugin-robbyrusell.fish".text = lib.mkAfter ''
    for f in $plugin_dir/*.fish
      source $f
    end
    '';
  
}
