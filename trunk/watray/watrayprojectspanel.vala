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

public errordomain Watray.ProjectError
{
	PROJECT_NOT_ADDED,
	WRONG_ITEM_PATH
}

internal class Watray.ProjectsPanel : VBox, IProjectsPanel
{
	private TreeView _projects_view;
	private TreeStore _projects_store;
	
	private enum Columns
	{
		STOCK_ID = 0,
		PIXBUF,
		ITEM_NAME,
		PROJECT,
		ITEM_DATA,
		N_COLUMNS
	}

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
		
		_projects_store = new TreeStore (Columns.N_COLUMNS, typeof (string), typeof (Gdk.Pixbuf), typeof (string), typeof (Project), typeof(void*));
		_projects_view = new TreeView.with_model (_projects_store);
		_projects_view.row_activated += (view, path, column) => { this.on_row_activated (view, path, column); };

		CellRenderer renderer = new CellRendererPixbuf ();
		var column = new TreeViewColumn ();
 		column.pack_start (renderer, false);
		column.add_attribute (renderer, "stock-id", Columns.STOCK_ID);
		column.add_attribute (renderer, "pixbuf", Columns.PIXBUF);
		renderer = new CellRendererText ();
		column.pack_start (renderer, true);
		column.add_attribute (renderer, "text", Columns.ITEM_NAME);
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
		_projects_store.append (out project.iter, null);
		_projects_store.set (project.iter, Columns.STOCK_ID, STOCK_DIRECTORY, Columns.ITEM_NAME, project.name, Columns.PROJECT, project, -1);
		
	}
	
	public void remove_project (Project project)
	{
		
	}
	
	public void create_item (Project project, string item_path, void* data = null) throws ProjectError
	{
		var parent_iter = get_iter_from_item_path (project, Path.get_dirname (item_path));
		TreeIter new_item_iter;
		_projects_store.append (out new_item_iter, parent_iter);
		_projects_store.set (new_item_iter, Columns.ITEM_NAME, Path.get_basename (item_path), Columns.PROJECT, project, Columns.ITEM_DATA, data);
	}
	
	public void create_item_from_stock (Project project, string item_path, string stock_id, void*data = null) throws ProjectError
	{
		var parent_iter = get_iter_from_item_path (project, Path.get_dirname (item_path));
		TreeIter new_item_iter;
		_projects_store.append (out new_item_iter, parent_iter);
		_projects_store.set (new_item_iter, Columns.STOCK_ID, stock_id, Columns.ITEM_NAME, Path.get_basename (item_path), Columns.PROJECT, project, Columns.ITEM_DATA, data);
	}
	
	public void create_item_from_pixbuf (Project project, string item_path, Gdk.Pixbuf pixbuf, void*data = null) throws ProjectError
	{
		var parent_iter = get_iter_from_item_path (project, Path.get_dirname (item_path));
		TreeIter new_item_iter;
		_projects_store.append (out new_item_iter, parent_iter);
		_projects_store.set (new_item_iter, Columns.PIXBUF, pixbuf, Columns.ITEM_NAME, Path.get_basename (item_path), Columns.PROJECT, project, Columns.ITEM_DATA, data);
	}
	
	public void remove_item (Project project, string item_path) throws ProjectError
	{
		
	}

	public void set_item_data (Project project, string item_path, void* data) throws ProjectError
	{
		var iter = get_iter_from_item_path (project, item_path);
		_projects_store.set (iter, Columns.ITEM_DATA, data);
	}
	
	public void* get_item_data (Project project, string item_path) throws ProjectError
	{
		var iter = get_iter_from_item_path (project, item_path);
		void* data;
		_projects_store.get (iter, Columns.ITEM_DATA, out data);
		return data;
	}
	
	public void set_item_icon_from_stock (Project project, string item_path, string stock_id) throws ProjectError
	{
		var item_iter = get_iter_from_item_path (project, item_path);
		_projects_store.set (item_iter, Columns.STOCK_ID, stock_id);
	}
	
	public void set_item_icon_from_pixbuf (Project project, string item_path, Gdk.Pixbuf pixbuf) throws ProjectError
	{
		var item_iter = get_iter_from_item_path (project, item_path);
		_projects_store.set (item_iter, Columns.PIXBUF, pixbuf);
	}
	
	private TreeIter? get_iter_from_item_path (Project project, string item_path) throws ProjectError
	{
		if (project.iter == null)
			throw new ProjectError.PROJECT_NOT_ADDED ("The project %s was not added", project.name);
		TreeIter parent_iter = project.iter;
		if (item_path == "/")
			return parent_iter;
		foreach (string item_name in item_path.split ("/"))
		{
			if (item_name!="")
			{
				if (!_projects_store.iter_has_child (parent_iter))
					throw new ProjectError.WRONG_ITEM_PATH ("Item %s not founded", item_name);
				TreeIter iter;
				bool item_founded = false;
				for (int i=0; i<_projects_store.iter_n_children (parent_iter); i++)
				{
					string name;
					_projects_store.iter_nth_child (out iter, parent_iter, i);
					_projects_store.get (iter, Columns.ITEM_NAME, out name);
					if (name==item_name)
					{
						item_founded = true;
						parent_iter = iter;
						break;
					}
				}
				if (!item_founded)
					throw new ProjectError.WRONG_ITEM_PATH ("Item %s not founded", item_name);
			}
		}
		return parent_iter;
	}
	
	private string get_item_path_from_iter (TreePath path)
	{
		string item_path = "";
		string str;
		TreeIter iter;
		do
		{
			_projects_store.get_iter (out iter, path);
			_projects_store.get (iter, Columns.ITEM_NAME, out str);
			item_path = "/" + str + item_path;
			path.up ();
		} while (path.get_depth () > 1);
		return item_path;
	}
	
	private void on_row_activated (TreeView view, TreePath path, TreeViewColumn column)
	{
		TreeIter iter;
		_projects_store.get_iter (out iter, path);
		Project project;
		_projects_store.get (iter, Columns.PROJECT, out project);
		if (path.get_depth () == 1)
			project.project_activated ();
		else
		{
			string item_path = get_item_path_from_iter (path);
			void* data;
			_projects_store.get (iter, Columns.ITEM_DATA, out data);
			project.item_activated (item_path, data);
		}
	}
}

