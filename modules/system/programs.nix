{ ... }:

{
  # Enable alternative shell support in nix-darwin and GnuPG agent
  programs = {
    gnupg.agent.enable = true;
    zsh.enable = true;  # default shell on macOS
  };
}

