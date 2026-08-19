_fzf_help_directory=$(dirname "$(realpath "${BASH_SOURCE:-$0}")")

##############################################################################
# fzf-help-widget
#
# fzf-help-widget is a bash widget that should be bind to a key. It will open
# fzf with the help options and append the selected options to the command 
# line.
##############################################################################
fzf-help-widget() {
    [[ -z $READLINE_LINE ]] && { return; }

    local opts ret
    if opts=$(printf '%s\n' "$READLINE_LINE" | "$_fzf_help_directory/fzf-select-option"); then
        :
    else
        ret=$?
        return "$ret"
    fi

    opts=$(tr '\n' ' ' <<<"$opts")
    READLINE_LINE="$READLINE_LINE$opts"
    READLINE_POINT=${#READLINE_LINE}

    return 0
}
