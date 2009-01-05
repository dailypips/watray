/*
 config.vapi: binding for config.h
*/
[CCode (cprefix = "", lower_case_cprefix = "", cheader_filename = "config.h")]
namespace Config
{
	public const string PACKAGE;
	public const string VERSION;
	public const string PACKAGE_NAME;
	public const string PACKAGE_VERSION;
	public const string PACKAGE_STRING;
	public const string PACKAGE_DATADIR;
	public const string PACKAGE_LIBDIR;
	public const string LIB_DIR;
	public const string GETTEXT_PACKAGE;
}
