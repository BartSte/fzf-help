set _fzf_help_directory (dirname (realpath (status filename)))

##############################################################################
# fzf-help-widget
#
# fzf-help-widget is a Fish shell function that should be bind to a key. It will open
# fzf with the help options and append the selected options to the command
# line.
##############################################################################
function fzf-help-widget
  if test -z (commandline)
    return
  end
  set -l cmd (commandline|string collect)
  set -l opts (printf '%s\n' "$cmd" | $_fzf_help_directory/fzf-select-option)
  set -l selector_status $status
  if test "$selector_status" -ne 0
    commandline -f repaint
    return $selector_status
  end
  set opts (string join ' ' -- $opts)
  commandline -r -- $cmd$opts
  commandline -f repaint
  return 0
end
