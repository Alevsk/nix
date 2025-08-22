{ config, pkgs, ... }:

let
  wallpaperUrl = "https://images.pexels.com/photos/1668246/pexels-photo-1668246.jpeg";
  wallpaperPath = "${config.home.homeDirectory}/.config/wallpaper/current-wallpaper.jpg";
in
{
  # Create wallpaper directory and download wallpaper
  home.file.".config/wallpaper/current-wallpaper.jpg" = {
    source = pkgs.fetchurl {
      url = wallpaperUrl;
      sha256 = "0ryv49kwi5fpg9zrxqqgr7p6zbp8ribw3m6gj2nlqc63gkag78m2";
    };
  };

  # Set wallpaper using activation script
  home.activation.setWallpaper = config.lib.dag.entryAfter ["writeBoundary"] ''
    # Set wallpaper for all desktops using osascript
    $DRY_RUN_CMD /usr/bin/osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"${wallpaperPath}\""
  '';
}
