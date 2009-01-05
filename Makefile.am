NULL = 

#Build in these directories:

SUBDIRS = \
	watray \
	watraysimple \
	po \
	pixmaps \
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

EXTRA_DIST = \
	$(watraydoc_DATA) \
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

