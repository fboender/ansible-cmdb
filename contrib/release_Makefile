.PHONY: doc 
PROG=ansible-cmdb

fake:
	# NOOP

install:
	umask 0022 && mkdir -p /usr/local/lib/${PROG}
	umask 0022 && mkdir -p /usr/local/man/man1
	umask 0022 && cp -a * /usr/local/lib/${PROG}/
	cp -a ansible-cmdb.man.1 /usr/local/man/man1/ansible-cmdb.1
	ln -s /usr/local/lib/${PROG}/ansible-cmdb /usr/local/bin/ansible-cmdb
	if command -v mandb >/dev/null; then mandb -p -q; fi

uninstall:
	rm -rf /usr/local/lib/${PROG}
	rm -rf /usr/local/bin/ansible-cmdb
	rm -rf /usr/local/share/man/man1/ansible-cmdb.*
