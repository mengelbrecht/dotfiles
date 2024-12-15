dotfiles
========

## Installation

```shell
git clone https://github.com/mengelbrecht/dotfiles.git "${HOME}/.dotfiles" && \
  ln -s "${HOME}/.dotfiles/config" "${HOME}/.config" && \
  ln -s "${HOME}/.config/nvim" "${HOME}/.vim" && \
  touch "${HOME}/.config/fish/local.fish" && \
  touch "${HOME}/.config/git/local.gitconfig"
```

## Thanks to

- [sorin-ionescu/prezto](https://github.com/sorin-ionescu/prezto)
- [wincent/wincent](https://github.com/wincent/wincent)
- [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles)

## License

Released under the [MIT License](LICENSE)
