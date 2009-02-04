/* simpledocumentmanager.vala
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
using Watray;
using Gtk;

public class Simple.DocumentManager : GLib.Object
{
	private IDocumentsPanel _documents_panel;
	private IProjectsPanel _projects_panel;
	private ConfigureManager _configure_manager;
	
	public DocumentManager (IDocumentsPanel documents_panel, IProjectsPanel projects_panel, ConfigureManager configure_manager)
	{
		_documents_panel = documents_panel;
		_projects_panel = projects_panel;
		_configure_manager = configure_manager;
	}
	
	public void open ()
	{
		var dialog = new FileChooserDialog (_("Open"), null, FileChooserAction.OPEN);
		dialog.add_button (STOCK_CANCEL, ResponseType.CANCEL);
		dialog.add_button (STOCK_OPEN, ResponseType.OK);
		dialog.set_default_response (ResponseType.OK);
		var filter = new FileFilter ();
		filter.set_name (_("All files"));
		filter.add_pattern ("*");
		dialog.add_filter (filter);
		
		if (dialog.run ()==ResponseType.OK)
		{
			var view = new DocumentView (dialog.get_filename (), _configure_manager);
			view.close_action += (document_view) => { this.on_close_document (document_view); };
			view.open ();
			_documents_panel.add_view (view);
		}
		dialog.destroy ();
	}
	
	private void on_close_document (DocumentView document_view)
	{
		if (document_view.tab_mark)
		{
			var message = new MessageDialog (null, DialogFlags.MODAL, MessageType.WARNING, ButtonsType.NONE, _("Want to save the document %s?"), document_view.tab_text);
			message.add_button (STOCK_YES, ResponseType.YES);
			message.add_button (STOCK_NO, ResponseType.NO);
			message.add_button (STOCK_CANCEL, ResponseType.CANCEL);
			switch (message.run ())
			{
				case ResponseType.YES:
					document_view.save ();
					_documents_panel.remove_view (document_view);
					break;
				case ResponseType.NO:
					_documents_panel.remove_view (document_view);
					break;
			}
			message.destroy ();
		}
		else
			_documents_panel.remove_view (document_view);
	}
}
