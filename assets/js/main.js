/* From: /assets/json/presets_locality.json */
var presetsLocality = {};

/* Populate options from JSON. */
$(document).ready(function()
{
	/* Populate locality presets. */
	$.getJSON("/assets/json/presets_locality.json", function(data)
	{
		presetsLocality = data;
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
});

/* Handle locality presetting. */
$("#preset_locality").change(function()
{
	if ($(this).val() != "Custom")
	{
		var preset = presetsLocality.filter(obj => { return obj.name == $(this).val() })[0];
		$("#s_timezone").val(preset.timezone).change();
		$("#s_locale").val(preset.locale).change();
		$("#s_timezone").attr("disabled", true);
		$("#s_locale").attr("disabled", true);
	}
	else
	{
		$("#s_timezone").attr("disabled", false);
		$("#s_locale").attr("disabled", false);
	}
});
