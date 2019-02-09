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

# added by Anaconda3 5.1.0 installer
export PATH="/Applications/anaconda3/bin:$PATH"

# if $isInteractive; then
# echo "--------------  .bash_profile ends  -------------"
# fi
