{ pkgs, ... }:

{
  imports = [ ./nvim ];

  programs.git = {
    enable = true;
    extraConfig = {
      init.defaultBranch = "master";
      core.excludesfile = "$NIXOS_CONFIG_DIR/scripts/gitignore";
      diff.tool = "nvimdiff";
      diff.nodiff.command = "true";
    };
    diff-so-fancy.enable = true;
  };
  programs.jq.enable = true;
  programs.autojump.enable = true;
  programs.dircolors.enable = true;
  programs.fzf.enable = true;
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    autocd = true;
    history = {
      path = "$HOME/.zhistory";
      size = 500000;
      save = 500000;
      share = true;
      expireDuplicatesFirst = true;
      extended = true;
      ignoreDups = true;
      ignoreSpace = true;
    };
    historySubstringSearch = {
      enable = true;
      searchUpKey = "^p";
      searchDownKey = "^n";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "systemd"
      ];
    };
    shellAliases = {
      _ = "sudo ";
      ns = "nix shell";
      nv = "nvim";
      ll = "ls -lh";
      lst = "ll -tr"; # last time the file was modified (content has been modified)
      lstc = "ll -trc"; # last time the /metadata/ of the file was changed (e.g. permissions)
      lsta = "lst -A";
      jq = "jq -C";
      rsync = "rsync --times --atimes --links --info=stats1 --info=progress2 --partial";
      dd = "dd bs=1M status=progress oflag=sync";
      gupa = "git pull --rebase --autostash";
      glgg = ''git log --graph --abbrev-commit --decorate --date=relative --format=format:"%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)" --all'';
      ffmpeg = "ffmpeg -hide_banner";
      ffprobe = "ffprobe -hide_banner";
      diff = "diff --color";
      ip = "ip -c";
      df = "df -H";
      du = "du -h";
      dss = "ds -x *(ND)";
      rg = "rg --pcre2 -S";
      dk = "docker";
      dkrm = "docker stop $(docker ps -a -q);docker rm $(docker ps -a -q)";
      dkrmi = "docker rmi $(docker images -a -q)";
      dkps = "docker ps -a --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}'";
      dki = "docker images";
      dkit = "docker run -t -i --entrypoint=/bin/bash";
    };
    initExtra = ''
      if [ $UID -eq 0 ]; then NCOLOR="red"; else NCOLOR="green"; fi
      #local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

      # nix prompt
      nix_prompt_info () {
        [ -z "$IN_NIX_SHELL" -a "$SHLVL" -le 1 ] && return 0
        local venv=""
        if [ -n "$name" ]; then
          venv="''${name:gs/-env//}"
        elif [ "$SHLVL" -gt 1 ]; then
          venv="LVL''${SHLVL}"
        fi
        echo "''${ZSH_THEME_GIT_PROMPT_PREFIX}''${venv:gs/%/%%}''${ZSH_THEME_GIT_PROMPT_SUFFIX}"
      }

      # ssh prompt
      ssh_prompt_info () {
        [ -z "$SSH_TTY" ] && return 0
        echo "%F{red}''${SSH_TTY:+%n@%m}%f "
      }

      # primary prompt
      PROMPT='$FG[237]------------------------------------------------------------%{$reset_color%}
      $(ssh_prompt_info)$FG[032]%~$(nix_prompt_info)$(git_prompt_info) $FG[105]%(!.#.»)%{$reset_color%} '
      RPROMPT='$FG[237]%n@%m%{$reset_color%}%'
      PROMPT2='%{$fg[red]%}\ %{$reset_color%}'
      #RPS1='$return_code'

      ZSH_THEME_GIT_PROMPT_PREFIX="$FG[075]($FG[078]"
      ZSH_THEME_GIT_PROMPT_CLEAN=""
      ZSH_THEME_GIT_PROMPT_DIRTY="$FG[214]*%{$reset_color%}"
      ZSH_THEME_GIT_PROMPT_SUFFIX="$FG[075])%{$reset_color%}"

      setopt NO_BEEP
      setopt HIST_IGNORE_ALL_DUPS
      setopt HIST_FIND_NO_DUPS
      setopt HIST_SAVE_NO_DUPS
      setopt HIST_REDUCE_BLANKS
      setopt EXTENDED_GLOB
      setopt AUTO_CONTINUE  # stopped jobs -> disown -> automatically sent a CONT to make them running.

      export WORDCHARS="_-";
      if $(which nvim &> /dev/null); then
        export MANPAGER='nvim +Man!'
      else
        export MANPAGER="less -R --use-color -Dd+r -Du+b";
        export MANROFFOPT="-P -c";
      fi

      if $(which direnv &> /dev/null); then
        eval "$(direnv hook zsh)"
      fi

      disable -p '#'
      bindkey '^ ' autosuggest-accept

      function rgg  {
          rg --files $2 | rg --pcre2 -S $1
      }
      compdef _rg rgg
      ds() {
          du -hs $* | sort -h
      }
      compdef _du ds
    '';
  };
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

  home.username = "root";
  home.homeDirectory = "/root";

  home.stateVersion = "24.11";

  home.packages = builtins.attrValues {
    inherit (pkgs)
      acpi
      bind
      bmon
      hwinfo
      inxi
      killall
      wget
      curl
      fd
      ripgrep
      pv
      rsync
      socat
      tcpdump
      tree
      unzip
      which
      xz
      file
      pciutils
      iperf
      lsof
      nmap
      parted
      parallel
      ranger
      strace
      xxd
      inotify-tools
      devenv
      direnv
      aspell
      libargon2
      ffmpeg
      gnupg
      tio
      gcc
      openssl
      pandoc
      patchelf
      poppler_utils
      wireguard-tools
      ;
    inherit (pkgs.aspellDicts) de en fr;
  };

  programs.home-manager.enable = true;
}
