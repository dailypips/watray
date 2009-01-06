/* simpledocumentmanager.vala
 *
 * Coyright (C) 2008 Matias de la Puente
 */
using Watray;
using Gtk;

public class Simple.DocumentManager : GLib.Object
{
	private IDocumentsPanel _documents_panel;
	
	public DocumentManager (IDocumentsPanel documents_panel)
	{
		_documents_panel = documents_panel;
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
			var view = new DocumentView (dialog.get_filename ());
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
