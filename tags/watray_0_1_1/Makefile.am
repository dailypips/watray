NULL = 

#Build in these directories:

SUBDIRS = \
	watray \
	watraysimple \
	po \
	ui \
	$(NULL)

watraydocdir = ${prefix}/doc/watray
watraydoc_DATA = \
	ChangeLog \
	README \
	COPYING \
	AUTHORS \
	INSTALL \
	NEWS\
	$(NULL)

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = watray-1.0.pc

EXTRA_DIST = \
	$(watraydoc_DATA) \
	watray-1.0.pc.in \
	intltool-extract.in \
	intltool-merge.in \
	intltool-update.in\
	$(NULL)

DISTCLEANFILES = \
	intltool-extract \
	intltool-merge \
	intltool-update
	po/.intltool-merge-cache \
	$(NULL)

