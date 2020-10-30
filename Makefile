# Settings
PROJECT=pxzgrep
VERSION=1.0.0+dev
DISTFILES=$(PROJECT) t/*.t t/source t/target *.md Makefile
MANPAGE=$(PROJECT).1

# Defaults
DESTDIR:=
PREFIX:=/usr/local
INSTALL:=install

all: man
test: check
check:
	prove -v t

man: $(MANPAGE)
$(MANPAGE): README.md Makefile
	ronn --roff --manual="$(PROJECT) Manual" --organization="ETH Zurich IT-SeC" < $< > $@
	gzip -9vnf $@

install: all
	$(INSTALL) -dv $(DESTDIR)$(PREFIX)/bin/
	$(INSTALL) -pv $(PROJECT) $(DESTDIR)$(PREFIX)/bin/
	$(INSTALL) -dv $(DESTDIR)$(PREFIX)/share/man/man1/
	$(INSTALL) -pv $(MANPAGE).gz $(DESTDIR)$(PREFIX)/share/man/man1/

clean:
	rm -f $(MANPAGE)*

dist: ../$(PROJECT)-$(VERSION).tar.xz
../$(PROJECT)-$(VERSION).tar.xz: $(DISTFILES)
	mkdir $(PROJECT)-$(VERSION)
	cp -pvr $(DISTFILES) $(PROJECT)-$(VERSION)
	tar cvJf $@ --exclude=t/target/\* $(PROJECT)-$(VERSION)

dist-rpm: ~/rpmbuild/SOURCES/$(PROJECT)-1.0.0+dev.tar.gz
~/rpmbuild/SOURCES/$(PROJECT)-1.0.0+dev.tar.gz: ../$(PROJECT)-$(VERSION).tar.gz
	cp -pv $< $@
dist-legacy: ../$(PROJECT)-$(VERSION).tar.gz
../$(PROJECT)-$(VERSION).tar.gz: $(DISTFILES)
	mkdir $(PROJECT)-$(VERSION)
	cp -pvr $(DISTFILES) $(PROJECT)-$(VERSION)
	tar cvzf $@ --exclude=t/target/\* $(PROJECT)-$(VERSION)

origtarxz: ../$(PROJECT)_$(VERSION).orig.tar.xz
../$(PROJECT)_$(VERSION).orig.tar.xz: ../$(PROJECT)-$(VERSION).tar.xz
	ln -vsf $(PROJECT)-$(VERSION).tar.xz ../$(PROJECT)_$(VERSION).orig.tar.xz
