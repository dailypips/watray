NULL = 

AUTOMAKE_OPTIONS = subdir-objects

SUBDIRS = \
	$(NULL)

AM_CPPFLAGS = \
	$(WATRAYSIMPLE_CFLAGS) \
	-DPACKAGE_DATADIR=\""$(pkgdatadir)"\" \
	-include $(CONFIG_HEADER) \
	-I $(top_srcdir)/src \
	$(NULL)

BUILT_SOURCES = libwatraysimple.vala.stamp

libwatraysimpledir = $(libdir)/watray/plugins

libwatraysimple_LTLIBRARIES = libwatraysimple.la


libwatraysimple_la_VALASOURCES = \
	simpleplugin.vala \
	simpledocumentmanager.vala \
	simpledocumentview.vala \
	simpleprojectmanager.vala \
	$(NULL)


libwatraysimple_la_SOURCES = \
	$(libwatraysimple_la_VALASOURCES:.vala=.c) \
	$(libwatraysimple_la_VALASOURCES:.vala=.h) \
	$(NULL)

libwatraysimple.vala.stamp: $(libwatraysimple_la_VALASOURCES)
	$(VALAC) -C  --pkg config --pkg gtk+-2.0 --pkg watray-1.0 --vapidir $(top_srcdir)/watray --basedir $(top_srcdir) --vapidir $(top_srcdir)/vapi $^
	touch $@

libwatraysimple_la_LDFLAGS = \
	$(PLUGIN_LIBTOOL_FLAGS) \
	-module -avoid-version

libwatraysimple_la_LIBADD = \
	$(WATRAYSIMPLE_LIBS) \
	$(NULL)

libwatraysimple_DATA = \
	simple.watrayplugin \
	$(NULL)

EXTRA_DIST = \
	$(libwatraysimple_la_VALASOURCES) \
	libwatraysimple.vala.stamp \
	simple.watrayplugin
	$(NULL)

DISTCLEANFILES = \
	$(NULL)

