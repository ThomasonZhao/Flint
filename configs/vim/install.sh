cp ./.vimrc ~/.vimrc

# Install vimplug
curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install plugins
vim -c ':PlugInstall' \
    -c ':q!' \
    -c ':q!'

# Install dependency of YouCompleteMe
sudo apt install build-essential cmake vim-nox python3-dev
sudo apt install mono-complete golang nodejs default-jdk npm
(cd ~/.vim/bundle/YouCompleteMe && python3 install.py --all)