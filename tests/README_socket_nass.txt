socketcli.py:
is interactive connection to a running mod-host server.

socketcmd.py: send a cmd to a running mod-host server. works well with "load <filename>" command.

socketcmd.sh: bash derivative of above command. Does not work correctly with "load", but works well with other commands.



INSTALL
-------

deps: sudo apt install -y libreadline-dev liblilv-dev libargtable2-dev 
