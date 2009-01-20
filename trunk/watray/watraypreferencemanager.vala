/* watraypreferencemanager.vala
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
using GConf;

internal class Watray.PreferenceManager: GLib.Object
{
	private Client _config;
	
	private const string WATRAY_BASE_KEY = "/apps/watray";
	private const string WATRAY_PROJECTS_PANEL_VISIBLE_KEY = WATRAY_BASE_KEY + "/projects_panel_visible";
	private const string WATRAY_ACTIVATED_PLUGINS_KEY = WATRAY_BASE_KEY + "/activated_plugins";
	
	private bool _projects_panel_visible;
	
	public bool projects_panel_visible
	{
		set
		{
			_projects_panel_visible = value;
			if (_projects_panel_visible != _config.get_bool (WATRAY_PROJECTS_PANEL_VISIBLE_KEY))
				_config.set_bool (WATRAY_PROJECTS_PANEL_VISIBLE_KEY, value);
		}
		get { return _projects_panel_visible; }
	}
	
	public PreferenceManager ()
	{
		_config = Client.get_default ();
		bool schema_exists = _config.dir_exists ("/schemas" + WATRAY_BASE_KEY);
		if (!schema_exists || _config.get_schema ("/schemas" + WATRAY_PROJECTS_PANEL_VISIBLE_KEY) == null)
		{
			var schema = new Schema ();
			schema.set_short_desc (_("Show projects panel"));
			schema.set_type (ValueType.BOOL);
			var default_value = new GConf.Value (ValueType.BOOL);
			default_value.set_bool (false);
			schema.set_default_value (default_value);
			_config.set_schema ("/schemas" + WATRAY_PROJECTS_PANEL_VISIBLE_KEY, schema);
			_config.set_bool (WATRAY_PROJECTS_PANEL_VISIBLE_KEY, false);
		}
		if (!schema_exists || _config.get_schema ("/schemas" + WATRAY_ACTIVATED_PLUGINS_KEY) == null)
		{
			var schema = new Schema ();
			schema.set_short_desc (_("List of activated plugins"));
			schema.set_type (ValueType.LIST);
			schema.set_list_type (ValueType.STRING);
			var default_value = new GConf.Value (ValueType.LIST);
			default_value.set_list_type (ValueType.STRING);
			var list = new SList<string> ();
			default_value.set_list (list);
			schema.set_default_value (default_value);
			_config.set_schema ("/schemas" + WATRAY_ACTIVATED_PLUGINS_KEY, schema);
			_config.set_list (WATRAY_ACTIVATED_PLUGINS_KEY, ValueType.STRING, list);
		}
		_config.engine.associate_schema (WATRAY_PROJECTS_PANEL_VISIBLE_KEY, "/schemas" + WATRAY_PROJECTS_PANEL_VISIBLE_KEY);
		_config.engine.associate_schema (WATRAY_ACTIVATED_PLUGINS_KEY, "/schemas" + WATRAY_ACTIVATED_PLUGINS_KEY);
		_projects_panel_visible = _config.get_bool (WATRAY_PROJECTS_PANEL_VISIBLE_KEY);
		//TODO: Activate plugins
		_config.add_dir (WATRAY_BASE_KEY, ClientPreloadType.ONELEVEL);
		_config.value_changed += this.on_gconf_value_changed;
	}
	
	private void on_gconf_value_changed (Client config, string key, void* data)
	{
		switch (key)
		{
			case WATRAY_PROJECTS_PANEL_VISIBLE_KEY:
				this.projects_panel_visible = config.get_bool (WATRAY_PROJECTS_PANEL_VISIBLE_KEY);
				break;
			case WATRAY_ACTIVATED_PLUGINS_KEY:
				//TODO: do something
				break;
		}
	}
}
