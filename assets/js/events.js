/* Event listener definitions. */

import { val_num } from "./validation.js";
import { populate_forms } from "./form_population.js";
import { config_import_open, config_import_close, config_import } from "./config_import.js";
import
{
	preset_locality,
	preset_partition_toggle_recommended,
	preset_partition_toggle_custom,
	preset_partition_toggle_home
}
from "./form_presetting.js";
import { recommend_disk } from "./recommendations.js";
import { handle_intel, handle_amd, handle_nvidia, handle_none_drivers } from "./drivers.js";
import { help, help_close } from "./help.js";
import { handle_none, cook } from "./rice.js";

/* Start all listeners. */
export function start_listeners()
{
	document_ready();
	import_config();
	input_validation();
	locality_presetting();
	partition_presetting();
	display_driver_toggling();
	help_menu();
	rice();
}

/* Upon document ready, populate forms. */
function document_ready()
{
	$(document).ready(function(){ populate_forms(); });
}

/* Import saved configuration from text. */
function import_config()
{
	$("#import-config").click(function(){ config_import_open() });
	$("#import-menu-bar-close").click(function(){ config_import_close() });
	$("#import-button").click(function() { config_import() });
}

/* Validate inputs. */
function input_validation()
{
	$(".validate_numerical").keypress(function(e) { return val_num(e.key) });
}

/* Handle locality presetting. */
function locality_presetting()
{
	$.ajax(
	{
		url: "/assets/json/presets_locality.json",
		dataType: "json",
		async: true,
		success: function(d)
		{
			$("#preset_locality").change(function() { preset_locality(this, d); });
		}
	});
}

/* Handle partition size presetting. */
function partition_presetting()
{
	$("#preset_partitions_recommended").click(function() { preset_partition_toggle_recommended(); });
	$("#preset_partitions_custom").click(function() { preset_partition_toggle_custom(); });
	$("#home_remainder").click(function() { preset_partition_toggle_home(this); });
	$("#preset_disk_size").on("input", function(){ recommend_disk($(this).val()); });
}

/* Handle driver type option based on display selection. */
function display_driver_toggling()
{
	$("#s_display_intel").click(function() { handle_intel(); });
	$("#s_display_amd").click(function() { handle_amd() });
	$("#s_display_nvidia").click(function() { handle_nvidia(); });
	$("#s_display_none").click(function() { handle_none(); });
}

/* Handle help menu. */
function help_menu()
{
	$(".help").click(function(e) { help(this, e); });
	$("#help-menu-bar-close").click(function() { help_close(); });
}

/* Handle None rice configs. */
function rice()
{
	$("#s_wmde").change(function() { handle_none(this, "#wmde-toggle", "#s_wmde_config", "#s_wmde_config_script"); });
	$("#s_greeter").change(function() { handle_none(this, "#greeter-toggle", "#s_greeter_config", "#s_greeter_config_script"); });
	$("#s_compositor").change(function() { handle_none(this, "#compositor-toggle", "#s_compositor_config", "#s_compositor_config_script"); });
	$("#s_app_launcher").change(function() { handle_none(this, "#app_launcher-toggle", "#s_app_launcher_config", "#s_app_launcher_config_script"); });
	$("#s_status_bar").change(function() { handle_none(this, "#status_bar-toggle", "#s_status_bar_config", "#s_status_bar_config_script"); });
	$("#s_terminal").change(function() { handle_none(this, "#terminal-toggle", "#s_terminal_config", "#s_terminal_config_script"); });
	$("#s_editor").change(function() { handle_none(this, "#editor-toggle", "#s_editor_config", "#s_editor_config_script"); });
	$("#s_lockscreen").change(function() { handle_none(this, "#lockscreen-toggle", "#s_lockscreen_config", "#s_lockscreen_config_script"); });
	$("#s_wallpaper").change(function() { handle_none(this, "#wallpaper-toggle", "#s_wallpaper_config", "#s_wallpaper_config_script"); });
	$("#s_browser").change(function() { handle_none(this, "#browser-toggle", "#s_browser_config", "#s_browser_config_script"); });
	$("#submit-button").click(function() { cook() });
}
