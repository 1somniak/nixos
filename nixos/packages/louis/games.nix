{ pkgs, ... }:

{
  users.users.louis.packages = with pkgs; [
    openttd
    foundry
    mari0
  ];
}
