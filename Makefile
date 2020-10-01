# Settings
VERSION=1.0.0
DISTFILES=pxzgrep *.md Makefile
MANPAGE=pxzgrep.1

# Defaults
DESTDIR:=
PREFIX:=/usr/local
INSTALL:=install -s

all: man
test: check
check:
	prove -v t

man: $(MANPAGE)
$(MANPAGE): README.md Makefile
	ronn --roff --manual="pxzgrep Manual" --organization="ETH Zurich IT-SeC" < $< > $@
	gzip -9vnf $@

install: all
	$(INSTALL) -pv pxzgrep $(DESTDIR)$(PREFIX)/bin/
	$(INSTALL) -pv $(MANPAGE).gz $(DESTDIR)$(PREFIX)/share/man/man1/

clean:
	rm -f $(MANPAGE)*

dist: ../pxzgrep-$(VERSION).tar.xz
../pxzgrep-$(VERSION).tar.xz: $(DISTFILES)
	tar cvJf ../pxzgrep-$(VERSION).tar.xz $(DISTFILES)

origtarxz: ../pxzgrep_$(VERSION).orig.tar.xz
../pxzgrep_$(VERSION).orig.tar.xz: ../pxzgrep-$(VERSION).tar.xz
	ln -vsf pxzgrep-$(VERSION).tar.xz ../pxzgrep_$(VERSION).orig.tar.xz
