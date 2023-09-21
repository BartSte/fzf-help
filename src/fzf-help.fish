set this_dir (dirname (realpath (status filename)))

##############################################################################
# fzf-help
#
# fzf-help-widget is a Fish shell function that should be bind to a key. It will open
# fzf with the help options and append the selected options to the command
# line.
##############################################################################
function fzf-help
  if test -z (commandline)
    return
  end
  set -l cmd (echo -n (commandline|string collect))
  set -l opts (echo -n (commandline|string collect)| $this_dir/fzf-select-option | tr "\n" " "|string collect)
  commandline -r -- $cmd$opts
  commandline -f repaint
  return $status
end
