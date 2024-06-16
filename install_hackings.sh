# Common python hacking libs
pip install \
    angr \
    pwntools \
    ropper \
    numpy \
    scapy \
    pycryptodome \
    setuptools \

# Install docker
curl -fsSL https://get.docker.com | sh
sudo groupadd docker
sudo usermod -aG docker $USER
sudo usermod -aG $USER $USER