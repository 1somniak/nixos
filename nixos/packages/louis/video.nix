{ pkgs, ... }:

{
  users.users.louis.packages = with pkgs; [
    vlc
    ffmpeg
  ];
}
