/* watrayplugininterface.vala
 *
 * Coyright (C) 2008 Matias de la Puente
 */

public interface Watray.IPlugin : GLib.Object
{
	public abstract IProjectsPanel projects_panel { construct set; get; }
	public abstract IDocumentsPanel documents_panel { construct set; get; }
	public abstract IMainWindow main_window { construct set; get; }
}
