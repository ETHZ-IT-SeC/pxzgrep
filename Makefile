# Settings
PROJECT=pxzgrep
VERSION=1.0.0+dev
DISTNAME=$(PROJECT)-$(VERSION)
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

dist: ../$(DISTNAME).tar.xz
../$(DISTNAME).tar.xz: $(DISTFILES)
	mkdir $(DISTNAME)
	cp -pvr $(DISTFILES) $(DISTNAME)
	tar cvJf $@ --exclude=t/target/\* $(DISTNAME)
	rm -rv $(DISTNAME)

dist-rpm: ~/rpmbuild/SOURCES/$(PROJECT)-1.0.0+dev.tar.gz
~/rpmbuild/SOURCES/$(PROJECT)-1.0.0+dev.tar.gz: ../$(DISTNAME).tar.gz
	cp -pv $< $@
dist-legacy: ../$(DISTNAME).tar.gz
../$(DISTNAME).tar.gz: $(DISTFILES)
	mkdir $(DISTNAME)
	cp -pvr $(DISTFILES) $(DISTNAME)
	tar cvzf $@ --exclude=t/target/\* $(DISTNAME)
	rm -rv $(DISTNAME)

origtarxz: ../$(PROJECT)_$(VERSION).orig.tar.xz
../$(PROJECT)_$(VERSION).orig.tar.xz: ../$(DISTNAME).tar.xz
	ln -vsf $(DISTNAME).tar.xz ../$(PROJECT)_$(VERSION).orig.tar.xz
