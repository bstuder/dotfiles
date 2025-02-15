{ pkgs, ... }:

{
  imports = [
    ./zsh
    ./nvim
    ./kitty
    ./htop
  ];

  home = {
    username = "root";
    homeDirectory = "/root";
    stateVersion = "24.11";
    packages = builtins.attrValues {
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
  };

  programs.home-manager.enable = true;
}
