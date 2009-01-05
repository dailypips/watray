/* watrayprojectspanelitem.vala
 * 
 * Coyright (C) 2008 Matias de la Puente
 */

public class Watray.ProjectsPanelItem: GLib.Object
{
	private List<ProjectsPanelItem> childs = new List<ProjectsPanelItem> ();

	public ProjectsPanelItem parent { construct; get; }
	public string text { set; get; }
	public string icon { set; get; }
	public string data { set; get; }
	
	public ProjectsPanelItem (ProjectsPanelItem parent)
	{
		this.parent = parent;
	}
	
	public void add (ProjectsPanelItem item)
	{
		this.childs.append (item);
	}
	
	public void remove (ProjectsPanelItem item)
	{
		this.childs.remove (item);
	}
	
	public void clear ()
	{
		this.childs = new List<ProjectsPanelItem> ();
	}
	
	public List<weak ProjectsPanelItem> get_childs ()
	{
		return this.childs.copy ();
	}
}
