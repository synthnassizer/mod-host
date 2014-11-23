#!/usr/bin/env python

import socket, sys

s = socket.socket()
s.connect(('localhost', 5555))
s.send(' '.join(sys.argv[1:]))

