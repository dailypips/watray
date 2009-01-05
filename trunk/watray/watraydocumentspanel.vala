/* watraydocumentspanel.vala
 * 
 * Coyright (C) 2008 Matias de la Puente
 */
using Gtk;

internal class Watray.DocumentsPanel : Gtk.Notebook, IDocumentsPanel
{
	public DocumentsPanelView current_view { private set; get; }
	
	public DocumentsPanel ()
	{
		this.switch_page += (panel, page, page_num) => { current_view = (DocumentsPanelView)this.get_nth_page ((int)page_num); };
	}

	public void add_view (DocumentsPanelView view)
	{
		this.append_page (view, view.tab_label);
	}
	
	public void remove_view (DocumentsPanelView view)
	{
		var page_num = NotebookPage.num (this, view);
		this.remove_page (page_num);
	}
}

