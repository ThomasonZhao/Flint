# Install vimplug
curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install plugins
vim -c ':PlugInstall' \
    -c ':q!' \
    -c ':q!'

# Install dependency of YouCompleteMe
sudo apt install mono-complete golang nodejs default-jdk npm -y
python3 ~/.vim/plugged/youcompleteme/install.py --all

cp ./.vimrc ~/.vimrc