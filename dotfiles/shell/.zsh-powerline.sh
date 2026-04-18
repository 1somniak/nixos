
autoload -Uz colors && colors

function ps1_powerline_zsh {
  local RETCODE=$?
  local GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

  # Couleurs (Zsh : %{...%} pour les séquences non imprimables)
  local MyOrange="%{$(tput setaf 215)%}"
  local MyGrey="%{$(tput setaf 8)%}"
  local MyBlue="%{$(tput setaf 33)%}"
  local MyYellow="%{$(tput setaf 223)%}"
  local Red="%{$(tput setaf 1)%}"
  local Reset="%{$(tput sgr0)%}"

  # Heure, utilisateur, dossier
  local time="%D{%H:%M}"
  local user="%n"
  local path="%~"

  # Détection si seul process interactif

  #local stat=$(ps -o stat= -p $$ 2>/dev/null)
  #local is_single_process=0
  #[[ "$stat" == 5 ]] && is_single_process=1
  #local DOLLAR
  #if (( is_single_process )); then
  #  DOLLAR=" → "
  #else
  #  DOLLAR="\$ "
  #fi
  DOLLAR=" → "

  if [[ -z "$GIT_BRANCH" ]]; then
    # Hors d'un dépôt git
    if [[ $RETCODE -eq 0 ]]; then
      PROMPT=$'\n'"${MyGrey}${time}${Reset} [${MyOrange}${user}${Reset} ${MyBlue}${path}${Reset}]${DOLLAR}"
    else
      PROMPT=$'\n'"${MyGrey}${time}${Reset} ${Red}❌${RETCODE}${Reset} [${MyOrange}${user}${Reset} ${MyBlue}${path}${Reset}]${DOLLAR}"
    fi
  else
    # Dans un dépôt git
    if [[ $RETCODE -eq 0 ]]; then
      PROMPT=$'\n'"${MyGrey}${time}${Reset} [${MyOrange}${user}${Reset} ${MyYellow} ${GIT_BRANCH}${Reset} ${MyBlue}${path}${Reset}]${DOLLAR}"
    else
      PROMPT=$'\n'"${MyGrey}${time}${Reset} ${Red}❌${RETCODE}${Reset} [${MyOrange}${user}${Reset} ${MyYellow} ${GIT_BRANCH}${Reset} ${MyBlue}${path}${Reset}]${DOLLAR}"
    fi
  fi
}

autoload -U add-zsh-hook
add-zsh-hook precmd ps1_powerline_zsh
