OBJDIR=.obj
CC=gcc
CFLAGS=-g -Wall -MMD -MF $(OBJDIR)/$(@F).d -Wno-array-bounds
LDFLAGS=-flto
CFLAGS_OPT=$(CFLAGS) -O2 -flto
DEFINES:=-D_GNU_SOURCE
CFLAGS+=$(DEFINES)

LIBS=/usr/local/lib/quickjs/libquickjs.a
INCLUDES=-I/usr/local/include/quickjs

$(OBJDIR):
	mkdir -p $(OBJDIR)

myAsyncScript: $(OBJDIR) $(OBJDIR)/process.o $(OBJDIR)/myAsyncScript.o
	$(CC) $(LDFLAGS) $(CFLAGS_OPT) -o $@ $(OBJDIR)/myAsyncScript.o $(OBJDIR)/process.o $(LIBS) -lm -ldl
	strip myAsyncScript

$(OBJDIR)/process.o: process.c
	$(CC) $(LDFLAGS) $(CFLAGS_OPT) -c $(INCLUDES) -o $@ process.c

$(OBJDIR)/myAsyncScript.o: myAsyncScript.c
	$(CC) $(LDFLAGS) $(CFLAGS_OPT) -c $(INCLUDES) -o $@ myAsyncScript.c

myAsyncScript.c: myAsyncScript.js
	qjsc -flto -e -M process,process -m -o $@ myAsyncScript.js

clean:
	rm ./myAsyncScript
	rm myAsyncScript.c
	rm -rf $(OBJDIR)
