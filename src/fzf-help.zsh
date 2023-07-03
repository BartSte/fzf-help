this_dir=$(dirname $(realpath ${BASH_SOURCE:-$0}))

##############################################################################
# fzf-help-widget
#
# fzf-help-widget is a zsh widget that should be bind to a key. It will open
# fzf with the help options and append the selected options to the command 
# line.
##############################################################################
fzf-help-widget() {
    [[ -z $BUFFER ]] && { zle reset-prompt; return }

    local opts=$(echo $BUFFER | $this_dir/fzf-select-option | tr "\n" " ")
    BUFFER="$BUFFER$opts"

    local ret=$?
    zle reset-prompt
    zle end-of-line
    return $ret
}
