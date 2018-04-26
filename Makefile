PREFIX = '/usr'
DESTDIR = ''
DOCS = changelog README.md AUTHORS LICENSE copyright
PROGRAM_NAME := $(shell grep ^PROGRAM_NAME INFO | cut -d= -f2)
EXECUTABLE_NAME := $(shell grep ^EXECUTABLE_NAME INFO | cut -d= -f2)
AUTHOR := $(shell grep ^AUTHOR INFO | cut -d= -f2)
VERSION := $(shell grep ^VERSION INFO | cut -d= -f2)
LICENSE := $(shell grep ^LICENSE INFO | cut -d= -f2)
MAIL := $(shell grep ^MAIL INFO | cut -d= -f2 | tr '[A-Za-z]' '[N-ZA-Mn-za-m]')
TIMESTAMP = $(shell LC_ALL=C date '+%a, %d %b %Y %T %z')
YEAR = 2018

default: README.md
	@echo
	@echo Now you can make install or make debian

version_update: clean readme.in changelog README.md changelog.update changelog.new

changelog.update:
	@echo "$(EXECUTABLE_NAME) ($(VERSION)) unstable; urgency=medium" > changelog.update
	@echo >> changelog.update
	@echo "  * Release $(VERSION)" >> changelog.update
	@echo >> changelog.update
	@echo " -- $(AUTHOR) <@mail@>  $(TIMESTAMP)" >> changelog.update
	@echo >> changelog.update

changelog.new: changelog changelog.update
	@cat changelog.update changelog > changelog.new
	mv changelog.new changelog

debian:
	mkdir debian

debian/compat: compat debian
	cp compat $@
	
debian/rules: rules debian
	cp rules $@
	
debian/changelog: changelog debian
	sed s/@mail@/$(MAIL)/g changelog > $@

debian/control: control debian
	sed s/@mail@/$(MAIL)/g control > $@

debian/README: README.md debian
	cp README.md debian/README
	
debian/copyright: copyright debian
	@echo Format: https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/ > $@
	@echo Upstream-Name: $(EXECUTABLE_NAME) >> $@
	@echo "Upstream-Contact: Manuel Domínguez López <$(MAIL)>" >> $@
	@echo Source: $(SOURCE) >> $@
	@echo License: $(LICENSE) >> $@
	@echo >> $@
	@echo 'Files: *' >> $@
	@echo "Copyright: $(YEAR) $(AUTHOR) <$(MAIL)>" >> $@
	@echo License: $(LICENSE) >> $@
	cat copyright >> $@

README.md: readme.in
	sed s/@version@/$(VERSION)/g $^ > $@

clean: debian_clean
	rm -rf version_update changelog.* *.xz *.gz *.tgz *.deb

purge: clean
	rm README.md

debian_clean:
	rm -rf debian

debian_pkg: debian/compat debian/rules debian/changelog debian/control debian/README debian/copyright
	#fakeroot debian/rules clean
	#fakeroot debian/rules build
	fakeroot debian/rules binary
	mv ../$(EXECUTABLE_NAME)_$(VERSION)_all.deb .
	@echo Package done!
	@echo You can install it as root with:
	@echo dpkg -i $(EXECUTABLE_NAME)_$(VERSION)_all.deb
	
install_docs: $(DOCS)
	install -dm 755 $(DESTDIR)$(PREFIX)/share/doc/$(EXECUTABLE_NAME)
	install -Dm 644 $(DOCS) $(DESTDIR)$(PREFIX)/share/doc/$(EXECUTABLE_NAME)

install_executables: src/$(EXECUTABLE_NAME).sh
	install -Dm 755 $^ $(DESTDIR)$(PREFIX)/bin/$(EXECUTABLE_NAME)
	
install: install_docs install_executables

uninstall:
	rm -f $(PREFIX)/bin/$(EXECUTABLE_NAME)
	rm -rf $(PREFIX)/share/licenses/$(EXECUTABLE_NAME)/
	rm -rf $(PREFIX)/share/doc/$(EXECUTABLE_NAME)/
