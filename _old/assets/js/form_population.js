/* Form option population definitions. */

/* Populate forms with options. */
export function populate_forms()
{
	populate_locality();
	populate_rice();
	populate_packs();
}

/* Populate locality options. */
function populate_locality()
{
	_populate_locality_presets("/assets/json/presets_locality.json", "#preset_locality");
	_populate_locality("/assets/json/timezones.json", "#s_timezone");
	_populate_locality("/assets/json/locales.json", "#s_locale");
}

/* Populate rice options. */
function populate_rice()
{
	_populate_rice("/assets/json/wmdes.json", "#s_wmde");
	_populate_rice("/assets/json/greeters.json", "#s_greeter");
	_populate_rice("/assets/json/compositors.json", "#s_compositor");
	_populate_rice("/assets/json/app_launchers.json", "#s_app_launcher");
	_populate_rice("/assets/json/status_bars.json", "#s_status_bar");
	_populate_rice("/assets/json/terminals.json", "#s_terminal");
	_populate_rice("/assets/json/editors.json", "#s_editor");
	_populate_rice("/assets/json/lockscreens.json", "#s_lockscreen");
	_populate_rice("/assets/json/wallpapers.json", "#s_wallpaper");
	_populate_rice("/assets/json/browsers.json", "#s_browser");
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

/* Helper functions for populate_locality. */
function _populate_locality(jsonPath, target)
{
	$.getJSON(jsonPath, function(data)
	{
		$.each(data, function(i, item)
		{
			$(target).append($("<option></option>").val(item).html(item));
		});
	});
}
function _populate_locality_presets(jsonPath, target)
{
	$.getJSON(jsonPath, function(data)
	{
		$.each(data, function(i, item)
		{
			$(target).append($("<option></option>").val(item.name).html(item.name));
		});
	});
}

/* Helper function for populate_rice. */
function _populate_rice(jsonPath, target)
{
	$.getJSON(jsonPath, function(data)
	{
		$.each(data, function(i, item)
		{
			$(target).append($("<option></option>").val(item.package).html(item.name));
		});
	});
}
