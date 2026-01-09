{
  config,
  pkgs,
  currentThemeName,
  ...
}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # Select theme plugin and colorscheme by currentThemeName
    plugins = let
      theme = {
        plugin = pkgs.vimPlugins.nord-vim;
        colorscheme = "nord";
        luaSetup = "";
        vimSetup = "";
      };
      themeMap = {
        # Original themes
        nord = theme // {
          plugin = pkgs.vimPlugins.nord-vim;
          colorscheme = "nord";
        };
        dracula = theme // {
          plugin = pkgs.vimPlugins.dracula-vim;
          colorscheme = "dracula";
        };
        tokyonight = theme // {
          plugin = pkgs.vimPlugins.tokyonight-nvim;
          colorscheme = "tokyonight";
          luaSetup = "require('tokyonight').setup({ style = 'night' })";
        };
        ocean = theme // {
          plugin = pkgs.vimPlugins.base16-vim;
          colorscheme = "base16-ocean";
          vimSetup = "let base16colorspace=256";
        };
        catppuccin = theme // {
          plugin = pkgs.vimPlugins.catppuccin-nvim;
          colorscheme = "catppuccin";
          luaSetup = "require('catppuccin').setup({ flavour = 'mocha' })";
        };
        # Gruvbox - warm retro theme
        gruvbox = theme // {
          plugin = pkgs.vimPlugins.gruvbox-nvim;
          colorscheme = "gruvbox";
          luaSetup = "require('gruvbox').setup({ contrast = 'medium' })";
        };
        gruvbox-light = theme // {
          plugin = pkgs.vimPlugins.gruvbox-nvim;
          colorscheme = "gruvbox";
          luaSetup = "require('gruvbox').setup({ contrast = 'medium' })\nvim.o.background = 'light'";
        };
        # Solarized - scientific palette
        solarized-dark = theme // {
          plugin = pkgs.vimPlugins.solarized-nvim;
          colorscheme = "solarized";
          luaSetup = "require('solarized').setup({})";
        };
        solarized-light = theme // {
          plugin = pkgs.vimPlugins.solarized-nvim;
          colorscheme = "solarized";
          luaSetup = "require('solarized').setup({})\nvim.o.background = 'light'";
        };
        # One Dark - Atom's theme
        onedark = theme // {
          plugin = pkgs.vimPlugins.onedark-nvim;
          colorscheme = "onedark";
          luaSetup = "require('onedark').setup({ style = 'dark' })\nrequire('onedark').load()";
        };
        # Monokai - Sublime Text classic
        monokai = theme // {
          plugin = pkgs.vimPlugins.monokai-pro-nvim;
          colorscheme = "monokai-pro";
          luaSetup = "require('monokai-pro').setup({})";
        };
        # Rosé Pine - modern aesthetic
        rose-pine = theme // {
          plugin = pkgs.vimPlugins.rose-pine;
          colorscheme = "rose-pine";
          luaSetup = "require('rose-pine').setup({ variant = 'main' })";
        };
        rose-pine-moon = theme // {
          plugin = pkgs.vimPlugins.rose-pine;
          colorscheme = "rose-pine";
          luaSetup = "require('rose-pine').setup({ variant = 'moon' })";
        };
        # Everforest - soft green
        everforest = theme // {
          plugin = pkgs.vimPlugins.everforest;
          colorscheme = "everforest";
          vimSetup = "let g:everforest_background = 'medium'";
        };
        # Kanagawa - Japanese inspired
        kanagawa = theme // {
          plugin = pkgs.vimPlugins.kanagawa-nvim;
          colorscheme = "kanagawa";
          luaSetup = "require('kanagawa').setup({ theme = 'wave' })";
        };
      };
      sel = themeMap.${currentThemeName};
    in [
      sel.plugin
      pkgs.vimPlugins.nerdtree
      pkgs.vimPlugins.ctrlp-vim
      pkgs.vimPlugins.lightline-vim
      pkgs.vimPlugins.vim-commentary
      pkgs.vimPlugins.vim-fugitive
      pkgs.vimPlugins.vim-go
      pkgs.vimPlugins.coc-nvim
      pkgs.vimPlugins.vim-devicons
    ];

    extraConfig = let
      themeMap = {
        nord = { vimSetup = ""; colorscheme = "nord"; };
        dracula = { vimSetup = ""; colorscheme = "dracula"; };
        tokyonight = { vimSetup = ""; colorscheme = "tokyonight"; };
        ocean = { vimSetup = "let base16colorspace=256"; colorscheme = "base16-ocean"; };
        catppuccin = { vimSetup = ""; colorscheme = "catppuccin"; };
        gruvbox = { vimSetup = ""; colorscheme = "gruvbox"; };
        gruvbox-light = { vimSetup = "set background=light"; colorscheme = "gruvbox"; };
        solarized-dark = { vimSetup = ""; colorscheme = "solarized"; };
        solarized-light = { vimSetup = "set background=light"; colorscheme = "solarized"; };
        onedark = { vimSetup = ""; colorscheme = "onedark"; };
        monokai = { vimSetup = ""; colorscheme = "monokai-pro"; };
        rose-pine = { vimSetup = ""; colorscheme = "rose-pine"; };
        rose-pine-moon = { vimSetup = ""; colorscheme = "rose-pine"; };
        everforest = { vimSetup = "let g:everforest_background = 'medium'"; colorscheme = "everforest"; };
        kanagawa = { vimSetup = ""; colorscheme = "kanagawa"; };
      };
      sel = themeMap.${currentThemeName};
      baseConfig = builtins.readFile ./init.vim;
    in ''
      " Load base configuration from init.vim
      ${baseConfig}

      " Theme-specific Vim setup
      ${sel.vimSetup}

      " Apply colorscheme
      colorscheme ${sel.colorscheme}
    '';

    extraLuaConfig = let
      luaMap = {
        nord = "";
        dracula = "";
        tokyonight = "require('tokyonight').setup({ style = 'night' })";
        ocean = "";
        catppuccin = "require('catppuccin').setup({ flavour = 'mocha' })";
        gruvbox = "require('gruvbox').setup({ contrast = 'medium' })";
        gruvbox-light = "require('gruvbox').setup({ contrast = 'medium' })\nvim.o.background = 'light'";
        solarized-dark = "require('solarized').setup({})";
        solarized-light = "require('solarized').setup({})\nvim.o.background = 'light'";
        onedark = "require('onedark').setup({ style = 'dark' })\nrequire('onedark').load()";
        monokai = "require('monokai-pro').setup({})";
        rose-pine = "require('rose-pine').setup({ variant = 'main' })";
        rose-pine-moon = "require('rose-pine').setup({ variant = 'moon' })";
        everforest = "";
        kanagawa = "require('kanagawa').setup({ theme = 'wave' })";
      };
      lua = luaMap.${currentThemeName};
    in (
      if lua == ""
      then ""
      else lua
    );
  };
}
