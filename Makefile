#name:Eric Rogers
#email:ejr140230@utdallas.edu
#course number:CS3376.001
#Compiler Specific stuff

CC = gcc
CFLAGS = -Wall -O
LEX=flex
LFLAGs=
YACC=bison
YFLAGS=-dy
#
# Project Specific stuff
PROJECTNAME = HW4
# used for the backup target
EXECFILE = hw4			# the neme of the executable
OBJS = parser.o scanner.o hw4.o			# a list of all .o files needed

# Implicit Rule
%.o: %.c
	$(CC) -M -MF $*.P $<
	$(CC) -c -o $@ $< $(CFLAGS)

# This is the first target so it is the default
all: $(EXECFILE)


# Link .o files to create an executable
$(EXECFILE): $(OBJS)
	$(CC) -o $@ $(OBJS)


clean:
	rm -f $(OBJS) *.P *~ \#* $(EXECFILE) y.tab.h y.output parser.c scanner.c

#
# Note: tar errors will not be displayed.  Check your backups.
#
backup:
	@mkdir -p ~/backups; chmod 700 ~/backups
	@$(eval CURDIRNAME := $(shell basename `pwd`))
	@$(eval MKBKUPNAME := ~/backups/$(PROJECTNAME)-$(shell date +'%Y.%m.%d-%H:%M:%S').tar.gz)
	@echo
	@echo Writing Backup file to: $(MKBKUPNAME)
	@echo
	@-tar zcf $(MKBKUPNAME) ../$(CURDIRNAME) 2> /dev/null
	@chmod 600 $(MKBKUPNAME)
	@echo
	@echo Done!

tarball:
	make backup
	make clean
	tar cfzv ../tarballs/$(PROJECTNAME).tar.gz ../$(PROJECTNAME)

# Include all the header file dependencies
# created by the preprocessor.  The list
# is initially empty after a make clean.
#
# The first full build will create the .P
# files. After the .P files exist and will
# be included.
-include $(OBJS:%.o=%.P)
