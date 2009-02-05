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
	private ConfigureManager _configure_manager;
	
	public IProjectsPanel projects_panel { construct set; get; }
	public IDocumentsPanel documents_panel { construct set; get; }
	public IMainWindow main_window { construct set; get; }
	
	construct
	{
		_configure_manager = new ConfigureManager ();
		_document_manager = new DocumentManager (main_window, documents_panel, projects_panel, _configure_manager);
		
		this.on_configure_action += () => {
			var configure_dialog = new ConfigureDialog (_configure_manager);
			configure_dialog.run ();
			configure_dialog.destroy ();
		};
	}
}

[ModuleInit]
public GLib.Type register_watray_plugin ()
{
	return typeof (Simple.Plugin);
}

