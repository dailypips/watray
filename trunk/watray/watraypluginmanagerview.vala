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
	
	private enum Columns
	{
		ACTIVATED,
		ICON,
		TEXT,
		N_COLUMNS
	}
	
	public PluginManagerView (PluginManager plugin_manager)
	{
		_plugin_manager = plugin_manager;
		this.border_width = 5;
		
		var title = new Label (_("<b>Loaded Plugins</b>"));
		title.use_markup = true;
		title.set_alignment (0, 0);
		this.pack_start (title, false, false, 5);
		
		_plugins_store = new Gtk.ListStore (Columns.N_COLUMNS, typeof (bool), typeof (string), typeof (string));
		_plugins_view = new TreeView.with_model (_plugins_store);
		
		var toggle = new CellRendererToggle ();
		var column = new TreeViewColumn ();
		column.pack_start (toggle, false);
		column.add_attribute (toggle, "active", Columns.ACTIVATED);
		var pixbuf = new CellRendererPixbuf ();
		pixbuf.stock_size = IconSize.SMALL_TOOLBAR;
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
		
		this.pack_start (scrolled_window, true, true, 5);
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
			_plugins_store.set (iter, Columns.ACTIVATED, plugin.is_activated, Columns.ICON, plugin.plugin_info.icon, Columns.TEXT, text);
		}
	}
} 
