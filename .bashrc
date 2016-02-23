####################################################################################
###   				 CONFIGURATION                                               ###
####################################################################################

# Si ce n'est pas exécuté de manière interactive, ne font rien
[ -z "$PS1" ] && return
# Ne pas mettre en double dans l'historique les commandes tapées 2x
export HISTCONTROL=ignoredups:ignorespace
# Lignes de l'historique par session bash
export HISTSIZE=5000
# Lignes de l'historique conservées
export HISTFILESIZE=20000
# Supporte des terminaux redimensionnables (xterm et screen -r)
shopt -s checkwinsize
# Mes exports
export EDITOR=vim
export VISUAL=vim
# Activation date_heure dans la commande history
export HISTTIMEFORMAT="%d/%m/%Y - %T : "
# Les pages de man en couleur, nécessite le paquet "most"
export PAGER=most
export BROWSER=firefox
export LC_ALL=fr_FR.utf8
export OS=$(uname)
# Definie le shell par défaut
export SHELL="$( which bash)"
# Definie le l'adresse E-mail
export MAIL="ti.wissam@gmail.com"
# Rend l’auto-complétion insensible à la casse 
set completion-ignore-case on
# Avertir lorsque des jobs en cours d'exécution en arrière-plan se termine
set -o notify                                  
# set tmpfile
export TMP="${HOME}/tmp"

###################################################################################
# Affichage du prompt
# Commentez la ligne en fonction de la couleur
# Vert (pour les utilisateurs normaux)
# PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
# Rouge (pour l'utilisateur root)
# PS1='\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#Encore une autre couleur
export PS1='\[\033]0;\h:\w\007\]\[\033[01;32m\]\u@\h \[\033[01;34m\]\w \$ \[\033[00m\]' 
#set a fancy prompt (non-color, unless we know we "want" color)
#PS1="\[\033[01;31m\][\u@\h\[\033[00m\]:\[\033[01;34m\]\w]\[\033[00m\]\$ "
##############################################################################
# 	PATH SETTINGS:
##############################################################################
PATH='/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin'
### Script d'extraction de fichiers compréssé. "ex package.tar.bz2"
ex() {
   if [[ -f $1 ]]; then
	   case $1 in
		   *.tar.bz2)   tar xjf $1  ;;
		   *.tar.gz)    tar xzf $1  ;;
		   *.bz2)       bunzip2 $1  ;;
		   *.rar)       rar x $1    ;;
		   *.gz)        gunzip $1   ;;
			   *.tar)       tar xf $1   ;;
		   *.tbz2)      tar xjf $1  ;;
		   *.tgz)       tar xzf $1  ;;
		   *.zip)       unzip $1    ;;
		   *.Z)         uncompress $1  ;;
		   *.7z)        7z x $1     ;;
		   *)           echo $1 Extraction impossible ;;
	   esac
   else
	   echo $1 Fichier invalide
   fi
}
     
# Autocompletition des commandes executé en ssh
complete -W "$(echo `cat ~/.bash_history | egrep '^ssh ' | sort | uniq | sed 's/^ssh //'`;)" ssh


################################################################################
###    BASH COMPLETION                                                       ###
################################################################################

# Meilleure completion du bash
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
	. /etc/bash_completion
fi

###############################################################################
###  	  ALIAS                                                             ###
###############################################################################

alias ls='ls -h --color --group-directories-first'      # la couleur pour chaque type de fichier, les répertoires s'affichent en premier
alias lsa='ls -A'       # affiche les fichiers cachés
alias ll='ls -l'        # affiche en mode liste détail
alias lla='ls -Al'      # affiche en mode liste détail + fichiers cachés
alias lx='ls -lXB'      # tri par extension
alias lk='ls -lSr'      # tri par taille, le plus lourd à la fin
alias lc='ls -ltcr'     # tri par date de modification, la pus récente à la fin
alias lu='ls -ltur'     # tri par date d’accès, la pus récente à la fin
alias lt='ls -ltr'      # tri par date, la pus récente à la fin
alias lm='ls -al | more'        # Pipe a travers 'more'
alias lr='ls -lR'       # ls récurssif
alias tree='tree -Csu'  # affciche sous forme d'arborescence, nécessite le paquet "tree"
alias voirlog='tail -f' # affiche les dernière d'un fichier log (par exemple) en live
alias df='df -kTh'      # commande df avec l'option -human
alias du='du -kh'       # commande du avec l'option -human
alias du1='du -kh --max-depth=1'        # commande du avec l'option -human, au niveau du répertoire courant
alias dusort='du -x --block-size=1048576 | sort -nr' # Tri par taille
alias free='free -m'    # commande free avec l'option affichage en Mo
alias rm='rm -i'        # confirmation si écrasement de fichiers lors de renommage d'un fichier
alias cp='cp -i'        # confirmation si écrasement de fichiers lors de copie de fichier
alias mv='mv -i'                # confirmation si écrasement de fichiers lors de déplacement de fichier
alias top='htop'                # nécessite le paquet "htop", un top amélioré et en couleur
alias shistory='history | grep '        # faire une recherche dans l'historique de commande
alias h='history'              # raccourci history
alias mkdir='mkdir -p'  # pour éviter l'écrasement lors de création de dossier
alias ..='cd ..'        # raccourci répertoire parent
alias path='echo -e ${PATH//:/\\n}'     # affiche le path des exec
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'       # affiche le path des lib
alias vi='vim'  # la commande vi en couleurs (http://www.taltan.fr/post/2006/10/29/47-coloration-syntaxique-dans-vi)
alias c='clear' # raccourci commande clear
alias ping='ping -c 4'    # raccourci commande ping avec 4 occurrences 
alias saidar='sudo saidar -c -d 1'
alias calendrier='var=$(cal); echo "${var/$(date +%-d)/$(echo -e "\033[1;31m$(date +%-d)\033[0m")}"'
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias upd="sudo apt-get update"
alias upg="sudo apt-get upgrade"
alias ins="sudo apt-get install"
alias rem="sudo apt-get purge"
alias fix="sudo apt-get install -f"
alias maj='sudo apt-get update && sudo apt-get upgrade && sudo apt-get dist-upgrade && sudo  apt-get autoclean && sudo apt-get clean && sudo apt-get autoremove'

### Add more colors
[[ -x /usr/bin/dircolors ]] && {
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
alias ls="ls --color=auto"
alias dir="dir --color=auto"
alias vdir="vdir --color=auto"
alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"
}
############################################################################
###    LEUK                                                              ###
############################################################################
# echo birthday
[ "$(date | cut -d ' ' -f 2,3)" == "Mar 30" ] && echo "Joyeux anniversaire !"

# greeting
hour=$(date +"%H")
if [ $hour -ge 0 -a $hour -lt 18 ]
then
echo "'####::'######::'##:::'##::::'########:'########::::'###::::'##::::'##:"
echo ". ##::'##... ##: ##::'##:::::... ##..:: ##.....::::'## ##::: ###::'###:"
echo ": ##:: ##:::..:: ##:'##::::::::: ##:::: ##::::::::'##:. ##:: ####'####:"
echo ": ##::. ######:: #####:::::::::: ##:::: ######:::'##:::. ##: ## ### ##:"
echo ": ##:::..... ##: ##. ##::::::::: ##:::: ##...:::: #########: ##. #: ##:"
echo ": ##::'##::: ##: ##:. ##:::::::: ##:::: ##::::::: ##.... ##: ##:.:: ##:"
echo "'####:. ######:: ##::. ##::::::: ##:::: ########: ##:::: ##: ##:::: ##:"
echo "....:::......:::..::::..::::::::..:::::........::..:::::..::..:::::..::"
echo "                                                        BY SULFUR      "

	greet="Bonjour, $USER.\n"
else
echo "'####::'######::'##:::'##::::'########:'########::::'###::::'##::::'##:"
echo ". ##::'##... ##: ##::'##:::::... ##..:: ##.....::::'## ##::: ###::'###:"
echo ": ##:: ##:::..:: ##:'##::::::::: ##:::: ##::::::::'##:. ##:: ####'####:"
echo ": ##::. ######:: #####:::::::::: ##:::: ######:::'##:::. ##: ## ### ##:"
echo ": ##:::..... ##: ##. ##::::::::: ##:::: ##...:::: #########: ##. #: ##:"
echo ": ##::'##::: ##: ##:. ##:::::::: ##:::: ##::::::: ##.... ##: ##:.:: ##:"
echo "'####:. ######:: ##::. ##::::::: ##:::: ########: ##:::: ##: ##:::: ##:"
echo "....:::......:::..::::..::::::::..:::::........::..:::::..::..:::::..::"
echo "                                                        BY SULFUR      "

    greet="Bonsoir, $USER..\n"
fi
echo -e "${greet}"
