this_dir=$(dirname $(realpath ${BASH_SOURCE:-$0}))

##############################################################################
# fzf-help-widget
#
# fzf-help-widget is a bash widget that should be bind to a key. It will open
# fzf with the help options and append the selected options to the command 
# line.
##############################################################################
fzf-help-widget() {
    [[ -z $READLINE_LINE ]] && { return; }

    local opts=$(echo $READLINE_LINE | $this_dir/fzf-select-option | tr "\n" " ")
    READLINE_LINE="$READLINE_LINE$opts"
    READLINE_POINT=${#READLINE_LINE}

    local ret=$?
    return $ret
}

