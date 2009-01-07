/* watrayprojectspanel.vala
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
using Gtk;

internal class Watray.ProjectsPanel : VBox, IProjectsPanel
{
	private TreeView projects_view;
	
	public ProjectsPanel ()
	{
		this.spacing = 5;
		this.border_width = 5;
		
		var hbox = new HBox (false, 5);
		
		var icon = new Image.from_stock (STOCK_DIRECTORY, IconSize.MENU);
		hbox.pack_start (icon, false, false, 0);
		
		var label = new Label (_("Projects"));
		label.set_alignment (0, 0);
		hbox.pack_start (label, true, true, 0);
		
		var close_button = new Button ();
		close_button.relief = ReliefStyle.NONE;
		close_button.focus_on_click = false;
		var style = new RcStyle ();
		style.xthickness = style.ythickness = 0;
		close_button.modify_style (style);
		close_button.add (new Image.from_stock (Gtk.STOCK_CLOSE, IconSize.MENU));
		close_button.clicked += () => { this.hide (); };
		hbox.pack_start (close_button, false, false, 0);
		
		this.pack_start (hbox, false, false, 0);
		
		var scrolled_window = new ScrolledWindow (null, null);
		projects_view = new TreeView ();
		scrolled_window.add (projects_view);
		scrolled_window.set_policy (PolicyType.NEVER, PolicyType.AUTOMATIC);
		this.pack_start (scrolled_window, true, true, 0);
		
		this.show_all ();
	}
}

