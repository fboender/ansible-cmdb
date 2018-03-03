.PHONY: doc test example
PROG=ansible-cmdb

fake:
	# NOOP

test:
	cd test && ./test.sh
	example/generate.sh

example:
	PYTHONPATH=lib src/ansible-cmdb -q -i example/hosts example/out example/out_custom > cmdb.html

doc:
	markdown_py README.md > README.html

clean:
	rm -rf rel_deb
	rm -f *.rpm
	rm -f *.deb
	rm -f *.tar.gz
	rm -f *.zip
	rm -f *.whl
	rm -f README.html
	find ./ -name "*.pyc" -delete
	find ./ -name "__pycache__" -type d -delete
	rm -f example/gen_*
	rm -rf example/cmdb/
	rm -rf build/
	rm -rf dist/
	rm -rf src/ansible_cmdb.egg-info/

release_check:
	@echo "Making release for version $(REL_VERSION)"
	@if [ -z "$(REL_VERSION)" ]; then echo "REL_VERSION required"; exit 1; fi
	echo "$(REL_VERSION)" > src/ansiblecmdb/data/VERSION

release: release_check release_src release_deb release_rpm release_wheel

release_src: release_check clean doc
	# Cleanup. Only on release, since REL_VERSION doesn't exist otherwise
	rm -rf $(PROG)-$(REL_VERSION)

	# Prepare source
	mkdir $(PROG)-$(REL_VERSION)
	cp -a src/* $(PROG)-$(REL_VERSION)/
	cp -r lib/* $(PROG)-$(REL_VERSION)/
	cp LICENSE $(PROG)-$(REL_VERSION)/
	cp README.md $(PROG)-$(REL_VERSION)/
	cp contrib/release_Makefile $(PROG)-$(REL_VERSION)/Makefile
	cp contrib/ansible-cmdb.man.1 $(PROG)-$(REL_VERSION)/

	# Bump version numbers
	find $(PROG)-$(REL_VERSION)/ -type f -print0 | xargs -0 sed -i "s/%%MASTER%%/$(REL_VERSION)/g" 

	# Create archives
	zip -q -r $(PROG)-$(REL_VERSION).zip $(PROG)-$(REL_VERSION)
	tar -czf $(PROG)-$(REL_VERSION).tar.gz  $(PROG)-$(REL_VERSION)

release_deb: release_check clean doc
	mkdir -p rel_deb/usr/bin
	mkdir -p rel_deb/usr/lib/${PROG}
	mkdir -p rel_deb/usr/share/doc/$(PROG)
	mkdir -p rel_deb/usr/share/man/man1

	# Copy the source to the release directory structure.
	cp README.md rel_deb/usr/share/doc/$(PROG)/
	cp README.html rel_deb/usr/share/doc/$(PROG)/
	cp -r src/* rel_deb/usr/lib/${PROG}/
	cp -r lib/* rel_deb/usr/lib/${PROG}/
	ln -s ../lib/$(PROG)/ansible-cmdb rel_deb/usr/bin/ansible-cmdb
	cp -a contrib/debian/DEBIAN rel_deb/
	cp contrib/debian/copyright rel_deb/usr/share/doc/$(PROG)/
	cp contrib/debian/changelog rel_deb/usr/share/doc/$(PROG)/
	gzip -9 rel_deb/usr/share/doc/$(PROG)/changelog
	cp -a contrib/ansible-cmdb.man.1 rel_deb/usr/share/man/man1/ansible-cmdb.1
	gzip -9 rel_deb/usr/share/man/man1/ansible-cmdb.1

	# Bump version numbers
	find rel_deb/ -type f -print0 | xargs -0 sed -i "s/%%MASTER%%/$(REL_VERSION)/g" 

	# Create debian pacakge
	fakeroot dpkg-deb --build rel_deb > /dev/null
	mv rel_deb.deb $(PROG)-$(REL_VERSION).deb

	# Cleanup
	rm -rf rel_deb
	rm -rf $(PROG)-$(REL_VERSION)

release_rpm: release_check clean release_deb
	alien -r -g $(PROG)-$(REL_VERSION).deb
	sed -i '\:%dir "/":d' $(PROG)-$(REL_VERSION)/$(PROG)-$(REL_VERSION)-2.spec
	sed -i '\:%dir "/usr/":d' $(PROG)-$(REL_VERSION)/$(PROG)-$(REL_VERSION)-2.spec
	sed -i '\:%dir "/usr/share/":d' $(PROG)-$(REL_VERSION)/$(PROG)-$(REL_VERSION)-2.spec
	sed -i '\:%dir "/usr/share/doc/":d' $(PROG)-$(REL_VERSION)/$(PROG)-$(REL_VERSION)-2.spec
	sed -i '\:%dir "/usr/share/man/":d' $(PROG)-$(REL_VERSION)/$(PROG)-$(REL_VERSION)-2.spec
	sed -i '\:%dir "/usr/share/man/man1/":d' $(PROG)-$(REL_VERSION)/$(PROG)-$(REL_VERSION)-2.spec
	sed -i '\:%dir "/usr/lib/":d' $(PROG)-$(REL_VERSION)/$(PROG)-$(REL_VERSION)-2.spec
	sed -i '\:%dir "/usr/bin/":d' $(PROG)-$(REL_VERSION)/$(PROG)-$(REL_VERSION)-2.spec
	cd $(PROG)-$(REL_VERSION) && rpmbuild --buildroot='$(shell readlink -f $(PROG)-$(REL_VERSION))/' -bb --target noarch '$(PROG)-$(REL_VERSION)-2.spec'

release_wheel: release_check clean
	echo "$(REL_VERSION)" > src/ansiblecmdb/data/VERSION
	python setup.py bdist_wheel --universal
	mv dist/*.whl .
	rmdir dist
	rm -rf build
	echo `git rev-parse --abbrev-ref HEAD | tr "[:lower:]" "[:upper:]"` > src/ansiblecmdb/data/VERSION

install:
	umask 0022 && mkdir -p /usr/local/lib/$(PROG)
	umask 0022 && mkdir -p /usr/local/man/man1
	umask 0022 && cp -a src/* /usr/local/lib/$(PROG)
	umask 0022 && cp -r lib/* /usr/local/lib/$(PROG)
	umask 0022 && cp LICENSE /usr/local/lib/$(PROG)
	umask 0022 && cp README.md /usr/local/lib/$(PROG)
	umask 0022 && gzip -9 -c contrib/ansible-cmdb.man.1 > /usr/local/man/man1/ansible-cmdb.man.1.gz
	umask 0022 && ln -s /usr/local/lib/ansible-cmdb/ansible-cmdb /usr/local/bin/ansible-cmdb

uninstall:
	rm -rf /usr/local/lib/$(PROG)
	rm -rf /usr/local/man/man/ansible-cmdb*
	rm -rf /usr/local/bin/ansible-cmdb
