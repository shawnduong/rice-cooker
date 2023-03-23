/* Config import definitions. */

import { preset_partition_toggle_custom } from "./form_presetting.js";

/* Handle what happens when clicking "Import Saved Configuration". */
export function config_import_open()
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

/* Handle what happens when clicking "Import!" */
export function config_import()
{
	config_import_close();

	let lines = $("#import-recipe").val().split("\n");

	$.each(lines, function()
	{
		let tokens = this.split("=");
		let item = tokens[0];
		let value = tokens[1];
		let values = null;

		/* These are always set to predefined values when importing. */
		$("#preset_locality").val("Custom").change();
		$("#preset_partitions_custom").prop("checked", true);
		$("#preset_partitions_custom").trigger("click");

		switch (item)
		{
			case "USERNAME":
				$("#s_username").val(value.slice(1,-1));
				break;
			case "HOSTNAME":
				$("#s_hostname").val(value.slice(1,-1));
				break;
			case "HOME_STYLE":
				switch (value.slice(1,-1))
				{
					case "full":
						$("#s_home_style_full").prop("checked", true);
						break;
					case "minimal":
						$("#s_home_style_minimal").prop("checked", true);
						break;
					case "none":
						$("#s_home_style_none").prop("checked", true);
						break;
				}
				break;
			case "TIMEZONE":
				$("#s_timezone").val(value.slice(1,-1)).change();
				break;
			case "LOCALE":
				$("#s_locale").val(value.slice(1,-1)).change();
				break;
			case "ENCRYPT":
				if (value == "true")  $("#s_encrypt_noclick").prop("checked", true);
				break;
			case "SIZE_BOOT":
				$("#s_size_boot").val(value.slice(1,-1)).change();
				break;
			case "SIZE_SWAP":
				$("#s_size_swap").val(value.slice(1,-1)).change();
				break;
			case "SIZE_ROOT":
				$("#s_size_root").val(value.slice(1,-1)).change();
				break;
			case "SIZE_HOME_REMAINDER":
				$("#home_remainder").prop("checked", true);
				break;
			case "SIZE_HOME":
				$("#s_size_home").val(value.slice(1,-1)).change();
				break;
			case "DISPLAY":
				switch (value.slice(1,-1))
				{
					case "intel":
						$("#s_display_intel").prop("checked", true);
						$("#s_display_intel").trigger("click");
						break;
					case "amd":
						$("#s_display_amd").prop("checked", true);
						$("#s_display_amd").trigger("click");
						break;
					case "nvidia":
						$("#s_display_nvidia").prop("checked", true);
						$("#s_display_nvidia").trigger("click");
						break;
					case "none":
						$("#s_display_none").prop("checked", true);
						$("#s_display_none").trigger("click");
						break;
				}
				break;
			case "DRIVER":
				switch (value.slice(1,-1))
				{
					case "open":
						$("#s_driver_open").prop("checked", true);
						break;
					case "proprietary":
						$("#s_driver_proprietary").prop("checked", true);
						break;
				}
				break;
			case "WIFI":
				values = value.slice(1,-1).split(" ");
				$.each(values, function() { $("#s_wifi_"+this.slice(1,-1)).prop("checked", true); });
				break;
			case "WMDE":
				$("#s_wmde").val(value.slice(1,-1));
				$("#s_wmde").trigger("change");
				break;
			case "WMDE_CONFIG_SCRIPT":
				if (value == "true")  $("#s_wmde_config_script").prop("checked", true);
				break;
			case "WMDE_CONFIG":
				$("#s_wmde_config").val(value.slice(1,-1));
				break;
			case "GREETER":
				if (value == '""') value = "none";
				else               value = value.slice(1,-1);
				$("#s_greeter").val(value);
				$("#s_greeter").trigger("change");
				break;
			case "GREETER_CONFIG_SCRIPT":
				if (value == "true")  $("#s_greeter_config_script").prop("checked", true);
				break;
			case "GREETER_CONFIG":
				$("#s_greeter_config").val(value.slice(1,-1));
				break;
			case "COMPOSITOR":
				$("#s_compositor").val(value.slice(1,-1));
				$("#s_compositor").trigger("change");
				break;
			case "COMPOSITOR_CONFIG_SCRIPT":
				if (value == "true")  $("#s_compositor_config_script").prop("checked", true);
				break;
			case "COMPOSITOR_CONFIG":
				$("#s_compositor_config").val(value.slice(1,-1));
				break;
			case "APP_LAUNCHER":
				$("#s_app_launcher").val(value.slice(1,-1));
				$("#s_app_launcher").trigger("change");
				break;
			case "APP_LAUNCHER_CONFIG_SCRIPT":
				if (value == "true")  $("#s_app_launcher_config_script").prop("checked", true);
				break;
			case "APP_LAUNCHER_CONFIG":
				$("#s_app_launcher_config").val(value.slice(1,-1));
				break;
			case "STATUS_BAR":
				$("#s_status_bar").val(value.slice(1,-1));
				$("#s_status_bar").trigger("change");
				break;
			case "STATUS_BAR_CONFIG_SCRIPT":
				if (value == "true")  $("#s_status_bar_config_script").prop("checked", true);
				break;
			case "STATUS_BAR_CONFIG":
				$("#s_status_bar_config").val(value.slice(1,-1));
				break;
			case "TERMINAL":
				$("#s_terminal").val(value.slice(1,-1));
				$("#s_terminal").trigger("change");
				break;
			case "TERMINAL_CONFIG_SCRIPT":
				if (value == "true")  $("#s_terminal_config_script").prop("checked", true);
				break;
			case "TERMINAL_CONFIG":
				$("#s_terminal_config").val(value.slice(1,-1));
				break;
			case "EDITOR":
				$("#s_editor").val(value.slice(1,-1));
				$("#s_editor").trigger("change");
				break;
			case "EDITOR_CONFIG_SCRIPT":
				if (value == "true")  $("#s_editor_config_script").prop("checked", true);
				break;
			case "EDITOR_CONFIG":
				$("#s_editor_config").val(value.slice(1,-1));
				break;
			case "LOCKSCREEN":
				$("#s_lockscreen").val(value.slice(1,-1));
				$("#s_lockscreen").trigger("change");
				break;
			case "LOCKSCREEN_CONFIG_SCRIPT":
				if (value == "true")  $("#s_lockscreen_config_script").prop("checked", true);
				break;
			case "LOCKSCREEN_CONFIG":
				$("#s_lockscreen_config").val(value.slice(1,-1));
				break;
			case "WALLPAPER":
				$("#s_wallpaper").val(value.slice(1,-1));
				$("#s_wallpaper").trigger("change");
				break;
			case "WALLPAPER_CONFIG_SCRIPT":
				if (value == "true")  $("#s_wallpaper_config_script").prop("checked", true);
				break;
			case "WALLPAPER_CONFIG":
				$("#s_wallpaper_config").val(value.slice(1,-1));
				break;
			case "BROWSER":
				$("#s_browser").val(value.slice(1,-1));
				$("#s_browser").trigger("change");
				break;
			case "BROWSER_CONFIG_SCRIPT":
				if (value == "true")  $("#s_browser_config_script").prop("checked", true);
				break;
			case "BROWSER_CONFIG":
				$("#s_browser_config").val(value.slice(1,-1));
				break;
			case "ADDITIONAL_PACKS":
				values = value.slice(1,-1).split(" ");
				$.each(values, function() { $("#s_additional_pack_"+this.slice(1,-1)).prop("checked", true); });
				break;
			case "INSTALL_OMURICE":
				if (value == "true")  $("#s_omurice").prop("checked", true);
				break;
		}
	});
}
