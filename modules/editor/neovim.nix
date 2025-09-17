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
        nord =
          theme
          // {
            plugin = pkgs.vimPlugins.nord-vim;
            colorscheme = "nord";
          };
        dracula =
          theme
          // {
            plugin = pkgs.vimPlugins.dracula-vim;
            colorscheme = "dracula";
          };
        tokyonight =
          theme
          // {
            plugin = pkgs.vimPlugins.tokyonight-nvim;
            colorscheme = "tokyonight";
            luaSetup = "require('tokyonight').setup({ style = 'night' })";
          };
        ocean =
          theme
          // {
            plugin = pkgs.vimPlugins.base16-vim;
            colorscheme = "base16-ocean";
            vimSetup = "let base16colorspace=256";
          };
        default =
          theme
          // {
            plugin = pkgs.vimPlugins.catppuccin-nvim;
            colorscheme = "catppuccin";
            luaSetup = "require('catppuccin').setup({ flavour = 'mocha' })";
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
        nord = {
          vimSetup = "";
          colorscheme = "nord";
        };
        dracula = {
          vimSetup = "";
          colorscheme = "dracula";
        };
        tokyonight = {
          vimSetup = "";
          colorscheme = "tokyonight";
        };
        ocean = {
          vimSetup = "let base16colorspace=256";
          colorscheme = "base16-ocean";
        };
        default = {
          vimSetup = "";
          colorscheme = "catppuccin";
        };
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
        default = "require('catppuccin').setup({ flavour = 'mocha' })";
      };
      lua = luaMap.${currentThemeName};
    in (
      if lua == ""
      then ""
      else lua
    );
  };
}
