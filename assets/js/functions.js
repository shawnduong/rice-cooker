/* Validate numerical input. */
function val_num(e)
{
	if (e.key >= "0" && e.key <= "9")
		return true;
	return true; 
}

/* Populate locality options. */
function populate_locality()
{
	/* Populate locality presets. */
	$.getJSON("/assets/json/presets_locality.json", function(data)
	{
		$.each(data, function(i, item)
		{
			$("#preset_locality").append($("<option></option>").val(item.name).html(item.name));
		});
	});

	/* Populate timezone options. */
	$.getJSON("/assets/json/timezones.json", function(data)
	{
		$.each(data, function(i, item)
		{
			$("#s_timezone").append($("<option></option>").val(item).html(item));
		});
	});

	/* Populate locale options. */
	$.getJSON("/assets/json/locales.json", function(data)
	{
		$.each(data, function(i, item)
		{
			$("#s_locale").append($("<option></option>").val(item).html(item));
		});
	});
}

/* Populate rice options. */
function populate_rice()
{
	_populate_rice_helper("/assets/json/wmdes.json", "#s_wmde");
	_populate_rice_helper("/assets/json/greeters.json", "#s_greeter");
	_populate_rice_helper("/assets/json/compositors.json", "#s_compositor");
	_populate_rice_helper("/assets/json/app_launchers.json", "#s_app_launcher");
	_populate_rice_helper("/assets/json/status_bars.json", "#s_status_bar");
	_populate_rice_helper("/assets/json/terminals.json", "#s_terminal");
	_populate_rice_helper("/assets/json/editors.json", "#s_editor");
	_populate_rice_helper("/assets/json/lockscreens.json", "#s_lockscreen");
	_populate_rice_helper("/assets/json/wallpapers.json", "#s_wallpaper");
	_populate_rice_helper("/assets/json/browsers.json", "#s_browser");
}

/* Helper function for populate_rice. */
function _populate_rice_helper(jsonPath, target)
{
	$.getJSON(jsonPath, function(data)
	{
		$.each(data, function(i, item)
		{
			$(target).append($("<option></option>").val(item.package).html(item.name));
		});
	});
}

/* Populate additional packs options. */
function populate_packs()
{
	$.getJSON("/assets/json/packs.json", function(data)
	{
		$.each(data, function(i, item)
		{
			$("#additional-packs-options").append(
				$("<input name='s_additional_packs' type='checkbox' id='s_additional_pack_"+item.name+"' value='"+item.name+"'>")
			);
			$("#additional-packs-options").append(
				$("<label for='s_additional_pack_"+item.name+"'></label><br>")
				.val(item.displayName).html(" "+item.displayName)
			);
		});
	});
}

/* Handle a rice "none" config. Give it the toggle ID, config ID, and script ID. */
function handle_none(object, toggle, config, script)
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
function cook()
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
		"WMDE_CONFIG_SCRIPT": $("input[id='s_wmde_config_script']:checked").val(),
		"WMDE_CONFIG": $("#s_wmde_config").val(),
		"GREETER": $("#s_greeter").val(),
		"GREETER_CONFIG_SCRIPT": $("input[id='s_greeter_config_script']:checked").val(),
		"GREETER_CONFIG": $("#s_greeter_config").val(),
		"COMPOSITOR": $("#s_compositor").val(),
		"COMPOSITOR_CONFIG_SCRIPT": $("input[id='s_compositor_config_script']:checked").val(),
		"COMPOSITOR_CONFIG": $("#s_compositor_config").val(),
		"APP_LAUNCHER": $("#s_app_launcher").val(),
		"APP_LAUNCHER_CONFIG_SCRIPT": $("input[id='s_app_launcher_config_script']:checked").val(),
		"APP_LAUNCHER_CONFIG": $("#s_app_launcher_config").val(),
		"STATUS_BAR": $("#s_status_bar").val(),
		"STATUS_BAR_CONFIG_SCRIPT": $("input[id='s_status_bar_config_script']:checked").val(),
		"STATUS_BAR_CONFIG": $("#s_status_bar_config").val(),
		"TERMINAL": $("#s_terminal").val(),
		"TERMINAL_CONFIG_SCRIPT": $("input[id='s_terminal_config_script']:checked").val(),
		"TERMINAL_CONFIG": $("#s_terminal_config").val(),
		"EDITOR": $("#s_editor").val(),
		"EDITOR_CONFIG_SCRIPT": $("input[id='s_editor_config_script']:checked").val(),
		"EDITOR_CONFIG": $("#s_editor_config").val(),
		"LOCKSCREEN": $("#s_lockscreen").val(),
		"LOCKSCREEN_CONFIG_SCRIPT": $("input[id='s_lockscreen_config_script']:checked").val(),
		"LOCKSCREEN_CONFIG": $("#s_lockscreen_config").val(),
		"WALLPAPER": $("#s_wallpaper").val(),
		"WALLPAPER_CONFIG_SCRIPT": $("input[id='s_wallpaper_config_script']:checked").val(),
		"WALLPAPER_CONFIG": $("#s_wallpaper_config").val(),
		"BROWSER": $("#s_browser").val(),
		"BROWSER_CONFIG_SCRIPT": $("input[id='s_browser_config_script']:checked").val(),
		"BROWSER_CONFIG": $("#s_browser_config").val(),
		"ADDITIONAL_PACKS": $("input[name='s_additional_packs']:checked").map(function(_, e) { return $(e).val(); }).get(),
		"INSTALL_OMURICE": $("input[id='s_omurice']:checked").val()
	}

	console.log(config);

	/* Fade in the recipe menu and scroll in. */
	$("#recipe").fadeIn("slow");
	$("#recipe").removeClass("hidden");
	$("#cook-scrollto")[0].scrollIntoView({ behavior: "smooth" });
}
