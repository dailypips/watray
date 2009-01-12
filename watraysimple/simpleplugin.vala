/* simpleplugin.vala
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
using Watray;
using Gtk;

public class Simple.Plugin : GLib.Object, IPlugin
{
	private DocumentManager _document_manager;
	private ProjectManager _project_manager;
	
	public IProjectsPanel projects_panel { construct set; get; }
	public IDocumentsPanel documents_panel { construct set; get; }
	public IMainWindow main_window { construct set; get; }
	
	construct
	{
		_document_manager = new DocumentManager (documents_panel);
		var new_item = new ImageMenuItem.with_label (_("Text file"));
		new_item.image = new Image.from_stock (STOCK_FILE, IconSize.MENU);
		main_window.add_menu_item (MenuType.NEW, new_item);

		var open_item = new ImageMenuItem.with_label (_("Text file"));
		open_item.image = new Image.from_stock (STOCK_FILE, IconSize.MENU);
		open_item.activate += () => { _document_manager.open (); };
		main_window.add_menu_item (MenuType.OPEN, open_item);
		
		_project_manager = new ProjectManager (projects_panel);
	}
}

[ModuleInit]
public GLib.Type register_watray_plugin ()
{
	return typeof (Simple.Plugin);
}

