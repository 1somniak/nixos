{ pkgs, ... }:

{
  users.users.louis = {
    isNormalUser = true;
    description = "louis";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
  };

  security.sudo.extraRules = [
    {
      users = [ "louis" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/nixos-rebuild switch --flake /etc/nixos";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/systemd-run --property=CPUQuota=200% --property=MemoryMax=2G /run/current-system/sw/bin/nixos-rebuild switch --flake /etc/nixos";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}
