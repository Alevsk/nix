{
  config,
  pkgs,
  lib,
  ...
}: let
  # Stylix/base16 palette → 24-bit SGR fragments so lf tracks switch-theme.
  colors = config.lib.stylix.colors;
  hexToRgb = hex: let
    toDec = h: (builtins.fromTOML "n = 0x${h}").n;
    r = toDec (builtins.substring 0 2 hex);
    g = toDec (builtins.substring 2 2 hex);
    b = toDec (builtins.substring 4 2 hex);
  in "${toString r};${toString g};${toString b}";
  rgb = name: hexToRgb colors.${name};
  fg = name: "38;2;${rgb name}";
  bg = name: "48;2;${rgb name}";

  runtime = with pkgs; [
    bat
    chafa
    coreutils
    eza
    fd
    file
    findutils
    fzf
    gawk
    git
    gnused
    gnutar
    jq
    mdcat
    p7zip
    poppler-utils
    unzip
    yq
  ];

  lfPreview = pkgs.writeShellScript "lf-preview" ''
    export PATH="${lib.makeBinPath runtime}:/usr/bin:/bin:$PATH"
    export BAT_THEME=ansi
    ${builtins.readFile ./preview.sh}
  '';

  cheatsheet = pkgs.writeText "lf-cheatsheet" ''
    lf  ·  keys (this config)

    movement      hjkl  gg G  <c-u>/<c-d>  <c-b>/<c-f>
    open / up     l  <enter>  h            e  nvim   o  open   O  Quick Look
                  markdown: l/enter = mdless (read)   e = nvim (edit)
    select        <space>  v invert  u unselect  V visual
    yank / paste  y copy  d cut  p paste  c clear  Y copy path  <a-y> copy name
    delete        D  <delete>   (macOS Trash, not rm)
    files         a mkdir (and enter)  A touch  r rename  R bulk-rename  + chmod +x
    archives      x extract   Z archive
    hidden        .  or  zh
    preview       zp toggle   i pager (mdless for markdown, bat otherwise)
    goto          gh ~   gn ~/nix   gd ~/Downloads   gD ~/Development
                  gc ~/.config   gt /tmp   gr git-root   go Finder   gL follow symlink
    jump          zz zoxide   zf/<c-t> fuzzy file   ze fuzzy edit   zg fuzzy grep
                  F live-filter current dir
    git / agents  gl lazygit   gk hunk   gw herdr
    shell         w shell   ! cmd   $ cmd   U du
    quit          q  (zsh `lf` cd's you to the last directory)
  '';
in {
  # CLI file manager. Sibling files in this directory (preview.sh, icons)
  # are the versioned customization surface for lf.
  home.packages = [pkgs.chafa];

  xdg.configFile."lf/icons".source = ./icons;
  xdg.configFile."lf/colors".text = ''
    # 24-bit file colors from the active Stylix scheme
    ln      01;${fg "base0C"}
    or      01;${fg "base08"}
    tw      ${fg "base0D"}
    ow      ${fg "base0D"}
    st      01;${fg "base0D"}
    di      01;${fg "base0D"}
    pi      ${fg "base0A"}
    so      01;${fg "base0E"}
    bd      01;${fg "base0A"}
    cd      01;${fg "base0A"}
    su      01;${fg "base0B"}
    sg      01;${fg "base0B"}
    ex      01;${fg "base0B"}
    fi      ${fg "base05"}

    *.nix   01;${fg "base0C"}
    *.sh    ${fg "base0B"}
    *.bash  ${fg "base0B"}
    *.zsh   ${fg "base0B"}
    *.py    ${fg "base0A"}
    *.go    ${fg "base0C"}
    *.rs    ${fg "base09"}
    *.js    ${fg "base0A"}
    *.ts    ${fg "base0D"}
    *.tsx   ${fg "base0D"}
    *.jsx   ${fg "base0D"}
    *.lua   ${fg "base0D"}
    *.vim   ${fg "base0B"}
    *.md    ${fg "base0A"}
    *.json  ${fg "base0A"}
    *.yml   ${fg "base0E"}
    *.yaml  ${fg "base0E"}
    *.toml  ${fg "base0E"}
    *.lock  ${fg "base04"}
    *.env   ${fg "base08"}

    *.tar   01;${fg "base08"}
    *.tgz   01;${fg "base08"}
    *.zip   01;${fg "base08"}
    *.gz    01;${fg "base08"}
    *.bz2   01;${fg "base08"}
    *.xz    01;${fg "base08"}
    *.zst   01;${fg "base08"}
    *.7z    01;${fg "base08"}
    *.rar   01;${fg "base08"}
    *.dmg   01;${fg "base08"}

    *.jpg   01;${fg "base0E"}
    *.jpeg  01;${fg "base0E"}
    *.png   01;${fg "base0E"}
    *.gif   01;${fg "base0E"}
    *.webp  01;${fg "base0E"}
    *.svg   01;${fg "base0E"}
    *.mp4   01;${fg "base0E"}
    *.mkv   01;${fg "base0E"}
    *.mov   01;${fg "base0E"}
    *.webm  01;${fg "base0E"}
    *.mp3   ${fg "base0C"}
    *.wav   ${fg "base0C"}
    *.flac  ${fg "base0C"}

    *.pdf   01;${fg "base08"}
    *.diff  ${fg "base08"}
    *.patch ${fg "base08"}
    *.log   ${fg "base04"}
  '';

  programs.lf = {
    enable = true;

    settings = {
      preview = true;
      hidden = false;
      drawbox = true;
      icons = true;
      ignorecase = true;
      smartcase = true;
      incsearch = true;
      globsearch = true;
      incfilter = true;
      dirfirst = true;
      dirpreviews = true;
      dircounts = true;
      mouse = true;
      relativenumber = true;
      number = false;
      wrapscan = true;
      wrapscroll = false;
      watch = true;
      period = 0;
      scrolloff = 8;
      tabstop = 4;
      findlen = 1;
      sortby = "natural";
      info = ["size" "time"];
      shell = "sh";
      shellopts = "-eu";
      ratios = [1 2 3];
      borderstyle = "roundbox";
      truncatechar = "…";
      hiddenfiles = ".*:lost+found";
    };

    previewer.source = lfPreview;

    extraConfig = ''
      set ifs "\n"
      set borderfmt "\033[${fg "base03"}m"
      set cursoractivefmt "\033[1;${fg "base00"};${bg "base0D"}m"
      set cursorparentfmt "\033[${fg "base05"};${bg "base01"}m"
      set cursorpreviewfmt "\033[1;${fg "base0D"};4m"
      set copyfmt "\033[1;${fg "base00"};${bg "base0A"}m"
      set cutfmt "\033[1;${fg "base00"};${bg "base08"}m"
      set selectfmt "\033[1;${fg "base00"};${bg "base0E"}m"
      set visualfmt "\033[1;${fg "base00"};${bg "base0C"}m"
      set tagfmt "\033[1;${fg "base08"}m"
      set errorfmt "\033[1;${fg "base00"};${bg "base08"}m"
      set numberfmt "\033[${fg "base03"}m"
      set menufmt "\033[${fg "base05"};${bg "base01"}m"
      set menuheaderfmt "\033[1;${fg "base0D"};${bg "base01"}m"
      set menuselectfmt "\033[1;${fg "base00"};${bg "base0D"}m"

      set promptfmt "\033[${fg "base0D"}m\033[0m \033[1;${fg "base0D"}m%d\033[0m\033[1;${fg "base06"}m%f\033[0m%S\033[${fg "base04"}m%u@%h \033[0m"
      set statfmt "\033[${fg "base0C"}m%p\033[0m  \033[${fg "base04"}m%u:%g\033[0m  \033[${fg "base0A"}m%S\033[0m  \033[${fg "base04"}m%t\033[0m| -> \033[${fg "base0C"}m%l\033[0m"
      set rulerfmt " \033[${fg "base04"}m%a\033[0m| \033[1;${fg "base00"};${bg "base08"}m %m \033[0m| \033[1;${fg "base00"};${bg "base0A"}m %c \033[0m| \033[1;${fg "base00"};${bg "base0E"}m %s \033[0m| \033[${fg "base0C"}m%f\033[0m| \033[1;${fg "base0D"}m%i/%t\033[0m \033[${fg "base04"}m%P\033[0m| \033[${fg "base0B"}m%d\033[0m"

      # Newest first in drop-zones; rest of the tree stays natural name sort.
      setlocal ~/Downloads sortby time
      setlocal ~/Downloads reverse
      setlocal ~/Desktop sortby time
      setlocal ~/Desktop reverse

      # Refresh prompt with git branch + terminal title; feed zoxide.
      cmd on-cd &{{
          if command -v zoxide >/dev/null 2>&1; then
              zoxide add "$PWD" || true
          fi
          e=$(printf '\033')
          gitfmt=""
          if git -C "$PWD" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
              branch=$(git -C "$PWD" branch --show-current 2>/dev/null || true)
              if [ -z "$branch" ]; then
                  branch=$(git -C "$PWD" rev-parse --short HEAD 2>/dev/null || true)
              fi
              if [ -n "$branch" ]; then
                  gitfmt=" ''${e}[${fg "base0E"}m ''${branch}''${e}[0m"
              fi
          fi
          fmt="''${e}[${fg "base0D"}m''${e}[0m ''${e}[1;${fg "base0D"}m%d''${e}[0m''${e}[1;${fg "base06"}m%f''${e}[0m''${gitfmt}%S''${e}[${fg "base04"}m%u@%h ''${e}[0m"
          lf -remote "send $id set promptfmt \"$fmt\""
          case "$PWD" in
              "$HOME"*) title="~''${PWD#$HOME}" ;;
              *) title="$PWD" ;;
          esac
          printf '\033]0;lf: %s\033\\' "$title" >/dev/tty 2>/dev/null || true
      }}

      cmd open ''${{
          set -f
          # Markdown: read with mdless. Edit with `e` (nvim).
          case "$f" in
              *.md|*.markdown|*.mdx|*.mkd|*.MD)
                  if command -v mdless >/dev/null 2>&1; then
                      mdless $fx
                  else
                      ''${EDITOR:-nvim} $fx
                  fi
                  exit 0
                  ;;
          esac
          mime=$(file --mime-type -Lb "$f" 2>/dev/null || echo application/octet-stream)
          case "$mime" in
              text/markdown|text/x-markdown)
                  mdless $fx
                  ;;
              text/*|application/json|application/javascript|application/xml|application/toml|application/x-sh|application/x-shellscript|application/x-empty|inode/x-empty)
                  ''${EDITOR:-nvim} $fx
                  ;;
              image/*)
                  open $fx >/dev/null 2>&1 &
                  ;;
              video/*|audio/*)
                  if [ -d /Applications/IINA.app ]; then
                      open -a IINA $fx >/dev/null 2>&1 &
                  else
                      open $fx >/dev/null 2>&1 &
                  fi
                  ;;
              application/pdf)
                  open $fx >/dev/null 2>&1 &
                  ;;
              *)
                  case "$f" in
                      *.nix|*.toml|*.yml|*.yaml|*.json|*.txt|*.conf|*.ini)
                          ''${EDITOR:-nvim} $fx
                          ;;
                      *)
                          open $fx >/dev/null 2>&1 &
                          ;;
                  esac
                  ;;
          esac
      }}

      cmd trash ''${{
          set -f
          trash $fx
      }}

      cmd mkdir ''${{
          set -f
          mkdir -p -- "$1"
          lf -remote "send $id cd \"$1\""
      }}
      cmd touch %touch "$@"
      cmd archive ''${{
          set -f
          tar czf "$1.tar.gz" $fx
          lf -remote "send $id echo \"created $1.tar.gz\""
      }}
      cmd follow ''${{
          [ -L "$f" ] || {
              lf -remote "send $id echoerr not a symlink"
              exit 0
          }
          target=$(realpath "$f")
          if [ -d "$target" ]; then
              lf -remote "send $id cd \"$target\""
          else
              dir=$(dirname "$target")
              base=$(basename "$target")
              lf -remote "send $id cd \"$dir\""
              lf -remote "send $id select \"$base\""
          fi
      }}
      cmd copy-name %{{
          basename "$f" | tr -d '\n' | pbcopy
          lf -remote "send $id echomsg copied name"
      }}
      cmd toggle-preview %{{
          if [ "$lf_preview" = true ]; then
              lf -remote "send $id :set preview false; set ratios 1:5"
          else
              lf -remote "send $id :set preview true; set ratios 1:2:3"
          fi
      }}

      cmd bulk-rename ''${{
          set -f
          old=$(mktemp)
          new=$(mktemp)
          printf '%s\n' $fx > "$old"
          cp "$old" "$new"
          ''${EDITOR:-nvim} "$new"
          if [ "$(wc -l < "$new")" -ne "$(wc -l < "$old")" ]; then
              lf -remote "send $id echoerr bulk-rename: line count changed, abort"
              rm -f "$old" "$new"
              exit 1
          fi
          paste "$old" "$new" | while IFS="$(printf '\t')" read -r src dst; do
              [ "$src" = "$dst" ] && continue
              [ -e "$dst" ] && continue
              mv -- "$src" "$dst"
          done
          rm -f "$old" "$new"
          lf -remote "send $id reload"
      }}

      cmd extract ''${{
          set -f
          case "$f" in
              *.tar.bz|*.tar.bz2|*.tbz|*.tbz2) tar xjvf "$f" ;;
              *.tar.gz|*.tgz) tar xzvf "$f" ;;
              *.tar.xz|*.txz) tar xJvf "$f" ;;
              *.tar.zst) tar --zstd -xvf "$f" ;;
              *.zip) unzip "$f" ;;
              *.rar) unrar x "$f" ;;
              *.7z) 7z x "$f" ;;
              *) tar xf "$f" ;;
          esac
      }}

      cmd copy-path %{{
          printf '%s' "$fx" | pbcopy
          lf -remote "send $id echomsg copied path"
      }}

      cmd zoxide ''${{
          result=$(zoxide query --interactive) || exit 0
          [ -n "$result" ] && lf -remote "send $id cd '$result'"
      }}

      cmd fzf-jump ''${{
          result=$(fd --hidden --follow --exclude .git --exclude node_modules --exclude result --exclude target . \
            | fzf --reverse --prompt='jump> ' \
                --preview 'if [ -d {} ]; then eza -lah --icons --color=always {}; else bat --color=always --style=plain --theme=ansi --line-range=:80 {}; fi') || exit 0
          [ -z "$result" ] && exit 0
          if [ -d "$result" ]; then
              esc=$(printf '%s' "$result" | sed 's/\\/\\\\/g;s/"/\\"/g')
              lf -remote "send $id cd \"$esc\""
          else
              dir=$(dirname "$result")
              base=$(basename "$result")
              dir=$(printf '%s' "$dir" | sed 's/\\/\\\\/g;s/"/\\"/g')
              base=$(printf '%s' "$base" | sed 's/\\/\\\\/g;s/"/\\"/g')
              lf -remote "send $id cd \"$dir\""
              lf -remote "send $id select \"$base\""
          fi
      }}
      cmd fzf-edit ''${{
          result=$(fd --type f --hidden --follow --exclude .git --exclude node_modules --exclude result --exclude target . \
            | fzf --reverse --prompt='edit> ' \
                --preview 'bat --color=always --style=plain --theme=ansi --line-range=:80 {}') || exit 0
          [ -n "$result" ] && ''${EDITOR:-nvim} "$result"
      }}

      cmd fzf-grep ''${{
          result=$(
              fzf --disabled --ansi --reverse --prompt='rg> ' \
                --bind 'change:reload:rg --color=always --line-number --no-heading --smart-case --hidden --glob !.git --glob !node_modules {q} || true' \
                --delimiter : \
                --preview 'bat --color=always --style=plain --theme=ansi --highlight-line {2} {1}' \
                --preview-window 'up,60%,border-bottom,+{2}+3/3'
          ) || exit 0
          file=$(printf '%s' "$result" | cut -d: -f1)
          [ -n "$file" ] || exit 0
          dir=$(dirname "$file")
          base=$(basename "$file")
          lf -remote "send $id cd '$dir'"
          lf -remote "send $id select '$base'"
      }}

      cmd git-root ''${{
          root=$(git rev-parse --show-toplevel 2>/dev/null) || {
              lf -remote "send $id echoerr not a git repository"
              exit 0
          }
          lf -remote "send $id cd '$root'"
      }}

      cmd lazygit $lazygit
      cmd hunk $hunk diff -- "$f"
      cmd herdr $herdr
      cmd quicklook $qlmanage -p "$f" >/dev/null 2>&1
      cmd reveal $open -R "$f"
      cmd finder $open .
      cmd pager ''${{
          case "$f" in
              *.md|*.markdown|*.mdx|*.mkd|*.MD)
                  mdless "$f"
                  ;;
              *)
                  bat --paging=always --color=always --style=header,grid --theme=ansi "$f"
                  ;;
          esac
      }}
      cmd cheatsheet $bat --paging=always --color=always --style=plain --theme=ansi ${cheatsheet}

      # Always edit in nvim, including markdown (`l`/`enter` is the reader).
      map e $nvim $fx
    '';

    keybindings = {
      "<enter>" = "open";
      "<space>" = "toggle";
      "." = "set hidden!";
      D = "trash";
      "<delete>" = "trash";
      a = "push :mkdir<space>";
      A = "push :touch<space>";
      R = "bulk-rename";
      x = "extract";
      X = "$$f";
      Y = "copy-path";
      "<a-y>" = "copy-name";
      U = "!du -sh $fx";
      i = "pager";
      o = "&open \"$f\"";
      O = "quicklook";
      "?" = "cheatsheet";
      F = "filter";
      Z = "push :archive<space>";
      "+" = "%chmod +x $fx";
      "<c-t>" = "fzf-jump";

      gh = "cd ~";
      gn = "cd ~/nix";
      gd = "cd ~/Downloads";
      gD = "cd ~/Development";
      gc = "cd ~/.config";
      gt = "cd /tmp";
      gr = "git-root";
      go = "finder";
      gF = "reveal";
      gL = "follow";

      zh = "set hidden!";
      zp = "toggle-preview";
      zn = "set number!";
      zr = "set relativenumber!";
      zz = "zoxide";
      zf = "fzf-jump";
      ze = "fzf-edit";
      zg = "fzf-grep";

      gl = "lazygit";
      gk = "hunk";
      gw = "herdr";
      "<c-g>" = "lazygit";
      "<c-p>" = "hunk";
    };
  };

  # `lf` from the shell drops you in the last directory you were browsing.
  programs.zsh.initContent = lib.mkAfter ''
    lfcd() {
      local dir
      dir="$(command lf -print-last-dir "$@")" || return
      [[ -n "$dir" && -d "$dir" ]] && cd "$dir"
    }
    alias lf='lfcd'
  '';
}
