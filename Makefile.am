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

dist-hook: gen-ChangeLog

gen_start_date = 2009-04-27
.PHONY: gen-ChangeLog
gen-ChangeLog:
	if test -d .git; then						\
	  $(top_srcdir)/gitlog-to-changelog				\
	    --since=$(gen_start_date) > $(distdir)/cl-t;		\
	  rm -f $(distdir)/ChangeLog;					\
	  mv $(distdir)/cl-t $(distdir)/ChangeLog;			\
	fi

EXTRA_DIST = \
	$(watraydoc_DATA) \
	ChangeLog-pre-0.2.0 \
	gitlog-to-changelog \
	MAINTAINERS \
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

