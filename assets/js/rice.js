/* Rice definitions. */

/* Handle a rice "none" config. Give it the toggle ID, config ID, and script ID. */
export function handle_none(object, toggle, config, script)
{
	if ($(object).val() == "none")
	{
		$(toggle).addClass("disabled");
		$(config).attr("disabled", true);
		$(config).val("").change();
		$(script).attr("disabled", true);
		$(script).prop("checked", false);
	}
	else
	{
		$(toggle).removeClass("disabled");
		$(config).attr("disabled", false);
		$(script).attr("disabled", false);
	}
}

/* Collate all form results. */
export function cook()
{
	let config = {
		"USERNAME": $("#s_username").val(),
		"HOSTNAME": $("#s_hostname").val(),
		"HOME_STYLE": $("input[name='s_home_style']:checked").val(),
		"TIMEZONE": $("#s_timezone").val(),
		"LOCALE": $("#s_locale").val(),
		"ENCRYPT": $("#s_encrypt_noclick").is(":checked"),
		"SIZE_BOOT": $("#s_size_boot").val(),
		"SIZE_SWAP": $("#s_size_swap").val(),
		"SIZE_ROOT": $("#s_size_root").val(),
		"SIZE_HOME_REMAINDER": $("#home_remainder").is(":checked"),
		"SIZE_HOME": $("#s_size_home").val(),
		"DISPLAY": $("input[name='s_display']:checked").val(),
		"DRIVER": $("input[name='s_driver']:checked").val(),
		"WIFI": $("input[name='s_wifi']:checked").map(function(_, e) { return $(e).val(); }).get(),
		"WMDE": $("#s_wmde").val(),
		"WMDE_CONFIG_SCRIPT": $("#s_wmde_config_script").is(":checked"),
		"WMDE_CONFIG": $("#s_wmde_config").val(),
		"GREETER": $("#s_greeter").val(),
		"GREETER_CONFIG_SCRIPT": $("#s_greeter_config_script").is(":checked"),
		"GREETER_CONFIG": $("#s_greeter_config").val(),
		"COMPOSITOR": $("#s_compositor").val(),
		"COMPOSITOR_CONFIG_SCRIPT": $("#s_compositor_config_script").is(":checked"),
		"COMPOSITOR_CONFIG": $("#s_compositor_config").val(),
		"APP_LAUNCHER": $("#s_app_launcher").val(),
		"APP_LAUNCHER_CONFIG_SCRIPT": $("#s_app_launcher_config_script").is(":checked"),
		"APP_LAUNCHER_CONFIG": $("#s_app_launcher_config").val(),
		"STATUS_BAR": $("#s_status_bar").val(),
		"STATUS_BAR_CONFIG_SCRIPT": $("#s_status_bar_config_script").is(":checked"),
		"STATUS_BAR_CONFIG": $("#s_status_bar_config").val(),
		"TERMINAL": $("#s_terminal").val(),
		"TERMINAL_CONFIG_SCRIPT": $("#s_terminal_config_script").is(":checked"),
		"TERMINAL_CONFIG": $("#s_terminal_config").val(),
		"EDITOR": $("#s_editor").val(),
		"EDITOR_CONFIG_SCRIPT": $("#s_editor_config_script").is(":checked"),
		"EDITOR_CONFIG": $("#s_editor_config").val(),
		"LOCKSCREEN": $("#s_lockscreen").val(),
		"LOCKSCREEN_CONFIG_SCRIPT": $("#s_lockscreen_config_script").is(":checked"),
		"LOCKSCREEN_CONFIG": $("#s_lockscreen_config").val(),
		"WALLPAPER": $("#s_wallpaper").val(),
		"WALLPAPER_CONFIG_SCRIPT": $("#s_wallpaper_config_script").is(":checked"),
		"WALLPAPER_CONFIG": $("#s_wallpaper_config").val(),
		"BROWSER": $("#s_browser").val(),
		"BROWSER_CONFIG_SCRIPT": $("#s_browser_config_script").is(":checked"),
		"BROWSER_CONFIG": $("#s_browser_config").val(),
		"ADDITIONAL_PACKS": $("input[name='s_additional_packs']:checked").map(function(_, e) { return $(e).val(); }).get(),
		"INSTALL_OMURICE": $("#s_omurice").is(":checked")
	};

	/* Perform assertions to make sure that the required data is filled out. */
	if (assertions(config) == false)  return;

	/* Change "null" and "none" to "" (Bash null) */
	for (const k in config)
		if (config[k] == null || config[k] == "none")  config[k] = "";

	/* Recipe contents. */
	let recipe = "# Rice Cooker Recipe (rice.shawnd.xyz) <br>";

	/* Create the recipe contents. */
	for (const k in config) { recipe += k+'="'+config[k]+'"<br>'; }

	/* Write the recipe contents. */
	$("#recipe-body").html(recipe);

	/* Fade in the recipe and scroll in. */
	$("#recipe").fadeIn("slow");
	$("#recipe").removeClass("hidden");
	$("#cook-scrollto")[0].scrollIntoView({ behavior: "smooth" });
}

/* Assert that all the required data is filled out. */
function assertions(config)
{
	let required = {
		"USERNAME": $("label[for='s_username']"),
		"HOSTNAME": $("label[for='s_hostname']"),
		"HOME_STYLE": $("label[for='s_home_style']"),
		"TIMEZONE": $("label[for='s_timezone']"),
		"LOCALE": $("label[for='s_locale']"),
		"SIZE_BOOT": $("label[for='s_size_boot']"),
		"SIZE_SWAP": $("label[for='s_size_swap']"),
		"SIZE_ROOT": $("label[for='s_size_root']"),
		"DISPLAY": $("label[for='s_display']"),
		"WMDE": $("label[for='s_wmde']"),
		"GREETER": $("label[for='s_greeter']"),
		"COMPOSITOR": $("label[for='s_compositor']"),
		"APP_LAUNCHER": $("label[for='s_app_launcher']"),
		"STATUS_BAR": $("label[for='s_status_bar']"),
		"TERMINAL": $("label[for='s_terminal']"),
		"EDITOR": $("label[for='s_editor']"),
		"LOCKSCREEN": $("label[for='s_lockscreen']"),
		"WALLPAPER": $("label[for='s_wallpaper']"),
		"BROWSER": $("label[for='s_browser']")
	};

	/* Remove all the existing required text elements. */
	$(".required-notice").remove();

	for (const k in required)
	{
		if (config[k] == null || config[k] == "")
		{
			$('<span class="required-notice">Error: required.</span>').insertAfter(required[k]);
		}
	}

	/* TODO: Special case: home remainder/size. */
}
