{ pkgs, config, ... }: {
  home.packages = with pkgs; [
    neovim

    # Typescript
    nodejs
    typescript-language-server
    vscode-langservers-extracted
    tailwindcss-language-server
    emmet-ls
    prettier
    vtsls

    # Svelte/SvelteKit
    svelte-language-server

    # Python
    python3
    pyright
    black

    # C/C++
    gnumake
    gcc
    clang-tools
    tree-sitter

    # Lua & Nix
    lua-language-server
    nil
    nixpkgs-fmt
    luarocks
    lua

    # Rust
    cargo
    rustc
    rust-analyzer

    # Golang 
    gopls

    # LaTeX
    texlab
    texliveMedium
    ltex-ls

    # Core Deps
    ripgrep
    fd
    wl-clipboard
  ];

  home.shellAliases = {
    vi = "nvim";
    vim = "nvim";
  };

  # 3. Export the Svelte path globally so Neovim can find it without the wrapper
  home.sessionVariables = {
    NIX_SVELTE_PLUGIN_PATH = "${pkgs.svelte-language-server}/lib/node_modules/svelte-language-server/node_modules/typescript-svelte-plugin";
    EDITOR = "nvim";
  };

  # 4. Create the pure, unadulterated symlink
  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/winters-arch-dotfs/nvim";
 }
