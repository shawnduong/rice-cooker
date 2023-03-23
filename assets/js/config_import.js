/* Config import definitions. */

/* Handle what happens when clicking "Import Saved Configuration". */
export function config_import()
{
	$("#import-menu").fadeIn("slow");
	$("#overlay").fadeIn("hidden");
	$("#import-menu").removeClass("hidden");
	$("#overlay").removeClass("hidden");
}

/* Handle what happens when clicking the X on the import menu. */
export function config_import_close()
{
	$("#import-menu").fadeOut("slow", function() { $("#import-menu").addClass("hidden") });
	$("#overlay").fadeOut("slow", function() { $("#overlay").addClass("hidden") });
}
