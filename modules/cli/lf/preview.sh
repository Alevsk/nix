# lf previewer. Invoked as: preview file width height x y [mode]
# Relies on PATH/BAT_THEME being set by the Nix wrapper.

file=$1
width=${2:-80}
height=${3:-24}

[ -n "$file" ] || exit 0
[ -e "$file" ] || exit 0

bat_preview() {
  bat --color=always --style=plain --paging=never \
    --theme="${BAT_THEME:-ansi}" \
    --terminal-width="$width" \
    --line-range=":${height}" \
    "$@" 2>/dev/null
}

list_dir() {
  eza -lah --icons --group-directories-first --git --color=always --no-quotes "$1" 2>/dev/null \
    | head -n "$height"
}

if [ -d "$file" ]; then
  list_dir "$file"
  if git -C "$file" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    printf '\n'
    git -C "$file" -c color.status=always status -sb --ignored=no 2>/dev/null | head -n 16
  fi
  exit 0
fi

mime=$(file --mime-type -Lb "$file" 2>/dev/null) || mime="application/octet-stream"
ext=$(printf '%s' "$file" | tr '[:upper:]' '[:lower:]')
ext=${ext##*.}

case "$mime" in
  image/*)
    chafa --format symbols --animate off --size "${width}x${height}" "$file" 2>/dev/null \
      && exit 0
    identify -format '%f\n%m %wx%h %b\n' "$file" 2>/dev/null
    exit 0
    ;;
  video/*)
    ffmpeg -nostdin -hide_banner -loglevel error -ss 00:00:02 \
      -i "$file" -frames:v 1 -an -f image2pipe -vcodec png - 2>/dev/null \
      | chafa --format symbols --animate off --size "${width}x${height}" - 2>/dev/null \
      && exit 0
    ffmpeg -nostdin -hide_banner -i "$file" 2>&1 | sed -n 's/^/ /p' | head -n "$height"
    exit 0
    ;;
  audio/*)
    ffmpeg -nostdin -hide_banner -i "$file" 2>&1 | sed -n 's/^/ /p' | head -n "$height"
    exit 0
    ;;
  application/pdf)
    pdftotext -l 8 -nopgbrk -q "$file" - 2>/dev/null | head -n "$height"
    exit 0
    ;;
  application/json)
    jq -C . "$file" 2>/dev/null | head -n "$height" && exit 0
    bat_preview -l json "$file"
    exit 0
    ;;
esac

case "$ext" in
  7z|zip|rar|jar)
    7z l "$file" 2>/dev/null | head -n "$height" && exit 0
    unzip -l "$file" 2>/dev/null | head -n "$height"
    exit 0
    ;;
  tar)
    tar tf "$file" 2>/dev/null | head -n "$height"
    exit 0
    ;;
  tgz|tbz|tbz2|txz)
    tar tf "$file" 2>/dev/null | head -n "$height"
    exit 0
    ;;
  gz|bz2|xz|zst)
    tar tf "$file" 2>/dev/null | head -n "$height" && exit 0
    file "$file"
    exit 0
    ;;
  md|markdown|mdx|mkd)
    # mdless is mdcat in pager mode; -P dumps formatted markdown into the pane.
    mdless -P --local --columns "$width" "$file" 2>/dev/null | head -n "$height" && exit 0
    mdcat --columns "$width" "$file" 2>/dev/null | head -n "$height" && exit 0
    bat_preview -l markdown "$file"
    exit 0
    ;;
  yml|yaml)
    yq -C . "$file" 2>/dev/null | head -n "$height" && exit 0
    bat_preview -l yaml "$file"
    exit 0
    ;;
  toml)
    bat_preview -l toml "$file"
    exit 0
    ;;
  nix)
    bat_preview -l nix "$file"
    exit 0
    ;;
  svg)
    chafa --format symbols --animate off --size "${width}x${height}" "$file" 2>/dev/null \
      && exit 0
    bat_preview -l xml "$file"
    exit 0
    ;;
esac

case "$mime" in
  text/*|application/javascript|application/xml|application/x-sh|application/x-shellscript|application/toml|inode/x-empty|application/x-empty)
    bat_preview "$file"
    exit 0
    ;;
esac

# Last resort: bat if it looks like text, otherwise file(1) metadata.
if file "$file" 2>/dev/null | grep -qi 'text'; then
  bat_preview "$file"
  exit 0
fi

file "$file" 2>/dev/null
printf '\n'
# Small hex dump so binaries are not a blank pane.
dd if="$file" bs=256 count=1 2>/dev/null | hexdump -C 2>/dev/null | head -n 16
exit 0
