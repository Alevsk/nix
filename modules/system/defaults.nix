{ pkgs, ... }:

{
  # macOS defaults consolidated (Dock + general UI)

  # Dock
  system.defaults.dock.autohide = false;
  system.defaults.dock.persistent-apps = [
    "/System/Applications/Launchpad.app"
    "${pkgs.alacritty}/Applications/Alacritty.app"
    "${pkgs.telegram-desktop}/Applications/Telegram.app"
    "${pkgs.windsurf}/Applications/Windsurf.app"
    "/Applications/1Password.app"
    "${pkgs.google-chrome}/Applications/Google Chrome.app"
    "/Applications/Sublime\ Text.app"
    "/Applications/Neo4j\ Desktop\ 2.app"
    "/System/Applications/System\ Settings.app"
  ];
  system.defaults.dock = {
    show-process-indicators = true;
    show-recents = false;
    static-only = false;
  };

  # UI
  system.defaults.finder.FXPreferredViewStyle = "clmv";
  system.defaults.loginwindow.GuestEnabled = false;
  system.defaults.NSGlobalDomain.AppleInterfaceStyle = "Dark";
  system.defaults.NSGlobalDomain.KeyRepeat = 2;
}

