{ pkgs, ... }:

{
  users.users.louis.packages = with pkgs; [
    # reverse tools
    file
    ghidra
    wineWow64Packages.stable

    # network tools
    inetutils
    nmap
    wireguard-tools
  ];
}
