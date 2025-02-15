{ ... }:
{
  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;
    keybindings = {
      "ctrl+alt+v" = "paste_selection";
    };

    settings = {
      scrollback_lines = 12000;
      enable_audio_bell = false;
      update_check_interval = 0;
      close_on_child_death = "yes";
      copy_on_select = "clipboard";
      mouse_map = "middle release ungrabbed paste_from_clipboard";

      cursor_shape = "beam";
      cursor_blink_interval = 0;

      font_family = "monospace";
      font_size = "11.5";

      foreground = "#bbc2cf";
      background = "#300A24";
      selection_foreground = "#bbc2cf";
      selection_background = "#3f444a";
      cursor = "#bbc2cf";
      cursor_text_color = "#282c34";
      active_border_color = "#46D9FF";
      inactive_border_color = "#3f444a";
      active_tab_foreground = "#282c34";
      active_tab_background = "#DFDFDF";
      inactive_tab_foreground = "#3f444a";
      inactive_tab_background = "#5B6268";

      color0 = "#2a2e38";
      color8 = "#3f444a";
      color1 = "#ff6c6b";
      color9 = "#ff6655";
      color2 = "#98be65";
      color10 = "#99bb66";
      color3 = "#ECBE7B";
      color11 = "#ECBE7B";
      color4 = "#51afef";
      color12 = "#51afef";
      color5 = "#c678dd";
      color13 = "#c678dd";
      color6 = "#46D9FF";
      color14 = "#46D9FF";
      color7 = "#DFDFDF";
      color15 = "#bbc2cf";
    };
  };
}
