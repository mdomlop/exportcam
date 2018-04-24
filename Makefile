PREFIX = '/usr'
DESTDIR = ''
DOCS= changelog README.md AUTHORS
EXECUTABLE_NAME := $(shell grep ^EXECUTABLE_NAME INFO | cut -d= -f2)
AUTHOR := $(shell grep ^AUTHOR INFO | cut -d= -f2)
VERSION := $(shell grep ^VERSION INFO | cut -d= -f2)
MAIL := $(shell grep ^MAIL INFO | cut -d= -f2 | tr '[A-Za-z]' '[N-ZA-Mn-za-m]')
TIMESTAMP = $(shell LC_ALL=C date '+%a, %d %b %Y %T %z')

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
	
debian/changelog: changelog
	sed s/@mail@/$(MAIL)/g $^ > $@

debian/control: control
	sed s/@mail@/$(MAIL)/g $^ > $@

debian/README: README.md
	cp README.md debian/README

README.md: readme.in
	sed s/@version@/$(VERSION)/g $^ > $@
	
install: $(DOCS) 
	install -d -m 755 $(DESTDIR)$(PREFIX)/share/doc/$(EXECUTABLE_NAME)
	install -Dm 644 $^ $(DESTDIR)$(PREFIX)/share/doc/$(EXECUTABLE_NAME)
	install -Dm 755 src/$(EXECUTABLE_NAME).sh $(DESTDIR)$(PREFIX)/bin/$(EXECUTABLE_NAME)
	install -d -m 755 $(DESTDIR)$(PREFIX)/share/licenses/$(EXECUTABLE_NAME)
	install -Dm 644 LICENSE $(DESTDIR)$(PREFIX)/share/licenses/$(EXECUTABLE_NAME)/COPYING

uninstall:
	rm -f $(PREFIX)/bin/$(EXECUTABLE_NAME)
	rm -rf $(PREFIX)/share/licenses/$(EXECUTABLE_NAME)/
	rm -rf $(PREFIX)/share/doc/$(EXECUTABLE_NAME)/

clean: debian_clean
	rm -rf version_update changelog.update changelog.new *.xz *.gz *.tgz *.deb

debian_clean:
	debian/changelog debian/control debian/README debian/files debian/$(EXECUTABLE_NAME) debian/debhelper-build-stamp debian/$(EXECUTABLE_NAME)*

purge: clean
	rm README.md

debian: debian/changelog debian/control debian/README
	#fakeroot debian/rules clean
	#fakeroot debian/rules build
	fakeroot debian/rules binary
	mv ../$(EXECUTABLE_NAME)_$(VERSION)_all.deb .
	@echo Package done!
	@echo You can install it as root with:
	@echo dpkg -i $(EXECUTABLE_NAME)_$(VERSION)_all.deb
