{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    extraPackages = with pkgs; [
      # Typescript
      nodejs
      nodePackages.typescript-language-server
      nodePackages.prettier

      # Svelte/SvelteKit
      nodePackages.svelte-language-server

      # Python
      python3
      pyright
      black

      # C/C++
      gnumake
      gcc

      # Lua & Nix
      lua-language-server
      nil
      nixpkgs-fmt
      luarocks
      lua

      # Rust
      cargo
      rustc

      # Golang 
      gopls

      # LaTeX
      texlab
      texliveMedium

      # Core Deps
      ripgrep
      fd
      wl-clipboard
    ];
  };

  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "{config.home.homeDirectory}/winters-arch-dotfs/nvim";
 }
