/* watraypreferencedialog.vala
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

internal class Watray.PreferenceDialog: Gtk.Dialog
{
	public PreferenceDialog (PluginManager plugin_manager)
	{
		this.title = _("Preferences");
		this.has_separator = false;
		
		this.vbox.border_width = 5;
		
		var notebook = new Notebook ();
		this.vbox.pack_start (notebook, true, true, 5);
		
		var plugin_manager_view = new PluginManagerView (plugin_manager);
		plugin_manager_view.refresh_plugin_list ();
		
		notebook.append_page (plugin_manager_view, new Label (_("Plugins")));
		
		this.add_button (STOCK_CLOSE, ResponseType.CLOSE);
		this.show_all ();
	}
}
