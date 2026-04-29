{ lib, pkgs, ... }:
{
  programs.zsh = {
    enable = true;

    shellInit = ''
      export GOPATH="$HOME/go"
      export PATH="$HOME/go/bin:$PATH"
    '';

    promptInit = ''
      autoload -Uz vcs_info
      precmd() { vcs_info }
      zstyle ':vcs_info:git:*' formats ' (%b)'
      setopt PROMPT_SUBST
      PROMPT='%F{blue}%~%f%F{green}''${vcs_info_msg_0_}%f %# '
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

      # Basic replacements
      alias ls='exa'                                          # default list
      alias ll='exa --long --header'                         # long format with header
      alias la='exa --long --all --header'                   # long format, show hidden
      alias l='exa --long --all --header --git'              # long + hidden + git status

      # Tree views
      alias lt='exa --tree'                                  # tree view
      alias lt2='exa --tree --level=2'                       # tree, 2 levels deep
      alias lt3='exa --tree --level=3'                       # tree, 3 levels deep
      alias lta='exa --tree --all'                           # tree including hidden

      # Sorted views
      alias lS='exa --long --sort=size --reverse'            # sort by size (largest first)
      alias lm='exa --long --sort=modified --reverse'        # sort by modified (newest first)
      alias lc='exa --long --sort=created --reverse'         # sort by created (newest first)
      alias lx='exa --long --sort=extension'                 # sort by extension

      # Extras
      alias lg='exa --long --all --header --git --git-ignore' # respect .gitignore
    ''
    + lib.optionalString pkgs.stdenv.isLinux ''

      rebuild() {
        sudo nixos-rebuild switch --flake ".#''${1:-home}"
      }
    ''
    + lib.optionalString pkgs.stdenv.isDarwin ''

      rebuild() {
        sudo darwin-rebuild switch --flake ".#''${1:-home-mac}"
      }
    '';
  };
}
