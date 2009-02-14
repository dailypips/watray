/* watrayplugininfo.vala
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

internal class Watray.PluginInfo : GLib.Object
{
	private const string GROUP_NAME = "Watray Plugin";
	private string[] _authors;
	
	public string filename { private set; get; }
	public string name { private set; get; }
	public string icon { private set; get; }
	public string module { private set; get; }
	public string description { private set; get; }
	public string website { private set; get; }
	public string license { private set; get; }
	public string copyright { private set; get; }
	
	public string[] get_authors ()
	{
		return _authors;
	}
	
	public PluginInfo (string filename)
	{
		_filename = filename;
	}
	
	public bool load_info ()
	{
		//TODO: implement error domain
		var key_file = new KeyFile ();
		try
		{
			key_file.load_from_file (_filename, KeyFileFlags.NONE);
			if (!key_file.has_group (GROUP_NAME))
				throw new KeyFileError.GROUP_NOT_FOUND ("Invalid plugin file");
			_name = key_file.get_string (GROUP_NAME, "Name");
			_icon = key_file.get_string (GROUP_NAME, "Icon");
			_module = key_file.get_string (GROUP_NAME, "Module");
			_description = key_file.get_string (GROUP_NAME, "Description");
			_authors = key_file.get_string_list (GROUP_NAME, "Authors");
			_website = key_file.get_string (GROUP_NAME, "Website");
			_license = key_file.get_string (GROUP_NAME, "License");
			_copyright = key_file.get_string (GROUP_NAME, "Copyright");
			return true;
		}
		catch (Error err)
		{
			print (_filename + ": " + err.message);
			return false;
		}
	}
}
