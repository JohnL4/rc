# Setup fzf
# ---------
if [[ ! "$PATH" == */home/john/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/john/.fzf/bin"
fi

eval "$(fzf --bash)"
