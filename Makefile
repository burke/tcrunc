include config.mk

SHARE=${PREFIX}/share/chyve

all: initrd.gz chyve

initrd.gz: FORCE
	@echo building patched initrd.gz
	@echo this will ask for sudo.
	@echo you also must first brew install gnu-sed.
	@./build-patched-initrd

chyve: chyve.tpl
	@echo creating $@ from $<
	@sed 's#{{DIR}}#${SHARE}#g' < $< > $@
	@chmod a+x $@

clean:
	@echo cleaning
	@rm -f chyve initrd.gz
	@rm -rf initrd

install: all
	@echo installing executable file to ${PREFIX}/bin
	@mkdir -p ${PREFIX}/bin
	@cp -f chyve ${PREFIX}/bin/chyve
	@echo installing support files to ${SHARE}
	@mkdir -p ${SHARE}
	@cp -f vmlinuz ${SHARE}/vmlinuz
	@cp -f initrd.gz ${SHARE}/initrd.gz

uninstall:
	@echo removing executable file from ${PREFIX}/bin
	@rm -f ${PREFIX}/bin/chyve
	@echo removing ${SHARE}
	@rm -f ${SHARE}/vmlinuz
	@rm -f ${SHARE}/initrd.gz
	@rmdir ${SHARE}

# always run
FORCE:

.PHONY: all clean install uninstall FORCE
