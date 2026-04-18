{ pkgs, ... }:

{
  users.users.louis = {
    isNormalUser = true;
    description = "louis";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
  };
}
