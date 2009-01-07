/* watrayprojectspanelitem.vala
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

public class Watray.ProjectsPanelItem: GLib.Object
{
	private List<ProjectsPanelItem> childs = new List<ProjectsPanelItem> ();

	public ProjectsPanelItem parent { construct; get; }
	public string text { set; get; }
	public string icon { set; get; }
	public string data { set; get; }
	
	public ProjectsPanelItem (ProjectsPanelItem parent)
	{
		this.parent = parent;
	}
	
	public void add (ProjectsPanelItem item)
	{
		this.childs.append (item);
	}
	
	public void remove (ProjectsPanelItem item)
	{
		this.childs.remove (item);
	}
	
	public void clear ()
	{
		this.childs = new List<ProjectsPanelItem> ();
	}
	
	public List<weak ProjectsPanelItem> get_childs ()
	{
		return this.childs.copy ();
	}
}
