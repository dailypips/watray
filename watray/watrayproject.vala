/* watrayproject.vala
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

public class Watray.Project: GLib.Object
{
	internal Gtk.TreeIter? iter = null;

	public string name { set; get; }
	
	public signal void project_selected ();
	public signal void project_activated ();
	public signal void item_selected (string item_path, void* data);
	public signal void item_activated (string item_path, void* data);
	
	public Project (string name)
	{
		this.name = name;
	}
}

