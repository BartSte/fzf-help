_fzf_help_directory=$(dirname "$(realpath "${BASH_SOURCE:-$0}")")

##############################################################################
# fzf-help-widget
#
# fzf-help-widget is a zsh widget that should be bind to a key. It will open
# fzf with the help options and append the selected options to the command 
# line.
##############################################################################
fzf-help-widget() {
    [[ -z $BUFFER ]] && { zle reset-prompt; return }

    local opts ret
    if opts=$(printf '%s\n' "$BUFFER" | "$_fzf_help_directory/fzf-select-option"); then
        :
    else
        ret=$?
        zle reset-prompt
        zle end-of-line
        return "$ret"
    fi

    opts=$(tr '\n' ' ' <<<"$opts")
    BUFFER="$BUFFER$opts"

    zle reset-prompt
    zle end-of-line
    return 0
}
