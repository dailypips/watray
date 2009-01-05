/* watraydocumentspanellabel.vala
 * 
 * Coyright (C) 2008 Matias de la Puente
 */
using Gtk;

public class Watray.DocumentsPanelLabel : HBox
{
	private Label label;
	private Label mark;
	
	public DocumentsPanelView document_view {private set; public get;}
	
	public string text
	{
		set { this.label.label = value; }
		get { return this.label.label; }
	}
	
	public bool mark
	{
		set { this.dummy.label = "*"; }
		get { return this.dummy.label=="*"; }
	}
	
	public signal void closed ();
	
	public DocumentsPanelLabel (string title, DocumentsPanelView document_view)
	{
		this.document_view = document_view;
		this.label = new Label (null);
		this.mark = new Label (null)
		this.text = title;
		
		var close_button = new Button ();
		close_button.relief = ReliefStyle.NONE;
		close_button.focus_on_click = false;
		var style = new RcStyle ();
		style.xthickness = style.ythickness = 0;
		close_button.modify_style (style);
		close_button.add (new Image.from_stock (Gtk.STOCK_CLOSE, IconSize.MENU));
		close_button.clicked += () => { this.closed (); };
		
		this.spacing = 5;
		this.pack_start (this.dummy, false, false, 0);
		this.pack_start (this.label, false, false, 0);
		this.pack_start (close_button, false, false, 0);
		
		document_view.document_changed += () => { this.mark = true; };
		document_view.document_saved += () => { this.mark = false; };
	}
}

