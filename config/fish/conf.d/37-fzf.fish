set -gx FZF_DEFAULT_COMMAND 'fd --type f --strip-cwd-prefix'
set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
set -gx FZF_DEFAULT_OPTS '--cycle --layout=reverse --border --color=dark,fg:-1,bg:-1,hl:#c678dd,fg+:#ffffff,bg+:#4b5263,hl+:#d858fe,info:#98c379,prompt:#61afef,pointer:#be5046,marker:#e5c07b,spinner:#61afef,header:#61afef'

if test -f "$homebrew/opt/fzf/shell/key-bindings.fish"
  source "$homebrew/opt/fzf/shell/key-bindings.fish"
  fzf_key_bindings
end
