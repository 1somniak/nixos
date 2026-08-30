{ ... }:

{
  programs.firefox.enable = true;
  programs.dconf.enable = true;

  programs.git = {
    enable = true;
    config = {
      safe = {
        directory = "/etc/nixos";
      };
    };
  };
}