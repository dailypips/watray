/* mainwindow.vala
 * 
 * Coyright (C) 2008 Matias de la Puente
 */
using Gtk;

internal class Watray.MainWindow : Window, IMainWindow
{
	const ActionEntry[] action_entries = 
	{
		{ "FileMenuAction", null, N_("_File") },
		{ "EditMenuAction", null, N_("_Edit") },
		{ "NewMenuAction", STOCK_NEW },
		{ "OpenMenuAction", STOCK_OPEN },
		{ "SaveAction", STOCK_SAVE, null, null, null, on_save },
		{ "SaveAsAction", STOCK_SAVE_AS, null, null, null, on_save_as },
		{ "PrintAction", STOCK_PRINT, null, null, null, on_print },
		{ "CloseAction", STOCK_CLOSE, null, null, null, on_close },
		{ "QuitAction", STOCK_QUIT, null, null, null, on_quit },
		{ "UndoAction", STOCK_UNDO, null, null, null, on_undo },
		{ "RedoAction", STOCK_REDO, null, null, null, on_redo },
		{ "CutAction", STOCK_CUT, null, null, null, on_cut },
		{ "CopyAction", STOCK_COPY, null, null, null, on_copy },
		{ "PasteAction", STOCK_PASTE, null, null, null, on_paste },
		{ "FindAction", STOCK_FIND, null, null, null, on_quit },
		{ "FindAndReplaceAction", STOCK_FIND_AND_REPLACE, null, null, null, on_quit },
		{ "PreferencesAction", STOCK_PREFERENCES, null, null, null, on_quit }
	};

	private DocumentsPanel documents_panel;
	private ProjectsPanel projects_panel;
	private PluginManager plugin_manager;
	private Menu _new_menu = new Menu ();
	private Menu _open_menu = new Menu ();
	
	public static void main (string[] args)
	{
		Gtk.init (ref args);
		var main_window = new MainWindow ();
		main_window.show_all ();
		Gtk.main ();
	}

	public MainWindow ()
	{
		this.title = "Watray";
		this.destroy += on_quit;
		this.set_size_request (1000, 500);
		
		var action_group = new ActionGroup ("WatrayActions");
		action_group.set_translation_domain (Config.GETTEXT_PACKAGE);
		action_group.add_actions (action_entries, this);

		var ui_manager = new UIManager ();
		ui_manager.insert_action_group (action_group, 0);
		try
		{
			ui_manager.add_ui_from_file (Path.build_filename (Config.PACKAGE_DATADIR, "ui", "ui.xml"));
		}
		catch (Error err)
		{
			error (err.message);
		}
		
		var menubar = (MenuBar)ui_manager.get_widget ("/MainMenu");
		var toolbar = (Toolbar)ui_manager.get_widget ("/MainToolbar");
		
		Gtk.Callback non_homogeneous = (item) => { ((ToolItem)item).set_homogeneous (false); };
		toolbar.foreach (non_homogeneous);
		
		var toolbutton = new MenuToolButton.from_stock (STOCK_NEW);
		toolbutton.set_menu (_new_menu);
		toolbar.insert (toolbutton, 0);

		toolbutton = new MenuToolButton.from_stock (STOCK_OPEN);
		toolbutton.set_menu (_open_menu);
		toolbar.insert (toolbutton, 1);
		
		var menu_item = (MenuItem)ui_manager.get_widget ("/MainMenu/FileMenu/NewMenu");
		menu_item.set_submenu (_new_menu);
		menu_item = (MenuItem)ui_manager.get_widget ("/MainMenu/FileMenu/OpenMenu");
		menu_item.set_submenu (_open_menu);

		projects_panel = new ProjectsPanel ();
		documents_panel = new DocumentsPanel ();
		
		var vpaned = new VPaned ();
		vpaned.pack1 (documents_panel, true, false);
		
		var hpaned = new HPaned ();
		hpaned.add1 (projects_panel);
		hpaned.add2 (vpaned);
		
		var vbox = new VBox (false, 0);
		vbox.pack_start (menubar, false, false, 0);
		vbox.pack_start (toolbar, false, false, 0);
		vbox.pack_start_defaults (hpaned);

		this.add (vbox);
		this.add_accel_group (ui_manager.get_accel_group ());
		
		plugin_manager = new PluginManager (this, projects_panel, documents_panel);
		plugin_manager.load_plugins ();
		if (plugin_manager.activate_plugin ("simple"))
			message ("Plugin activated\n");
	}
	
	public void add_menu_item (MenuType menu_type, MenuItem menu_item)
	{
		switch (menu_type)
		{
			case MenuType.NEW:
				_new_menu.append (menu_item);
				break;
			case MenuType.OPEN:
				_open_menu.append (menu_item);
				break;
		}
		menu_item.show_all ();
	}
	
	public void remove_menu_item (MenuType menu_type, MenuItem menu_item)
	{
		switch (menu_type)
		{
			case MenuType.NEW:
				_new_menu.children.remove (menu_item);
				break;
			case MenuType.OPEN:
				_open_menu.children.remove (menu_item);
				break;
		}
	}
	
	public void on_save ()
	{
		documents_panel.current_view.save_action ();
	}
	
	public void on_save_as ()
	{
		documents_panel.current_view.save_as_action ();
	}
	
	public void on_print ()
	{
		documents_panel.current_view.print_action ();
	}
	
	public void on_quit ()
	{
		//documents_panel.close_all ();
		Gtk.main_quit ();
	}
	
	public void on_undo ()
	{
		documents_panel.current_view.undo_action ();
	}
	
	public void on_redo ()
	{
		documents_panel.current_view.redo_action ();
	}
	
	public void on_cut ()
	{
		documents_panel.current_view.cut_action ();
	}
	
	public void on_copy ()
	{
		documents_panel.current_view.copy_action ();
	}
	
	public void on_paste ()
	{
		documents_panel.current_view.paste_action ();
	}
	
	public void on_close ()
	{
		documents_panel.current_view.close_action ();
	}
}

