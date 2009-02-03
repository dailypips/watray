/* watraymainwindow.vala
 *
 * Copyright (C) 2008-2009  Matias De la Puente
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.

 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.

 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
 *
 * Author:
 * 	Matias De la Puente <mfpuente.ar@gmail.com>
 */
using Gtk;
using GConf;

internal class Watray.MainWindow : Window, IMainWindow
{
	private const ActionEntry[] action_entries = 
	{
		{ "FileMenuAction", null, N_("_File") },
			{ "SaveAction", STOCK_SAVE, null, null, null, on_save },
			{ "SaveAsAction", STOCK_SAVE_AS, null, null, null, on_save_as },
			{ "PrintAction", STOCK_PRINT, null, null, null, on_print },
			{ "CloseAction", STOCK_CLOSE, null, null, null, on_close },
			{ "QuitAction", STOCK_QUIT, null, null, null, on_quit },
		{ "EditMenuAction", null, N_("_Edit") },
			{ "UndoAction", STOCK_UNDO, null, null, null, on_undo },
			{ "RedoAction", STOCK_REDO, null, null, null, on_redo },
			{ "CutAction", STOCK_CUT, null, null, null, on_cut },
			{ "CopyAction", STOCK_COPY, null, null, null, on_copy },
			{ "PasteAction", STOCK_PASTE, null, null, null, on_paste },
			{ "FindAction", STOCK_FIND, null, null, null, on_quit },
			{ "FindAndReplaceAction", STOCK_FIND_AND_REPLACE, null, null, null, on_quit },
			{ "PreferencesAction", STOCK_PREFERENCES, null, null, null, on_preferences },
		{ "ViewMenuAction", null, N_("_View") },
		{ "ToolsMenuAction", null, N_("_Tools") },
		{ "HelpMenuAction", null, N_("_Help") },
			{ "AboutAction", STOCK_ABOUT, null, null, null, on_about },
		{ "NewMenuAction", STOCK_NEW },
		{ "OpenMenuAction", STOCK_OPEN },
		{ "NewPopupAction" },
		{ "OpenPopupAction" }
	};
	
	private const ToggleActionEntry[] toggle_action_entries =
	{
		{ "ViewProjectsPanelAction", null, N_("Projects Panel"), null, null, on_show_projects_panel, false }
	};

	private ActionGroup _action_group;
	private UIManager _ui_manager = new UIManager ();
	private DocumentsPanel _documents_panel = new DocumentsPanel ();
	private ProjectsPanel _projects_panel = new ProjectsPanel ();
	private PluginManager _plugin_manager;
	private PreferenceManager _preference_manager;
	
	public static void main (string[] args)
	{
		Gtk.init (ref args);
		AboutDialogActivateLinkFunc url_hook_func = (dialog, url) => {
			Gtk.show_uri (dialog.get_screen (), url, Gdk.CURRENT_TIME);
		};
		AboutDialog.set_url_hook (url_hook_func);
		var main_window = new MainWindow ();
		main_window.show ();
		Gtk.main ();
	}

	public MainWindow ()
	{
		this.title = "Watray";
		this.destroy += on_quit;
		this.set_size_request (1000, 500);
		
		_action_group = new ActionGroup ("WatrayActions");
		_action_group.set_translation_domain (Config.GETTEXT_PACKAGE);
		_action_group.add_actions (action_entries, this);
		_action_group.add_toggle_actions (toggle_action_entries, this);

		_ui_manager.insert_action_group (_action_group, 0);
		try
		{
			_ui_manager.add_ui_from_file (Path.build_filename (Config.PACKAGE_DATADIR, "ui", "ui.xml"));
		}
		catch (GLib.Error err)
		{
			error (err.message);
		}
		
		var menubar = (MenuBar)_ui_manager.get_widget ("/MainMenu");
		var toolbar = (Toolbar)_ui_manager.get_widget ("/MainToolbar");
		
		Gtk.Callback non_homogeneous = (item) => { ((ToolItem)item).set_homogeneous (false); };
		toolbar.foreach (non_homogeneous);
		
		var popup = (Menu)_ui_manager.get_widget ("/NewPopup");
		var toolbutton = new MenuToolButton.from_stock (STOCK_NEW);
		toolbutton.set_menu (popup);
		toolbar.insert (toolbutton, 0);
		
		popup = (Menu)_ui_manager.get_widget ("/OpenPopup");
		toolbutton = new MenuToolButton.from_stock (STOCK_OPEN);
		toolbutton.set_menu (popup);
		toolbar.insert (toolbutton, 1);
		toolbar.show_all ();
		
		_preference_manager = new PreferenceManager ();

		_preference_manager.notify["projects-panel-visible"] += () => {
			this.update_projects_panel_visibility ();
		};

		this.update_projects_panel_visibility ();
		
		_projects_panel.closed += () => {
			_preference_manager.projects_panel_visible = false;
		};
		
		var vpaned = new VPaned ();
		vpaned.pack1 (_documents_panel, true, false);
		vpaned.show_all ();
		
		var hpaned = new HPaned ();
		hpaned.add1 (_projects_panel);
		hpaned.add2 (vpaned);
		hpaned.show ();
	
		var vbox = new VBox (false, 0);
		vbox.pack_start (menubar, false, false, 0);
		vbox.pack_start (toolbar, false, false, 0);
		vbox.pack_start_defaults (hpaned);
		vbox.show ();

		this.add (vbox);
		this.add_accel_group (_ui_manager.get_accel_group ());
		
		_plugin_manager = new PluginManager (this, _projects_panel, _documents_panel);
		_plugin_manager.load_plugins ();
		foreach (string plugin_name in _preference_manager.get_activated_plugins ())
		{
			_plugin_manager.activate_plugin (plugin_name);
		}
	}
	
	public UIManager get_ui_manager ()
	{
		return _ui_manager;
	}
	
	public void on_save ()
	{
		_documents_panel.current_view.save_action ();
	}
	
	public void on_save_as ()
	{
		_documents_panel.current_view.save_as_action ();
	}
	
	public void on_print ()
	{
		_documents_panel.current_view.print_action ();
	}
	
	public void on_quit ()
	{
		//documents_panel.close_all ();
		Gtk.main_quit ();
	}
	
	public void on_undo ()
	{
		_documents_panel.current_view.undo_action ();
	}
	
	public void on_redo ()
	{
		_documents_panel.current_view.redo_action ();
	}
	
	public void on_cut ()
	{
		_documents_panel.current_view.cut_action ();
	}
	
	public void on_copy ()
	{
		_documents_panel.current_view.copy_action ();
	}
	
	public void on_paste ()
	{
		_documents_panel.current_view.paste_action ();
	}
	
	public void on_close ()
	{
		_documents_panel.current_view.close_action ();
	}
	
	public void on_show_projects_panel ()
	{
		var toggle_action = (ToggleAction)_action_group.get_action ("ViewProjectsPanelAction");
		_preference_manager.projects_panel_visible = toggle_action.active;
	}
	
	public void on_preferences ()
	{
		var dialog = new PreferenceDialog (_plugin_manager, _preference_manager);
		dialog.run ();
		dialog.destroy ();
	}
	
	public void on_about ()
	{
		var about_dialog = new AboutDialog ();
		about_dialog.title = Config.PACKAGE_NAME;
		about_dialog.comments = "General purpose IDE";
		about_dialog.version = Config.PACKAGE_VERSION;
		about_dialog.authors = new string[] { "Matias De la Puente <mfpuente.ar@gmail.com>" };
		about_dialog.copyright = "Copyright (C) 2008-2009  Matias De la Puente";
		about_dialog.website = "http://code.google.com/p/watray/";
		about_dialog.run ();
		about_dialog.destroy ();
	}
	
	private void update_projects_panel_visibility ()
	{
		_projects_panel.visible = _preference_manager.projects_panel_visible;
		var toggle_action = (ToggleAction)_action_group.get_action ("ViewProjectsPanelAction");
		toggle_action.active = _preference_manager.projects_panel_visible;
	}
}

