.PHONY: doc test example
PROG=ansible-cmdb

fake:
	# NOOP

test:
	cd test && ./test.sh

example:
	example/generate.sh

release_clean: clean
	@if [ "$(shell git status --porcelain)" != "" ]; then echo "Repo not clean. Not building"; exit 1; fi

release: release_src release_deb release_rpm

doc:
	markdown_py README.md > README.html

release_src: release_clean doc
	@echo "Making release for version $(REL_VERSION)"

	@if [ -z "$(REL_VERSION)" ]; then echo "REL_VERSION required"; exit 1; fi

	# Cleanup
	rm -rf $(PROG)-$(REL_VERSION)

	# Prepare source
	mkdir $(PROG)-$(REL_VERSION)
	cp -ar src/* $(PROG)-$(REL_VERSION)/
	cp -r lib/mako $(PROG)-$(REL_VERSION)/
	cp -r lib/yaml $(PROG)-$(REL_VERSION)/
	cp LICENSE $(PROG)-$(REL_VERSION)/
	cp README.md $(PROG)-$(REL_VERSION)/
	cp CHANGELOG.txt $(PROG)-$(REL_VERSION)/
	cp contrib/release_Makefile $(PROG)-$(REL_VERSION)/Makefile

	# Bump version numbers
	find $(PROG)-$(REL_VERSION)/ -type f -print0 | xargs -0 sed -i "s/%%MASTER%%/$(REL_VERSION)/g" 

	# Create archives
	zip -q -r $(PROG)-$(REL_VERSION).zip $(PROG)-$(REL_VERSION)
	tar -czf $(PROG)-$(REL_VERSION).tar.gz  $(PROG)-$(REL_VERSION)

release_deb: release_clean doc
	@if [ -z "$(REL_VERSION)" ]; then echo "REL_VERSION required"; exit 1; fi

	# Cleanup
	rm -rf rel_deb

	mkdir -p rel_deb/usr/bin
	mkdir -p rel_deb/usr/lib/${PROG}
	mkdir -p rel_deb/usr/lib/${PROG}/mako
	mkdir -p rel_deb/usr/lib/${PROG}/yaml
	mkdir -p rel_deb/usr/share/doc/$(PROG)
	mkdir -p rel_deb/usr/share/man/man1

	# Copy the source to the release directory structure.
	cp LICENSE rel_deb/usr/share/doc/$(PROG)/
	cp README.md rel_deb/usr/share/doc/$(PROG)/
	cp README.html rel_deb/usr/share/doc/$(PROG)/
	cp CHANGELOG.txt rel_deb/usr/share/doc/$(PROG)/
	cp -r src/* rel_deb/usr/lib/${PROG}/
	cp -r lib/mako rel_deb/usr/lib/${PROG}/
	cp -r lib/yaml rel_deb/usr/lib/${PROG}/
	ln -s /usr/lib/$(PROG)/ansible-cmdb rel_deb/usr/bin/ansible-cmdb
	cp -ar contrib/debian/DEBIAN rel_deb/

	# Bump version numbers
	find rel_deb/ -type f -print0 | xargs -0 sed -i "s/%%MASTER%%/$(REL_VERSION)/g" 

	# Create debian pacakge
	fakeroot dpkg-deb --build rel_deb > /dev/null
	mv rel_deb.deb $(PROG)-$(REL_VERSION).deb

	# Cleanup
	rm -rf rel_deb
	rm -rf $(PROG)-$(REL_VERSION)

release_rpm: release_clean release_deb
	alien -r -g $(PROG)-$(REL_VERSION).deb
	sed -i '\:%dir "/":d' $(PROG)-$(REL_VERSION)/$(PROG)-$(REL_VERSION)-2.spec
	sed -i '\:%dir "/usr/":d' $(PROG)-$(REL_VERSION)/$(PROG)-$(REL_VERSION)-2.spec
	sed -i '\:%dir "/usr/share/":d' $(PROG)-$(REL_VERSION)/$(PROG)-$(REL_VERSION)-2.spec
	sed -i '\:%dir "/usr/share/man/":d' $(PROG)-$(REL_VERSION)/$(PROG)-$(REL_VERSION)-2.spec
	sed -i '\:%dir "/usr/share/man/man1/":d' $(PROG)-$(REL_VERSION)/$(PROG)-$(REL_VERSION)-2.spec
	sed -i '\:%dir "/usr/lib/":d' $(PROG)-$(REL_VERSION)/$(PROG)-$(REL_VERSION)-2.spec
	sed -i '\:%dir "/usr/bin/":d' $(PROG)-$(REL_VERSION)/$(PROG)-$(REL_VERSION)-2.spec
	cd $(PROG)-$(REL_VERSION) && rpmbuild --buildroot='$(shell readlink -f $(PROG)-$(REL_VERSION))/' -bb --target noarch '$(PROG)-$(REL_VERSION)-2.spec'


clean:
	rm -f *.rpm
	rm -f *.deb
	rm -f *.tar.gz
	rm -f *.zip
	rm -f README.html
	find ./ -name "*.pyc" -delete
	find ./ -name "__pycache__" -type d -delete
