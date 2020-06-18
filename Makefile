# Settings
VERSION=1.0.0
FILES=pxzgrep *.md Makefile

# Defaults
DESTDIR:=
PREFIX:=/usr/local
INSTALL:=install

all:
	@echo Nothing to do.
	@echo Valid targets: install dist origtarxz ../pxzgrep-$(VERSION).tar.xz ../pxzgrep_$(VERSION).orig.tar.xz

install:
	$(INSTALL) -pv pxzgrep $(DESTDIR)$(PREFIX)/bin/

dist: ../pxzgrep-$(VERSION).tar.xz
../pxzgrep-$(VERSION).tar.xz: $(FILES)
	tar cvJf ../pxzgrep-$(VERSION).tar.xz $(FILES)

origtarxz: ../pxzgrep_$(VERSION).orig.tar.xz
../pxzgrep_$(VERSION).orig.tar.xz: ../pxzgrep-$(VERSION).tar.xz
	ln -vsf pxzgrep-$(VERSION).tar.xz ../pxzgrep_$(VERSION).orig.tar.xz
