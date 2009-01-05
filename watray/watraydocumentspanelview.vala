/* watraydocumentspanelview.vala
 * 
 * Coyright (C) 2008 Matias de la Puente
 */
using Gtk;

public class Watray.DocumentsPanelView : Gtk.VBox
{
	private HBox _tab_label;
	private Label _tab_text = new Label (null);
	private Label _tab_mark = new Label (null);
	
	public HBox tab_label
	{
		get { return _tab_label; }
	}
	
	public string tab_text
	{
		set { _tab_text.label = value; }
		get { return _tab_text.label; }
	}
	
	public bool tab_mark
	{
		set { _tab_mark.label = (value ? "*" : ""); }
		get { return _tab_mark.label == "*"; }
	}
	
	public signal void save_action ();
 	public signal void save_as_action ();
	public signal void print_action ();
	public signal void close_action ();
	public signal void copy_action ();
	public signal void cut_action ();
	public signal void paste_action ();
	public signal void undo_action ();
	public signal void redo_action ();
	
	public DocumentsPanelView ()
	{
		var close_button = new Button ();
		close_button.relief = ReliefStyle.NONE;
		close_button.focus_on_click = false;
		var style = new RcStyle ();
		style.xthickness = style.ythickness = 0;
		close_button.modify_style (style);
		close_button.add (new Image.from_stock (Gtk.STOCK_CLOSE, IconSize.MENU));
		close_button.clicked += () => { this.close_action (); };
		
		_tab_label = new HBox (false, 5);
		_tab_label.pack_start (_tab_mark, false, false, 0);
		_tab_label.pack_start (_tab_text, false, false, 0);
		_tab_label.pack_start (close_button, false, false, 0);
		_tab_label.show_all ();
	}
}
