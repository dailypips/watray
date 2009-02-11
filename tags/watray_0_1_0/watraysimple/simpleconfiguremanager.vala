/* simpleconfiguremanager.vala
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
using GConf;

public class Simple.ConfigureManager : GLib.Object
{
	private Client _config;
	
	private const string SIMPLE_BASE_KEY = "/apps/watray/plugins/simple";
	private const string SIMPLE_TEXT_FILES_VISIBLE_KEY = SIMPLE_BASE_KEY + "/text_files_visible";
	private const string SIMPLE_TEXT_FONT_KEY = SIMPLE_BASE_KEY + "/text_font";
	
	private bool _text_files_visible;
	
	public bool text_files_visible
	{
		set
		{
			_text_files_visible = value;
			if (_text_files_visible != _config.get_bool (SIMPLE_TEXT_FILES_VISIBLE_KEY))
				_config.set_bool (SIMPLE_TEXT_FILES_VISIBLE_KEY, value);
		}
		get { return _text_files_visible; }
	}
	
	private string _text_font;
	
	public string text_font
	{
		set
		{
			_text_font = value;
			if (_text_font != _config.get_string (SIMPLE_TEXT_FONT_KEY))
				_config.set_string (SIMPLE_TEXT_FONT_KEY, value);
		}
		get { return _text_font; }
	}
	
	public ConfigureManager ()
	{
		_config = Client.get_default ();
		bool schema_exists = _config.dir_exists ("/schemas" + SIMPLE_BASE_KEY);
		if (!schema_exists || _config.get_schema ("/schemas" + SIMPLE_TEXT_FILES_VISIBLE_KEY) == null)
		{
			var schema = new Schema ();
			schema.set_short_desc (_("Show opened text files"));
			schema.set_type (ValueType.BOOL);
			var default_value = new GConf.Value (ValueType.BOOL);
			default_value.set_bool (false);
			schema.set_default_value (default_value);
			_config.set_schema ("/schemas" + SIMPLE_TEXT_FILES_VISIBLE_KEY, schema);
			_config.set_bool (SIMPLE_TEXT_FILES_VISIBLE_KEY, false);
		}
		if (!schema_exists || _config.get_schema ("/schemas" + SIMPLE_TEXT_FONT_KEY) == null)
		{
			var schema = new Schema ();
			schema.set_short_desc (_("Text font"));
			schema.set_type (ValueType.STRING);
			var default_value = new GConf.Value (ValueType.STRING);
			default_value.set_string ("Monospace 10");
			schema.set_default_value (default_value);
			_config.set_schema ("/schemas" + SIMPLE_TEXT_FONT_KEY, schema);
			_config.set_string (SIMPLE_TEXT_FONT_KEY, "Monospace 10");
		}
		_config.engine.associate_schema (SIMPLE_TEXT_FILES_VISIBLE_KEY, "/schemas" + SIMPLE_TEXT_FILES_VISIBLE_KEY);
		_config.engine.associate_schema (SIMPLE_TEXT_FONT_KEY, "/schemas" + SIMPLE_TEXT_FONT_KEY);
		_text_files_visible = _config.get_bool (SIMPLE_TEXT_FILES_VISIBLE_KEY);
		_text_font = _config.get_string (SIMPLE_TEXT_FONT_KEY);
		_config.add_dir (SIMPLE_BASE_KEY, ClientPreloadType.ONELEVEL);
		_config.value_changed += this.on_gconf_value_changed;
	}
	
	private void on_gconf_value_changed (Client config, string key, void* data)
	{
		switch (key)
		{
			case SIMPLE_TEXT_FILES_VISIBLE_KEY:
				this.text_files_visible = config.get_bool (key);
				break;
			case SIMPLE_TEXT_FONT_KEY:
				this.text_font = config.get_string (key);
				break;
		}
	}
}
