# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./packages/default.nix
      ./modules/default.nix
    ];

  # Ne change pas cette version
  system.stateVersion = "24.11"; 
}
