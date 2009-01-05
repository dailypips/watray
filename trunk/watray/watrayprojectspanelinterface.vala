/* watrayprojectspanelinterface.vala
 * 
 * Coyright (C) 2008 Matias de la Puente
 */

public interface Watray.IProjectsPanel : GLib.Object
{
	public signal void item_selected (ProjectsPanelItem item);
	public signal void item_activated (ProjectsPanelItem item);
	public signal void item_removed (ProjectsPanelItem item);
}
