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
	private string _filename;
	
	public string filename
	{
		private set
		{
			this._filename = value;
			this.path = Path.get_dirname (this._filename);
		}
		get { return this._filename; }
	}
	public string path { private set; get; }
	public string name { private set; get; }
	public string icon { private set; get; }
	public string module { private set; get; }
	public string description { private set; get; }
	public string authors { private set; get; }
	public string license { private set; get; }
	
	public PluginInfo (string filename)
	{
		this.filename = filename;
	}
	
	public bool load_info ()
	{
		var key_file = new KeyFile ();
		try
		{
			key_file.load_from_file (this.filename, KeyFileFlags.NONE);
			if (!key_file.has_group (GROUP_NAME))
				throw new KeyFileError.GROUP_NOT_FOUND ("Invalid plugin file");
			this.name = key_file.get_string (GROUP_NAME, "Name");
			this.icon = key_file.get_string (GROUP_NAME, "Icon");
			this.module = key_file.get_string (GROUP_NAME, "Module");
			this.description = key_file.get_string (GROUP_NAME, "Description");
			this.authors = key_file.get_string (GROUP_NAME, "Authors");
			this.license = key_file.get_string (GROUP_NAME, "License");
			return true;
		}
		catch (Error err)
		{
			print (this.filename + ": " + err.message);
			return false;
		}
	}
}
