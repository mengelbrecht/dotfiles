set -gx FZF_DEFAULT_COMMAND 'fd --type f --strip-cwd-prefix'
set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
set -gx FZF_DEFAULT_OPTS '--cycle --layout=reverse --border'

if test -f "$homebrew/opt/fzf/shell/key-bindings.fish"
  source "$homebrew/opt/fzf/shell/key-bindings.fish"
  fzf_key_bindings
end
