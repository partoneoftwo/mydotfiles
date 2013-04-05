# my own Zsh config
# uses Oh-My-Zsh framework
# and other zsh configuration options

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="random"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how many often would you like to wait before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git debian history screen battery cp)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games

####
# ZSH General functions
####
# Mandelbrot pattern generation
# Displays floating point abilites of zsh
function most_useless_use_of_zsh {
  local lines columns colour a b p q i pnew
    ((columns=COLUMNS-1, lines=LINES-1, colour=0))
      for ((b=-1.5; b<=1.5; b+=3.0/lines)) do
      for ((a=-2.0; a<=1; a+=3.0/columns)) do
      for ((p=0.0, q=0.0, i=0; p*p+q*q < 4 && i < 32; i++)) do
              ((pnew=p*p-q*q+a, q=2*p*q+b, p=pnew))
	            done
		          ((colour=(i/4)%8))
			        echo -n "\\e[4${colour}m "
				    done
				    echo
				    done
				    }
				    
				    function pmstat {
				      ps auxm | awk '{ print "\033[1;31m"$2"\033[0m\t""\033[1;32m"$6/1024" MB\033[0m\t"; for (i=11; i<=NF; i++) printf("%s%s", $i, (i==NF) ? "\n" : OFS) }' \ | awk '{ if ( ( NR % 2 ) == 0 ) { printf("%s\n",$0) } else {
printf("%s ",$0) } }' \
| awk '{ print ( (NR==1) ? "\033[1;34mPID\tSIZE\t\t COMMAND" : $0 )
}' | less -mR
}

function pcstat {
  ps auxr | awk '{ print
"\033[1;31m"$2"\033[0m\t""\033[1;32m"$3"%\033[0m\t";
for (i=11; i<=NF; i++) printf("%s%s", $i, (i==NF) ? "\n" : OFS) }' \
  | awk '{ if ( ( NR % 2 ) == 0 ) { printf("%s\n",$0) } else {
printf("%s ",$0) } }' \
  | awk '{ print ( (NR==1) ? "\033[1;34mPID\tLOAD\t COMMAND" : $0 ) }' | less -mR
}

function wiki {
  dig +short txt $1.wp.dg.cx
  }
  
  #####
  # Set colors for man pages.
  man() {
    env \
        LESS_TERMCAP_mb=$(printf "\e[1;37m") \
	    LESS_TERMCAP_md=$(printf "\e[1;37m") \
	        LESS_TERMCAP_me=$(printf "\e[0m") \
		    LESS_TERMCAP_se=$(printf "\e[0m") \
		        LESS_TERMCAP_so=$(printf "\e[1;47;30m") \
			    LESS_TERMCAP_ue=$(printf "\e[0m") \
			        LESS_TERMCAP_us=$(printf "\e[0;36m") \
				    man "$@"
				    }
				    
				    # Display series of dots during completion
				    expand-or-complete-with-dots() {
				      echo -n "\e[31m......\e[0m"
				        zle expand-or-complete
					  zle redisplay
					  }
					  zle -N expand-or-complete-with-dots
					  bindkey "^I" expand-or-complete-with-dots
# Alt+S inserts sudo at beginning of line insert_sudo () { zle beginning-of-line; zle -U "sudo " } zle -N insert-sudo insert_sudo
bindkey "^[s" insert-sudo

####
# Completion
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path ~/.zsh/cache/$HOST

# Precede different sections in various completions with headers.
# IE: ssh is separated into "remote host name" and "login name"
zstyle ':completion:*' group-name "${(@):-}"

# allow approximate
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

## tab completion for PID :D
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

# Autocompletion of hosts, based on ssh known_hosts and config files
zstyle ':completion:*:ssh:*' group-order 'users' 'hosts'

# Set up colors, prompts, and messages
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' max-errors 2
zstyle ':completion:*' prompt 'Found %e errors:'
zstyle :compinstall filename $HOME/.zshcompl

# insert all expansions for expand completer
zstyle ':completion:*:expand:*' tag-order all-expansions

# formatting and messages
zstyle ':completion:*' verbose yes
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*:descriptions' format '%F{red}%U%B%d%b%u%f'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' separate-sections 'yes'

# case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Separate man page sections. Neat.
zstyle ':completion:*:manuals' separate-sections true

# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# command for process lists, the local web server details and host completion
zstyle ':completion:*:processes' command 'ps -o pid,s,nice,stime,args'
zstyle ':completion:*:processes-names' command 'ps axho command'
zstyle ':completion:*:urls' local 'www' '/var/www/htdocs' 'public_html'
# zstyle '*' hosts $hosts

# color code completion
zstyle ':completion:*' list-colors "=(#b) #([0-9]#)*=36=31"

# Enable oh-my-zsh agent-forwarding
zstyle :omz:plugins:ssh-agent agent-forwarding on

# Quickly show disk usage in current directory
alias duf='du -kd1 | sort -n | perl -ne '\''($s,$f)=split(m{\t});for
(qw(K M G)) {if($s<1024) {printf("%.1f",$s);print "$_\t$f";
last};$s=$s/1024}'\'

# Git aliases
alias gam='git commit -a -m'
alias gap='git add -p'
alias gcl='git clone'
alias gd='git diff'
alias grep='grep --color=always'
alias gvim='gvim -f -geom 100x45'

# ANSI color for less, always
alias less='less -mR'
alias lltag='lltag --id3v2'

# Overwrite oh-my-zsh's lsa behavior (remove the -l flag)
alias lsa='ls -ah'

# Show only directories
alias lsd='ls -d */'

# Show only files, sorted by size
# WHY?
alias lss='ls -aSh *(.)'
alias larsh="ls -larSh"
# okat stuff
alias mkdir='mkdir -p'
alias mpg123='mpg123 -v -C'
alias perldoc='perldoc -t'
alias pgrep='nocorrect pgrep -ifL'
alias pkill='nocorrect pkill'
alias ri='ri -f ansi'
alias scp='scp -r'


# Make GNU fileutils more verbose
for c in cp mv chmod chown rename rm; do
alias $c="$c -v"
done

# List all executable files in PATH
alias pathexec="print -l ${^path}/*(-*N) | less"

alias tmux="tmux -u attach"

# Always compress & encrypt ssh
alias ssh="ssh -Cc arcfour,blowfish-cbc"

# Mount home drives
# can be used as a template for own drives
#alias commiebastard="mkdir /Volumes/commiebastard 2> /dev/null; sshfs threv@threv.crabdance.com:/home/threv /Volumes/commiebastard -oreconnect,volname=commiebastard"
#alias elements="mkdir /Volumes/Elements 2> /dev/null; sshfs threv@threv.crabdance.com:/media/threv/Elements /Volumes/Elements -oreconnect,volname=Elements"

# SOCKS proxy to home server
#
# must research this
#
# NOTE: Must disable HTTP/HTTPS proxy first
#alias socks="ssh -D 8888 -fN threv.crabdance.com"

####
# bindkey
# Esc = undo
bindkey "^[" undo

# Pipe the current command through less
bindkey -s "\el" " 2>&1|less^M"

# Editor = vim
# Update this when macvim updates
export EDITOR=/usr/bin/jed

# Sets ANSI color for man pages, and the pager in general. Also ensures % display on bottom.
export PAGER=most

# For fontforge
export PYTHONPATH=/usr/local/lib/python2.7/site-packages

export HISTSIZE=90000
export SAVEHIST=90000

# MySQL Prompt
export MYSQL_PS1="\\d> "

####
# setopt
setopt glob
setopt globdots
setopt pushdminus
# If you really do want to clobber a file, you can use the >! operator. To make things easier in this case, the > is stored in the history list as a >!
setopt noclobber
# Pipe to multiple outputs
setopt multios

unsetopt hist_verify
unsetopt share_history
# unsetopt correctall

####
# zsh modules
# Load command-line math
zmodload zsh/mathfunc

# Load zsh raw socket & packet handling
zmodload zsh/net/socket
zmodload zsh/zftp

# Load zsh builtin functions
autoload -U zargs zmv zcalc tcp_open


# Commands below here are run on every login session
# Print a fortune on every login window
# fortune | cowsay