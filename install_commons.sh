sudo apt-get update && \
sudo apt-get install -y \
    libtool \
    g++ \
    gcc \
    sshfs \
    coreutils \
    automake \
    git \
    cmake \
    netcat \
    net-tools \
    wget \
    curl \
    build-essential \
    vim \
    gdb \
    gdbserver \
    gdb-multiarch \
    patchelf \
    ltrace \
    strace \
    python3 \
    python3-pip \
    ipython3 \
    tmux \

python3 -m pip install virtualenv virtualenvwrapper --break-system-packages