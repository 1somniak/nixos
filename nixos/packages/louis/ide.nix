{ pkgs, inputs, ... }:

let
  vscode-nosandbox = pkgs.writeShellScriptBin "code" ''
    exec ${pkgs.vscode}/bin/code --no-sandbox "$@"
  '';
in
{
  users.users.louis.packages = with pkgs; [
    vscode-nosandbox # vscode-fhs but with --no-sandbox (to avoid "no new privileges" flag is set)
    #jetbrains.idea
    #zed-editor
    antigravity
  ];
}
