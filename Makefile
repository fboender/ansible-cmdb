.PHONY: doc 
PROG=ansible-cmdb

fake:
	# NOOP

install:
	mkdir -p /usr/local/lib/${PROG}
	cp -a src/* /usr/local/lib/${PROG}/
	ln -s /usr/local/lib/${PROG}/ansible-cmdb /usr/local/bin/ansible-cmdb

uninstall:
	rm -rf /usr/local/lib/${PROG}
	rm /usr/local/bin/ansible-cmdb

release: release_src release_deb release_rpm

doc:
	markdown_py README.md > README.html

release_src: doc
	@echo "Making release for version $(REL_VERSION)"

	@if [ -z "$(REL_VERSION)" ]; then echo "REL_VERSION required"; exit 1; fi

	# Cleanup
	rm -rf $(PROG)-$(REL_VERSION)

	# Prepare source
	mkdir $(PROG)-$(REL_VERSION)
	cp -r src/* $(PROG)-$(REL_VERSION)/
	cp -r lib/* $(PROG)-$(REL_VERSION)/
	cp LICENSE $(PROG)-$(REL_VERSION)/
	cp README.md $(PROG)-$(REL_VERSION)/
	cp contrib/release_Makefile $(PROG)-$(REL_VERSION)/Makefile

	# Bump version numbers
	find $(PROG)-$(REL_VERSION)/ -type f -print0 | xargs -0 sed -i "s/%%VERSION%%/$(REL_VERSION)/g" 

	# Create archives
	zip -r $(PROG)-$(REL_VERSION).zip $(PROG)-$(REL_VERSION)
	tar -vczf $(PROG)-$(REL_VERSION).tar.gz  $(PROG)-$(REL_VERSION)

release_deb: doc
	@if [ -z "$(REL_VERSION)" ]; then echo "REL_VERSION required"; exit 1; fi

	# Cleanup
	rm -rf rel_deb

	mkdir -p rel_deb/usr/bin
	mkdir -p rel_deb/usr/lib/${PROG}
	mkdir -p rel_deb/usr/share/doc/$(PROG)
	mkdir -p rel_deb/usr/share/man/man1

	# Copy the source to the release directory structure.
	cp LICENSE rel_deb/usr/share/doc/$(PROG)/
	cp README.md rel_deb/usr/share/doc/$(PROG)/
	cp README.html rel_deb/usr/share/doc/$(PROG)/
	cp -r src/* rel_deb/usr/lib/${PROG}/
	cp -r lib/* rel_deb/usr/lib/${PROG}/
	ln -s /usr/lib/$(PROG)/ansible-cmdb rel_deb/usr/bin/ansible-cmdb
	cp -ar contrib/debian/DEBIAN rel_deb/

	# Bump version numbers
	find rel_deb/ -type f -print0 | xargs -0 sed -i "s/%%VERSION%%/$(REL_VERSION)/g" 

	# Create debian pacakge
	fakeroot dpkg-deb --build rel_deb > /dev/null
	mv rel_deb.deb $(PROG)-$(REL_VERSION).deb

	# Cleanup
	rm -rf rel_deb
	rm -rf $(PROG)-$(REL_VERSION)

release_rpm: release_deb
	alien -r $(PROG)-$(REL_VERSION).deb

clean:
	rm -rf *.tar.gz
	rm -rf *.zip
	rm -rf *.deb
	rm -rf rel_deb
	rm -rf $(PROG)-*
	rm -rf README.html
	find ./ -name "*.log" -delete
	find ./ -name "*.pyc" -delete
