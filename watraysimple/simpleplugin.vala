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
	private ConfigureManager _configure_manager;
	
	private const string _ui = """
	<ui>
		<menubar name="MainMenu">
			<menu name="FileMenu" action="FileMenuAction">
				<menu name="NewMenu" action="NewMenuAction">
					<placeholder name="NewMenuOps">
						<menuitem action="NewTextFileAction"/>
					</placeholder>
				</menu>
				<menu name="OpenMenu" action="OpenMenuAction">
					<placeholder name="OpenMenuOps">
						<menuitem action="OpenTextFileAction"/>
					</placeholder>
				</menu>
			</menu>
		</menubar>
		<popup name="NewPopup" action="NewPopupAction">
			<placeholder name="NewPopupOps">
				<menuitem action="NewTextFileAction"/>
			</placeholder>
		</popup>
		<popup name="OpenPopup" action="OpenPopupAction">
			<placeholder name="OpenPopupOps">
				<menuitem action="OpenTextFileAction"/>
			</placeholder>
		</popup>
	</ui>""";
	private uint _ui_id;
	private const ActionEntry[] _action_entries =
	{
		{ "NewTextFileAction", STOCK_FILE, N_("Text file"), null, null, on_new},
		{ "OpenTextFileAction", STOCK_FILE, N_("Text file"), null, null, on_open}
	};
	
	public IProjectsPanel projects_panel { construct set; get; }
	public IDocumentsPanel documents_panel { construct set; get; }
	public IMainWindow main_window { construct set; get; }
	
	construct
	{
		_configure_manager = new ConfigureManager ();
		_document_manager = new DocumentManager (documents_panel, _configure_manager);
		_project_manager = new ProjectManager (projects_panel, _configure_manager);
		
		var action_group = new ActionGroup ("SimplePluginActions");
		action_group.set_translation_domain (Config.GETTEXT_PACKAGE);
		action_group.add_actions (_action_entries, this);

		var ui_manager = this.main_window.get_ui_manager ();
		ui_manager.insert_action_group (action_group, -1);
		_ui_id = ui_manager.add_ui_from_string (_ui, -1);
		
		this.on_configure_action += () => {
			var configure_dialog = new ConfigureDialog (_configure_manager);
			configure_dialog.run ();
			configure_dialog.destroy ();
		};
	}
	
	~Plugin ()
	{
		var ui_manager = this.main_window.get_ui_manager ();
		ui_manager.remove_ui (_ui_id);
	}
	
	private void on_new ()
	{
		
	}
	
	private void on_open ()
	{
		_document_manager.open ();
	}
}

[ModuleInit]
public GLib.Type register_watray_plugin ()
{
	return typeof (Simple.Plugin);
}

