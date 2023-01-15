/* Populate options from JSON. */
$(document).ready(function()
{
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
