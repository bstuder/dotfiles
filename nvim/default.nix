{ pkgs, ... }:

let
  extraSettingFile = ".config/nvim/settings.lua";
in
{
  home.packages = builtins.attrValues {
    inherit (pkgs)
      nil
      nixfmt-rfc-style
      stylua
      sumneko-lua-language-server
      ;
    inherit (pkgs.python312.pkgs) python-lsp-server pycodestyle;
  };

  home.file."${extraSettingFile}".source = ./init.lua;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    vimdiffAlias = true;
    withPython3 = true;
    withNodeJs = false;
    withRuby = false;
    extraConfig = "luafile ~/${extraSettingFile}";
    plugins =
      (builtins.attrValues {
        inherit (pkgs.vimPlugins)
          mini-nvim
          onedark-nvim
          lualine-nvim
          comment-nvim
          tabular
          vim-nix
          impatient-nvim
          plenary-nvim
          telescope-nvim
          telescope-fzf-native-nvim
          nvim-web-devicons
          indent-blankline-nvim
          base16-nvim
          nvim-colorizer-lua
          nvim-autopairs
          bufferline-nvim
          null-ls-nvim
          nvim-cmp
          cmp-buffer
          cmp-path
          cmp-greek
          luasnip
          markdown-preview-nvim
          nvim-lspconfig
          nvim-tree-lua
          cmp_luasnip
          cmp-nvim-lsp
          cmp-nvim-lua
          cmp-nvim-lsp-signature-help
          which-key-nvim
          trouble-nvim
          toggleterm-nvim
          lsp-colors-nvim
          fidget-nvim
          ;
      })
      ++ [
        (pkgs.vimPlugins.nvim-treesitter.withPlugins (
          p:
          builtins.attrValues {
            inherit (p)
              arduino
              asm
              awk
              bash
              bibtex
              c
              clojure
              cmake
              comment
              cpp
              css
              csv
              cuda
              devicetree
              diff
              dockerfile
              dot
              doxygen
              embedded_template
              erlang
              fish
              fsh
              func
              git_config
              git_rebase
              gitattributes
              gitcommit
              gitignore
              gn
              gnuplot
              gpg
              graphql
              haskell
              haskell_persistent
              hjson
              hlsl
              hlsplaylist
              html
              http
              java
              javascript
              jq
              jsdoc
              json
              jsonc
              latex
              llvm
              lua
              luadoc
              luap
              luau
              make
              markdown
              markdown_inline
              meson
              ninja
              nix
              objc
              objdump
              org
              passwd
              pem
              printf
              properties
              pymanifest
              python
              readline
              regex
              requirements
              ruby
              rust
              scala
              scheme
              sql
              ssh_config
              strace
              toml
              tsv
              tsx
              udev
              ungrammar
              unison
              vim
              vimdoc
              xml
              yaml
              zathurarc
              ;
          }
        ))
      ];
  };
}
