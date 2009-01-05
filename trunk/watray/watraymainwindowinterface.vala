/* watraymainwindowinterface.vala
 * 
 * Coyright (C) 2008 Matias de la Puente
 */

public enum Watray.MenuType
{
	NEW,
	OPEN
}

public interface Watray.IMainWindow : GLib.Object
{
	public abstract void add_menu_item (MenuType menu_type, Gtk.MenuItem menu_item);
	public abstract void remove_menu_item (MenuType menu_type, Gtk.MenuItem menu_item);
}
