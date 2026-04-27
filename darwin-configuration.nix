{ pkgs, ... }:

{
  # Profile-specific packages (shared packages are in modules/packages/common.nix)
  environment.systemPackages = with pkgs; [
    ffmpeg
    sox

    (writeShellScriptBin "rebuild" ''
      exec darwin-rebuild switch --flake ".#''${1:-home-mac}"
    '')
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    jetbrains-mono
  ];

  programs.zsh = {
    enable = true;

    promptInit = ''
      autoload -Uz vcs_info
      precmd() { vcs_info }
      zstyle ':vcs_info:git:*' formats ' (%b)'
      setopt PROMPT_SUBST
      PROMPT='%F{blue}%~%f%F{green}''${vcs_info_msg_0_}%f %# '
    '';

    shellInit = ''
      export GOPATH="$HOME/go"
      export PATH="$HOME/go/bin:$PATH"
    '';

    interactiveShellInit = ''
      HISTSIZE=10000
      HISTFILE="$HOME/.cache/zsh_history"
      setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY AUTO_CD CORRECT

      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

      alias ls='ls --color=auto'
      alias ll='ls -lah'
      alias ..='cd ..'

    '';
  };

  nix-homebrew = {
    enable = true;
    enableRosetta = false;
    user = "katsunyan";
  };

  homebrew = {
    enable = true;
    casks = [
      "firefox"
      "hammerspoon"
    ];
    onActivation.autoUpdate = false;
  };

  system.primaryUser = "katsunyan";

  nixpkgs.config.allowUnfree = true;

  nix.enable = false;

  system.stateVersion = 5;
}
