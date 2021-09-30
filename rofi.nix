{ config, lib, pkgs, ... }:
  {
    programs.rofi = {
      enable = true;
      theme = let
        inherit (config.lib.formats.rasi) mkLiteral;
      in {
        "*" = {
          background-color            = mkLiteral "#282c34";
          border-color                = mkLiteral "#282c34";
          text-color                  = mkLiteral "#bbc2cf";
          prompt-background           = mkLiteral "#51afef";
          prompt-foreground           = mkLiteral "#282c34";
          alternate-normal-background = mkLiteral "#1c1f24";
          alternate-normal-foreground = mkLiteral "@text-color";
          selected-normal-background  = mkLiteral "#325ac5";
          selected-normal-foreground  = mkLiteral "#ffffff";
        };

        "#inputbar" = {
            children = map mkLiteral [ "prompt" "entry" ];
          };

        "#textbox-prompt-colon" = {
            expand = false;
            str = ":";
            margin = mkLiteral "0px 0.3em 0em 0em";
            text-color = mkLiteral "@foreground-color";
          };

        "#element" = {
            border = mkLiteral "0";
            padding = mkLiteral "1px";
          };

        "#element.selected.normal" = {
            background-color = mkLiteral "@selected-normal-background";
            text-color       = mkLiteral "@selected-normal-foreground";
          };
          
        "#element.alternate.normal" = {
            background-color = mkLiteral "@alternate-normal-background";
            text-color       = mkLiteral "@alternate-normal-foreground";
          };
      };
    };
  }
