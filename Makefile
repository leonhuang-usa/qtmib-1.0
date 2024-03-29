all: src qtmib.1 qtmib-discover.1 qtmib-report.1 qtmib-translate.1

datarootdir=${prefix}/share
PREFIX=/usr/local
prefix=/usr/local
VERSION=1.1.1
NAME=qtmib
PACKAGE_TARNAME=qtmib
DOCDIR=${datarootdir}/doc/${PACKAGE_TARNAME}

qtmib_prefix.h:
	echo "#define QTMIB_PREFIX \"$(PREFIX)\"" > qtmib_prefix.h

.PHONY: src
src: qtmib_prefix.h
	$(MAKE) -C $@ $(MFLAGS)


qtmib.1: src/man/qtmib.txt
	./mkman.sh $(VERSION) src/man/qtmib.txt qtmib.1

qtmib-discover.1: src/man/qtmib-discover.txt
	./mkman.sh $(VERSION) src/man/qtmib-discover.txt qtmib-discover.1

qtmib-report.1: src/man/qtmib-report.txt
	./mkman.sh $(VERSION) src/man/qtmib-report.txt qtmib-report.1

qtmib-translate.1: src/man/qtmib-translate.txt
	./mkman.sh $(VERSION) src/man/qtmib-translate.txt qtmib-translate.1



clean:;rm -f build/*; rm -f *.1 *.1.gz; make -C src clean

distclean: clean
	rm -f `find src/qtmib -name Makefile`
	rm -f `find src/discover -name Makefile`
	rm -f `find src/report -name Makefile`
	rm -f qtmib_config.h Makefile config.status config.log qtmib_prefix.h
	rm -f  src/qtmib/config.log src/qtmib/config.status #fedora fix
	rm -fr autom4te.cache
	rm -f sanitizer.sh
	
install: all
	cd build; strip *; cd ..
	mkdir -p $(DESTDIR)/$(PREFIX)/bin
	mkdir -p $(DESTDIR)/$(PREFIX)/share/applications
	mkdir -p $(DESTDIR)/$(PREFIX)/share/pixmaps
	mkdir -p $(DESTDIR)/$(DOCDIR)
	mkdir -p $(DESTDIR)/$(PREFIX)/share/man/man1
	install -c -m 0755 build/qtmib $(DESTDIR)/$(PREFIX)/bin/.
	install -c -m 0755 build/qtmib-discover $(DESTDIR)/$(PREFIX)/bin/.
	install -c -m 0755 build/qtmib-report $(DESTDIR)/$(PREFIX)/bin/.
	install -c -m 0755 build/qtmib-translate $(DESTDIR)/$(PREFIX)/bin/.
	install -c -m 0644 src/qtmib/qtmib.desktop $(DESTDIR)/$(PREFIX)/share/applications/.
	install -c -m 0644 src/qtmib/resources/qtmib-128.png $(DESTDIR)/$(PREFIX)/share/pixmaps/qtmib.png
	install -c -m 0644 COPYING $(DESTDIR)/$(DOCDIR)/.
	install -c -m 0644 README $(DESTDIR)/$(DOCDIR)/.
	install -c -m 0644 RELNOTES $(DESTDIR)/$(DOCDIR)/.
	rm -f qtmib.1.gz
	gzip -9 qtmib.1
	install -c -m 0644 qtmib.1.gz $(DESTDIR)/$(PREFIX)/share/man/man1/.
	rm -f qtmib-discover.1.gz
	gzip -9 qtmib-discover.1
	install -c -m 0644 qtmib-discover.1.gz $(DESTDIR)/$(PREFIX)/share/man/man1/.
	rm -f qtmib-report.1.gz
	gzip -9 qtmib-report.1
	install -c -m 0644 qtmib-report.1.gz $(DESTDIR)/$(PREFIX)/share/man/man1/.
	rm -f qtmib-translate.1.gz
	gzip -9 qtmib-translate.1
	install -c -m 0644 qtmib-translate.1.gz $(DESTDIR)/$(PREFIX)/share/man/man1/.

uninstall:;
	rm -f $(DESTDIR)/$(PREFIX)/bin/qtmib
	rm -f $(DESTDIR)/$(PREFIX)/bin/qtmib-discover
	rm -f $(DESTDIR)/$(PREFIX)/bin/qtmib-report
	rm -f $(DESTDIR)/$(PREFIX)/bin/qtmib-translate
	rm -f $(DESTDIR)/$(PREFIX)/share/pixmaps/qtmib.png
	rm -f $(DESTDIR)/$(PREFIX)/share/applications/qtmib.desktop
	rm -fr $(DESTDIR)/$(PREFIX)/share/doc/qtmib
	rm -fr $(DESTDIR)/$(PREFIX)/share/man/man1/qtmib.1*
	rm -fr $(DESTDIR)/$(PREFIX)/share/man/man1/qtmib-discover.1*
	rm -fr $(DESTDIR)/$(PREFIX)/share/man/man1/qtmib-report.1*
	rm -fr $(DESTDIR)/$(PREFIX)/share/man/man1/qtmib-translate.1*

dist: distclean
	./mkdist.sh $(NAME) $(VERSION)

deb: dist
	./mkdeb.sh $(NAME) $(VERSION)

	
	
