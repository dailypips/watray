/* watraydocumentspanelinterface.vala
 * 
 * Coyright (C) 2008 Matias de la Puente
 */

public interface Watray.IDocumentsPanel: GLib.Object
{
	public abstract void add_view (DocumentsPanelView view);
	public abstract void remove_view (DocumentsPanelView view);
}
