# My Dotfiles

My configurations and plugins for vim.

Why? The old one was forked from mxaddict/dotfiles and I wanted to have my own.

## Installation

- Install [iTerm2](https://www.iterm2.com/). 
- Apply included theme `One Dark.itermcolors` in your iTerm2.
- Install homebrew. `$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)”`
- Install neovim, tmux, reattach-to-user-namespace. `$ brew install neovim tmux reattach-to-user-namespace`
- Install [Powerline fonts](http://github.com/powerline/fonts).
- Run `$ sh <(curl -sL https://raw.githubusercontent.com/skatzteyp/dotfiles/master/install.sh)`

Note: Only tested using Mac 10.15.6.

## Additional Notes

- Add this to your coc config (:CocConfig) for autosave.
```
{
    "coc.preferences.formatOnSaveFiletypes": [
        "dart"
    ]
}
```
