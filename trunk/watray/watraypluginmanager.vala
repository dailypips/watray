/* watraypluginmanager.vala
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

internal class Watray.PluginManager : GLib.Object
{
	private string plugins_path;
	private HashTable<string, Plugin> plugins;
	private IMainWindow main_window;
	private IProjectsPanel projects_panel;
	private IDocumentsPanel documents_panel;
	
	public PluginManager (IMainWindow main_window, IProjectsPanel projects_panel, IDocumentsPanel documents_panel)
	{
		assert (Module.supported());
		this.plugins_path = Path.build_filename (Config.PACKAGE_LIBDIR, "watray", "plugins");
		plugins = new HashTable<string, Plugin> (str_hash, str_equal);
		this.main_window = main_window;
		this.projects_panel = projects_panel;
		this.documents_panel = documents_panel;
	}
	
	public void load_plugins ()
	{
		PluginInfo plugin_info;
		Plugin plugin;
		foreach (string filename in this.get_plugins_descriptors ())
		{
			plugin_info = new PluginInfo (filename);
			if (plugin_info.load_info ())
			{
				plugin = new Plugin (plugin_info);
				if (plugin.load ())
					plugins.insert (plugin_info.name, plugin);
				else
					warning ("Can't load the plugin");
			}
		}
	}
	
	public List<unowned Plugin> get_plugins ()
	{
		return plugins.get_values ();
	}
	
	public bool activate_plugin (string plugin_name)
	{
		return plugins.lookup (plugin_name).activate (this.main_window, this.projects_panel, this.documents_panel);
	}
	
	public void deactivate_plugin (string plugin_name)
	{
		plugins.lookup (plugin_name).deactivate ();
	}

	private List<string> get_plugins_descriptors ()
	{
		var list = new List<string> ();
		try
		{
			var dir = Dir.open (this.plugins_path);
			string filename;
			do
			{
				filename = dir.read_name ();
				if (filename != null && filename.has_suffix (".watrayplugin"))
					list.append (Path.build_filename (this.plugins_path, filename));
			} while (filename != null);
		}
		catch (Error err)
		{
			print (err.message);
		}
		return list;
	}
}
