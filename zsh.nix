{ config, lib, pkgs, ... }:
  {
    programs.zsh = {
      enable = true;
      autocd = true;
      dotDir = ".config/zsh";
      enableAutosuggestions = true;
      enableCompletion = true;

      initExtra = ''
        eval "$(starship init zsh)"
	bindkey -v
        bindkey "^H" backward-delete-char
        bindkey "^?" backward-delete-char
        export KEYTIMEOUT=1
	autoload edit-command-line; zle -N edit-command-line
        bindkey '^e' edit-command-line
      '';

      shellAliases = {
        ls = "exa --icons";
        la = "exa -la";
      };

      plugins = with pkgs; [
        {
          name = "zsh-syntax-highlighting";
          src = fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-syntax-highlighting";
	    rev = "0.8.0-alpha1-pre-redrawhook";
	    sha256 = lib.fakeSha256;
          };
          file = "zsh-syntax-highlighting.zsh";
        }
      ];

    };
  }
