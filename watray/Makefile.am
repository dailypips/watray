NULL = 

AM_CPPFLAGS = \
	$(WATRAY_CFLAGS) \
	-DPACKAGE_DATADIR=\""$(pkgdatadir)"\" \
	-DPACKAGE_LIBDIR=\""$(libdir)"\" \
	-include $(CONFIG_HEADER) \
	$(NULL)

BUILT_SOURCES = watray.vala.stamp

bin_PROGRAMS = watray

watray_VALASOURCES = \
	watraydocumentspanel.vala \
	watraydocumentspanelinterface.vala \
	watraydocumentview.vala \
	watrayiteminfo.vala \
	watraymainwindow.vala \
	watraymainwindowinterface.vala \
	watrayproject.vala \
	watrayprojectspanel.vala \
	watrayprojectspanelinterface.vala \
	watrayplugin.vala \
	watrayplugininfo.vala \
	watrayplugininterface.vala \
	watraypluginmanager.vala \
	watraypluginmanagerview.vala \
	watraypreferencedialog.vala \
	watraypreferencemanager.vala \
	$(NULL)

watray_SOURCES = \
	$(watray_VALASOURCES:.vala=.c) \
	$(watray_VALASOURCES:.vala=.h) \
	$(NULL)

watrayincludedir = $(includedir)/watray-1.0/watray

watrayinclude_HEADERS = \
	watraydocumentspanelinterface.h \
	watraydocumentview.h \
	watrayiteminfo.h \
	watraymainwindowinterface.h \
	watrayproject.h \
	watrayprojectspanelinterface.h \
	$(NULL)

watray.vala.stamp: $(watray_VALASOURCES)
	$(VALAC) -C --pkg gtk+-2.0 --pkg gdk-2.0 --pkg gmodule-2.0 --pkg config --pkg gconf-2.0 --basedir $(top_srcdir) --library watray-1.0 --vapidir $(top_srcdir)/vapi $^
	touch $@

watray_LDADD = \
	$(WATRAY_LIBS) \
	$(NULL)

EXTRA_DIST = \
	$(watray_VALASOURCES) \
	watray.vala.stamp \
	$(NULL)

DISTCLEANFILES = \
	$(NULL)

