/* watraydocumentview.vala
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

public class Watray.DocumentView : Gtk.VBox
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
	
	public DocumentView ()
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
