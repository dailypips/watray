/* simpleconfiguredialog.vala
 *
 * Copyright (C) 2009  Matias De la Puente
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

public class Simple.ConfigureDialog : Dialog
{
	private ConfigureManager _configure_manager;
	
	public ConfigureDialog (ConfigureManager configure_manager)
	{
		_configure_manager = configure_manager;
		this.vbox.spacing = 5;
		this.vbox.border_width = 5;
		
		var label = new Label (_("Text font:"));
		var font_button = new FontButton.with_font (_configure_manager.text_font);
		font_button.use_font = true;
		var hbox = new HBox (false, 5);
		hbox.border_width = 5;
		hbox.pack_start (label, false, false, 0);
		hbox.pack_start (font_button, true, true, 0);
		this.vbox.pack_start (hbox, true, true, 0);
		
		font_button.font_set += (font_button) => {
			_configure_manager.text_font = font_button.font_name;
		};
		
		this.add_button (STOCK_CLOSE, ResponseType.CLOSE);
		this.show_all ();
	}
}
