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

internal enum Columns
{
	STOCK_ID = 0,
	PIXBUF,
	NAME,
	PROJECT,
	DATA,
	N_COLUMNS
}

internal class Watray.ProjectsPanel : VBox, IProjectsPanel
{
	private TreeView _projects_view;
	private TreeStore _projects_store;
	
	public signal void closed ();
	
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
		close_button.clicked += () => { this.closed (); };
		hbox.pack_start (close_button, false, false, 0);
		
		this.pack_start (hbox, false, false, 0);
		
		_projects_store = new TreeStore (Columns.N_COLUMNS, typeof (string), typeof (Gdk.Pixbuf), typeof (string), typeof (Project), typeof(Value));
		_projects_view = new TreeView.with_model (_projects_store);
		_projects_view.row_activated += on_row_activated;
		_projects_view.get_selection ().changed += on_row_changed;

		CellRenderer renderer = new CellRendererPixbuf ();
		var column = new TreeViewColumn ();
 		column.pack_start (renderer, false);
		column.add_attribute (renderer, "stock-id", Columns.STOCK_ID);
		column.add_attribute (renderer, "pixbuf", Columns.PIXBUF);
		renderer = new CellRendererText ();
		column.pack_start (renderer, true);
		column.add_attribute (renderer, "text", Columns.NAME);
		_projects_view.append_column (column);
		_projects_view.set_headers_visible (false);

		var scrolled_window = new ScrolledWindow (null, null);
		scrolled_window.add (_projects_view);
		scrolled_window.set_policy (PolicyType.NEVER, PolicyType.AUTOMATIC);
		this.pack_start (scrolled_window, true, true, 0);
		
		this.show_all ();
	}
	
	public void add_project (Project project)
	{
		project.add_to_projects_store (_projects_store);
	}
	
	public void remove_project (Project project) throws ProjectError
	{
		project.remove_from_projects_store ();
	}
	
	private string get_item_path_from_iter (TreePath path)
	{
		string item_path = "";
		string str;
		TreeIter iter;
		do
		{
			_projects_store.get_iter (out iter, path);
			_projects_store.get (iter, Columns.NAME, out str);
			item_path = "/" + str + item_path;
			path.up ();
		} while (path.get_depth () > 1);
		return item_path;
	}
	
	private void on_row_activated (TreeView view, TreePath path, TreeViewColumn column)
	{
		TreeIter iter;
		Project project;
		_projects_store.get_iter (out iter, path);
		_projects_store.get (iter, Columns.PROJECT, out project);
		if (path.get_depth () == 1)
			project.activated ();
		else
		{
			string item_path = get_item_path_from_iter (path);
			project.item_activated (item_path);
		}
	}
	
	private void on_row_changed (TreeSelection selection)
	{
		TreeIter iter;
		Project project;
		selection.get_selected (null, out iter);
		_projects_store.get (iter, Columns.PROJECT, out project);
		if (_projects_store.iter_depth (iter) == 0)
			project.selected ();
		else
		{
			string item_path = get_item_path_from_iter (_projects_store.get_path (iter));
			project.item_selected (item_path);
		}
	}
}

