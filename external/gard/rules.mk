.DEFAULT_GOAL := all

override CFLAGS += -O2 -Wall -Werror -I.
OBJS      = version.o gard.o
LIBFLASH_OBJS     += libflash-file.o libflash-libflash.o libflash-libffs.o libflash-ecc.o libflash-blocklevel.o
OBJS     += $(LIBFLASH_OBJS)
OBJS     += common-arch_flash.o
EXE       = gard

prefix = /usr/local/
sbindir = $(prefix)/sbin
datadir = $(prefix)/share
mandir = $(datadir)/man

GARD_VERSION ?= $(shell ./make_version.sh $(EXE))

version.c: make_version.sh .version
	@(if [ "a$(GARD_VERSION)" = "a" ]; then \
	echo "#error You need to set GARD_VERSION environment variable" > $@ ;\
	else \
	echo "const char version[] = \"$(GARD_VERSION)\";" ;\
	fi) > $@

%.o : %.c
	$(CC) $(CFLAGS) -c $< -o $@

$(LIBFLASH_OBJS): libflash-%.o : libflash/%.c
	$(CC) $(CFLAGS) -c $< -o $@

$(EXE): $(OBJS)
	$(CC) $(LDFLAGS) $(CFLAGS) $^ -o $@

install: all
	install -D gard $(DESTDIR)$(sbindir)/opal-gard
	install -D -m 0644 opal-gard.1 $(DESTDIR)$(mandir)/man1/opal-gard.1


