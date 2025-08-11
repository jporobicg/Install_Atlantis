#!/bin/bash
aclocal
autoconf
automake -a               # I have some problems with this section
autoreconf  -fvi          # you can use this instead of the other ones
chmod +x configure   # Change the permissions to the configure script
./configure
make
sudo make install
