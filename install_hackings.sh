# Common python hacking libs
pip3 install \
    angr \
    pwntools \
    ropper \
    numpy \
    scapy \
    ipython \
    pycryptodome

# Install docker
curl -fsSL https://get.docker.com | sh
sudo groupadd docker
sudo usermod -aG docker $USER
sudo usermod -aG $USER $USER