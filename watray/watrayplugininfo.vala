/* watrayplugininfo.vala
 * 
 * Coyright (C) 2008 Matias de la Puente
 */

internal class Watray.PluginInfo : GLib.Object
{
	private const string GROUP_NAME = "Watray Plugin";
	private string _filename;
	
	public string filename
	{
		private set
		{
			this._filename = value;
			this.path = Path.get_dirname (this._filename);
		}
		get { return this._filename; }
	}
	public string path { private set; get; }
	public string name { private set; get; }
	public string module { private set; get; }
	public string description { private set; get; }
	public string authors { private set; get; }
	public string license { private set; get; }
	
	public PluginInfo (string filename)
	{
		this.filename = filename;
	}
	
	public bool load_info ()
	{
		var key_file = new KeyFile ();
		try
		{
			key_file.load_from_file (this.filename, KeyFileFlags.NONE);
			if (!key_file.has_group (GROUP_NAME))
				throw new KeyFileError.GROUP_NOT_FOUND ("Invalid plugin file");
			this.name = key_file.get_string (GROUP_NAME, "Name");
			this.module = key_file.get_string (GROUP_NAME, "Module");
			this.description = key_file.get_string (GROUP_NAME, "Description");
			this.authors = key_file.get_string (GROUP_NAME, "Authors");
			this.license = key_file.get_string (GROUP_NAME, "License");
			return true;
		}
		catch (Error err)
		{
			print (this.filename + ": " + err.message);
			return false;
		}
	}
}
