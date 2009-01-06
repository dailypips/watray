/* simpleplugin.vala
 *
 * Coyright (C) 2008 Matias de la Puente
 */
using Watray;
using Gtk;

public class Simple.Plugin : GLib.Object, IPlugin
{
	private DocumentManager _document_manager;
	private ImageMenuItem _new_item;
	private ImageMenuItem _open_item;
	
	public IProjectsPanel projects_panel { construct set; get; }
	public IDocumentsPanel documents_panel { construct set; get; }
	public IMainWindow main_window { construct set; get; }
	
	construct
	{
		_document_manager = new DocumentManager (documents_panel);
		_new_item = new ImageMenuItem.with_label (_("Text file"));
		_new_item.image = new Image.from_stock (STOCK_FILE, IconSize.MENU);
		main_window.add_menu_item (MenuType.NEW, _new_item);
		_open_item = new ImageMenuItem.with_label (_("Text file"));
		_open_item.image = new Image.from_stock (STOCK_FILE, IconSize.MENU);
		_open_item.activate += () => { _document_manager.open (); _main_window.remove_menu_item (MenuType.NEW, _new_item); };
		main_window.add_menu_item (MenuType.OPEN, _open_item);
	}
}

[ModuleInit]
public GLib.Type register_watray_plugin ()
{
	return typeof (Simple.Plugin);
}

