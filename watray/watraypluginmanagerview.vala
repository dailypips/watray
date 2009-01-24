/* watraypluginmanagerview.vala
 *
 * Copyright (C) 2009  Matias De la Puente
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

internal class Watray.PluginManagerView: VBox
{
	private ListStore _plugins_store;
	private TreeView _plugins_view;
	private PluginManager _plugin_manager;
	private PreferenceManager _preference_manager;
	
	private enum Columns
	{
		ACTIVATED,
		ICON,
		NAME,
		TEXT,
		N_COLUMNS
	}
	
	public PluginManagerView (PluginManager plugin_manager, PreferenceManager preference_manager)
	{
		_plugin_manager = plugin_manager;
		_preference_manager = preference_manager;
		this.border_width = 5;
		
		var title = new Label ("<b>" + _("Loaded Plugins") + "</b>");
		title.use_markup = true;
		title.set_alignment (0, 0);
		this.pack_start (title, false, false, 5);
		
		_plugins_store = new ListStore (Columns.N_COLUMNS, typeof (bool), typeof (string), typeof (string), typeof (string));
		_plugins_view = new TreeView.with_model (_plugins_store);
		
		var toggle = new CellRendererToggle ();
		toggle.toggled += (toggle, path) => {
			TreeIter iter;
			var tree_path = new TreePath.from_string (path);
			_plugins_store.get_iter (out iter, tree_path);
			string plugin_name;
			_plugins_store.get (iter, Columns.NAME, out plugin_name);
			if (toggle.active)
			{
				_plugin_manager.deactivate_plugin (plugin_name);
				_preference_manager.remove_activated_plugin (plugin_name);
			}
			else
			{
				_plugin_manager.activate_plugin (plugin_name);
				_preference_manager.add_activated_plugin (plugin_name);
			}
			_plugins_store.set (iter, Columns.ACTIVATED, !toggle.active);
		};

		var column = new TreeViewColumn ();
		column.pack_start (toggle, false);
		column.add_attribute (toggle, "active", Columns.ACTIVATED);
		_plugins_view.append_column (column);
		
		var pixbuf = new CellRendererPixbuf ();
		pixbuf.stock_size = IconSize.SMALL_TOOLBAR;
 		
 		column = new TreeViewColumn ();
 		column.pack_start (pixbuf, false);
		column.add_attribute (pixbuf, "stock-id", Columns.ICON);
		
		var text = new CellRendererText ();

		column.pack_start (text, true);
		column.add_attribute (text, "markup", Columns.TEXT);
		_plugins_view.append_column (column);
		_plugins_view.set_rules_hint (true);
		_plugins_view.set_headers_visible (false);
		
		var scrolled_window = new ScrolledWindow (null, null);
		scrolled_window.add (_plugins_view);
		scrolled_window.set_policy (PolicyType.NEVER, PolicyType.AUTOMATIC);
		
		var hbox = new HBox (false, 5);
		hbox.border_width = 5;
		var button = new Button.with_label (_("About plugin"));
		button.image = new Image.from_stock (STOCK_ABOUT, IconSize.BUTTON);
		button.clicked += on_about_plugin_clicked;
		hbox.pack_start (button, false, false, 0);
		button = new Button.with_label (_("Configure plugin"));
		button.image = new Image.from_stock (STOCK_PREFERENCES, IconSize.BUTTON);
		hbox.pack_start (button, false, false, 0);
		
		this.pack_start (scrolled_window, true, true, 5);
		this.pack_start (hbox, false, false, 5);
		this.show_all ();
	}
	
	public void refresh_plugin_list ()
	{
		_plugins_store.clear ();
		TreeIter iter;
		foreach (Plugin plugin in _plugin_manager.get_plugins ())
		{
			_plugins_store.append (out iter);
			string text = "<b>" + plugin.plugin_info.name + "</b>\n" + plugin.plugin_info.description;
			_plugins_store.set (iter, Columns.ACTIVATED, plugin.is_activated, Columns.ICON, plugin.plugin_info.icon, Columns.NAME, plugin.plugin_info.name, Columns.TEXT, text);
		}
	}
	
	private void on_about_plugin_clicked (Button button)
	{
		TreeIter iter;
		if (_plugins_view.get_selection ().get_selected (null, out iter))
		{
			string plugin_name;
			_plugins_store.get (iter, Columns.NAME, out plugin_name);
			var plugin_info = _plugin_manager.get_plugin (plugin_name).plugin_info;
			var about_dialog = new AboutDialog ();
			about_dialog.authors = plugin_info.get_authors ();
			about_dialog.comments = plugin_info.description;
			about_dialog.logo_icon_name = plugin_info.icon;
			about_dialog.website = plugin_info.website;
			about_dialog.program_name = plugin_info.name;
			about_dialog.copyright = plugin_info.copyright;
			about_dialog.run ();
			about_dialog.destroy ();
		}
	}
} 
