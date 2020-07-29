if [[ $- == *i* ]]; then
    isInteractive=true
else
    isInteractive=false
fi

# if $isInteractive; then
#    echo "----------------  .bash_profile  ----------------"
# fi

case `uname -s` in
    CYGWIN*)
        export SHELL_TYPE=CYGWIN
        ;;
    Darwin)
        if [ "${TERM_PROGRAM:-(none)}" = "iTerm.app" ]; then
            export SHELL_TYPE="Darwin-iTerm"
        else
    	    export SHELL_TYPE=Darwin
        fi
	;;
    *)
        export SHELL_TYPE=OTHER
        ;;
esac

[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

# [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

if [ "${SHELL_TYPE:-}" = "Darwin-iTerm" ]; then
   test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
fi

# if $isInteractive; then
# echo "--------------  .bash_profile ends  -------------"
# fi

##
# Your previous /Users/john/.bash_profile file was backed up as /Users/john/.bash_profile.macports-saved_2019-04-12_at_20:17:29
##

# MacPorts Installer addition on 2019-04-12_at_20:17:29: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/john/opt/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/john/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/john/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/john/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

