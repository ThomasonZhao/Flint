# initialization
set history save on
set disassembly-flavor intel
# set follow-fork-mode parent
# set follow-exec-mode new
set $base = 0x555555554000

# select plugins
source ~/.gdbinit-gef.py
# source /opt/pwndbg/gdbinit.py
# source /opt/peda/peda.py