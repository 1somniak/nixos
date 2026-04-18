{ ... }:

{
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;

    enableCompletion = true;
    autosuggestion.enable = false; # afficher les suggestions de commandes précédentes grisées
    syntaxHighlighting.enable = false; # coloration

    history = {
      size = 10000;
      save = 10000;
      path = "$HOME/.zsh_history";
      share = true;
      ignoreDups = true;
      ignoreSpace = true;
    };

    shellAliases = {
      ll = "ls -alh";
      la = "ls -A";
      l = "ls -CF";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
    };

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" "zoxide" ];
    };

    initContent = ''
      bindkey '^[[3~' delete-char
      [[ -f "$HOME/.zsh-powerline.sh" ]] && source "$HOME/.zsh-powerline.sh"
    '';
  };
}