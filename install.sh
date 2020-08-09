#!/bin/sh
git config --global color.ui auto

GIT_NAME_CURRENT=$(git config --global user.name)
GIT_EMAIL_CURRENT=$(git config --global user.email)

printf "Git Name [$GIT_NAME_CURRENT]:"
read GIT_NAME_NEW

if [ "$GIT_NAME_NEW" != "" ]
then
	git config --global user.name "$GIT_NAME_NEW"
fi

printf "Git Email [$GIT_EMAIL_CURRENT]:"
read GIT_EMAIL_NEW

if [ "$GIT_EMAIL_NEW" != "" ]
then
	git config --global user.email "$GIT_EMAIL_NEW"
fi

printf "Update/Install Plugins? [Y/n]:"
read UPDATE_PLUGINS


DOTFILES_TMP="${HOME}/Projects/dotfiles"
XDG_CONFIG_HOME="${HOME}/.config"

mkdir -p ${XDG_CONFIG_HOME}

if [ ! -d $DOTFILES_TMP ]
then
     #Now clone the repo...
     git clone https://github.com/skatzteyp/dotfiles.git $DOTFILES_TMP && cd $DOTFILES_TMP
else
     cd $DOTFILES_TMP && git fetch
fi

# Check if we have  ~/.vimrc.d
if [ -d ~/.vimrc.d ]
then
	# Remove the OLD .vimrc.d/ DIR from home DIR
	rm -r ~/.vimrc.d
fi

# Copy the .vimrc.d/ DIR to home DIR
cp -r $DOTFILES_TMP/.vimrc.d ~/

# Check if our plugin manager is installed
if [ ! -f ~/.vim/autoload/plug.vim ]
then
	# Install our plugin manager
	printf "Installing our plugin manager\n"
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# Setup the vimrc for temporary use!
echo "source ~/.vimrc.d/vimplug.vim" > ~/.vimrc

# Make some symlinks...
if [ ! -h $XDG_CONFIG_HOME/nvim ]
then
	ln -s ~/.vim $XDG_CONFIG_HOME/nvim
fi

# Make some symlinks...
if [ ! -h $XDG_CONFIG_HOME/nvim/init.vim ]
then
	ln -s ~/.vimrc $XDG_CONFIG_HOME/nvim/init.vim
fi

# Check if we even want to install/update plugins
if [ "$UPDATE_PLUGINS" != "n" ]
then
	# Install Vim Plugins
	printf "Installing Vim Plugins, Will take a while depending on connection speed!\n"
	vim +PlugUpgrade +PlugClean! +PlugUpdate +qall
fi

# Copy all our custom files!
cat $DOTFILES_TMP/.bash_profile > ~/.bash_profile
cat $DOTFILES_TMP/.bashrc       > ~/.bashrc
cat $DOTFILES_TMP/.zsh_profile  > ~/.zsh_profile
cat $DOTFILES_TMP/.zshrc        > ~/.zshrc
cat $DOTFILES_TMP/.shrc         > ~/.shrc
cat $DOTFILES_TMP/.vimrc        > ~/.vimrc
cat $DOTFILES_TMP/.tmux.conf    > ~/.tmux.conf

# Check if we have promptline setup already
if [ -d ~/.vim/plugged/promptline.vim ]
then
	# Setup Promptline!
	vim +"PromptlineSnapshot! ~/.promptline.sh" +qall
fi

# Check if we have tmuxline setup already
if [ -d ~/.vim/plugged/tmuxline.vim ]
then
	# Setup Promptline!
	vim +Tmuxline +"TmuxlineSnapshot! ~/.tmuxline.conf" +qall
fi

if [ ! -d ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]
then
   git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
fi


# Install done! WEW!
printf "Install DONE! WEW!\n"
