# compiler
CC = gcc

# linker
LD = gcc

# language file extension
EXT = c

# source files directory
SRC_DIR = ./src

# program name
PROG = mod-host

# default install paths
PREFIX = /usr/local
BINDIR = $(PREFIX)/bin
SHAREDIR = $(PREFIX)/share
MANDIR = $(SHAREDIR)/man/man1/

# default compiler and linker flags
CFLAGS = -O3 -Wall -Wextra -c -std=gnu99
LDFLAGS = -s

# debug mode compiler and linker flags
ifeq ($(DEBUG), 1)
   CFLAGS = -O0 -g -Wall -Wextra -c -DDEBUG
   LDFLAGS =
endif

# libraries
LIBS = `pkg-config --libs jack` `pkg-config --libs lilv-0` -lreadline -lpthread

# include paths
INCS = `pkg-config --cflags lilv-0`

# remove command
RM = rm -f

# source and object files
SRC = $(wildcard $(SRC_DIR)/*.$(EXT))
OBJ = $(SRC:.$(EXT)=.o)

# linking rule
$(PROG): get_info $(OBJ)
	$(LD) $(LDFLAGS) $(OBJ) -o $(PROG) $(LIBS)
	@rm src/info.h

# meta-rule to generate the object files
%.o: %.$(EXT)
	$(CC) $(CFLAGS) $(INCS) -o $@ $<

# install rule
install: install_man
	install $(PROG) $(BINDIR)

# clean rule
clean:
	$(RM) $(SRC_DIR)/*.o $(PROG) src/info.h

test:
	py.test tests/test_host.py
	
# manual page rule
# Uses md2man to convert the README to groff man page
# https://github.com/sunaku/md2man
man:
	md2man-roff README.md > doc/mod-host.1

# install manual page rule
install_man:
	install doc/*.1 $(MANDIR)

# generate the source file with the help message
A=`grep -n 'The commands supported' README.md | cut -d':' -f1`
B=`grep -n 'bye!' README.md | cut -d':' -f1`
get_info:
	@sed -n -e "$A,$B p" -e "$B q" README.md > help_msg
	@utils/txt2cvar.py help_msg > src/info.h
	@rm help_msg
	@echo "const char version[] = {\""`git describe --tags`\""};" >> src/info.h
