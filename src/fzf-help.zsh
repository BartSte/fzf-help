this_dir=$(dirname $(realpath ${BASH_SOURCE:-$0}))

fzf-help-widget() {
    [[ -z $BUFFER ]] && { zle reset-prompt; return }
    local option=$(echo $BUFFER | $this_dir/fzf-select-option)
    LBUFFER="$BUFFER$option"
    local ret=$?
    zle reset-prompt
    return $ret
}
