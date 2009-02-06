/* watraydocumentspanel.vala
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

internal class Watray.DocumentsPanel : Gtk.Notebook, IDocumentsPanel
{
	public DocumentView current_view { private set; get; }
	
	public DocumentsPanel ()
	{
		this.switch_page += (panel, page, page_num) => {
			current_view = (DocumentView)this.get_nth_page ((int)page_num);
			this.view_selected (current_view);
		};
	}

	public void add_view (DocumentView view)
	{
		append_page (view, view.tab_label);
	}
	
	public void remove_view (DocumentView view)
	{
		remove_page (this.page_num (view));
	}
	
	public void show_view (DocumentView view)
	{
		set_current_page (this.page_num (view));
	}
}

