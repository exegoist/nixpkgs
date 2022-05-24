{ config, lib, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  fonts.fontconfig.enable = true;
  home = {
    username = "me";
    homeDirectory = "/Users/me";
    sessionVariables = {
      EDITOR = "${pkgs.neovim}/bin/nvim";
      NIX_PROFILES = "/nix/var/nix/profiles/default /Users/me/.nix-profile";
      PATH = "/Users/me/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH";
    };
    packages = with pkgs; [
      ripgrep
      git
      git-crypt
      fish
      peco
      exa
      (nerdfonts.override { fonts = [ "SourceCodePro" ]; })
      stow
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
      lexima-vim
      vim-lastplace
    ];
  };

  programs.fish = {
    enable = true;
    shellInit = ''
      # activate user key binding
      fish_user_key_bindings
      '';
    shellAliases = {
      mkdir = "mkdir -p";
      vi = "vim";
      ll = "exa -l -g --icons";
      lt = "exa --tree --level 2 -g --icons";
    };
    functions = {
      peco_select_history = {
        description = "filter command history of a fish shell";
        body = ''
if test (count $argv) = 0
    set peco_flags --layout=bottom-up
  else
    set peco_flags --layout=bottom-up --query "$argv"
  end

  history|peco $peco_flags|read foo

  if [ $foo ]
    commandline $foo
  else
    commandline ""
  end
    '';
      };
      fish_user_key_bindings = {
        description = "additional key binding";
        body = "bind \\cr 'peco_select_history (commandline -b)'";
      };
    };
    plugins = with pkgs; [
    # https://github.com/oh-my-fish/theme-robbyrussell
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
  xdg.configFile."fish/conf.d/plugins-activate.fish".text = lib.mkAfter ''
    for f in $plugin_dir/*.fish
      source $f
    end
    '';
  
}
