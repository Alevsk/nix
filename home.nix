{ config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should manage.
  home.username = "alevsk";
  home.homeDirectory = lib.mkForce "/Users/alevsk";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  home.stateVersion = "24.05";

  # User-specific packages
  home.packages = with pkgs; [
    # Development tools
    curl
    wget
    jq
    tree
    htop
    ripgrep
    fd
    bat
    eza
    
    # Additional CLI tools
    gh  # GitHub CLI
    fzf
  ];

  # Shell configuration
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    shellAliases = {
      ll = "eza -la";
      ls = "eza";
      cat = "bat";
      grep = "rg";
      find = "fd";
      rebuild = "sudo darwin-rebuild switch --flake ~/nix#cloud";
      nix-gc = "nix-collect-garbage -d";
    };
    
    initExtra = ''
      # Custom prompt
      export PS1="%F{blue}%n@%m%f:%F{cyan}%~%f %# "
      
      # History configuration
      export HISTSIZE=10000
      export SAVEHIST=10000
      setopt HIST_IGNORE_DUPS
      setopt HIST_IGNORE_SPACE
      setopt SHARE_HISTORY
      
      # Better cd behavior
      setopt AUTO_CD
      setopt AUTO_PUSHD
      setopt PUSHD_IGNORE_DUPS
      
      # Enable fzf key bindings and fuzzy completion
      if command -v fzf >/dev/null 2>&1; then
        source <(fzf --zsh)
      fi
    '';
  };

  # Git configuration
  programs.git = {
    enable = true;
    userName = "Lenin Alevski";
    userEmail = "alevsk@cloud.local";
    extraConfig = {
      init.defaultBranch = "main";
      push.default = "simple";
      pull.rebase = true;
      core.editor = "nvim";
    };
  };

  # Alacritty terminal configuration
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        opacity = 0.95;
        padding = {
          x = 10;
          y = 10;
        };
      };
      
      font = {
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "JetBrainsMono Nerd Font";
          style = "Italic";
        };
        size = 14.0;
      };
      
      colors = {
        primary = {
          background = "#1e1e2e";
          foreground = "#cdd6f4";
        };
        normal = {
          black = "#45475a";
          red = "#f38ba8";
          green = "#a6e3a1";
          yellow = "#f9e2af";
          blue = "#89b4fa";
          magenta = "#f5c2e7";
          cyan = "#94e2d5";
          white = "#bac2de";
        };
        bright = {
          black = "#585b70";
          red = "#f38ba8";
          green = "#a6e3a1";
          yellow = "#f9e2af";
          blue = "#89b4fa";
          magenta = "#f5c2e7";
          cyan = "#94e2d5";
          white = "#a6adc8";
        };
      };
    };
  };

  # Neovim configuration
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    
    extraConfig = ''
      " Basic settings
      set number
      set relativenumber
      set tabstop=2
      set shiftwidth=2
      set expandtab
      set smartindent
      set wrap
      set ignorecase
      set smartcase
      set incsearch
      set hlsearch
      
      " Color scheme
      set termguicolors
      colorscheme default
      
      " Key mappings
      let mapleader = " "
      nnoremap <leader>w :w<CR>
      nnoremap <leader>q :q<CR>
      nnoremap <leader>h :nohlsearch<CR>
    '';
  };

  # Tmux configuration
  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    historyLimit = 10000;
    keyMode = "vi";
    
    extraConfig = ''
      # Better prefix key
      unbind C-b
      set -g prefix C-a
      bind C-a send-prefix
      
      # Better splitting
      bind | split-window -h
      bind - split-window -v
      
      # Vim-like pane navigation
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      
      # Enable mouse support
      set -g mouse on
      
      # Status bar
      set -g status-bg black
      set -g status-fg white
      set -g status-left '[#S] '
      set -g status-right '%Y-%m-%d %H:%M'
    '';
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
