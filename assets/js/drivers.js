/* Driver option handling definitions. */

export function handle_intel()
{
	$("#s_driver_open").attr("disabled", false);
	$("#s_driver_proprietary").attr("disabled", true);
	$("#s_driver_open").prop("checked", true);
	$("#drivers-toggle").addClass("disabled");
}

export function handle_amd()
{
	$("#s_driver_open").attr("disabled", false);
	$("#s_driver_proprietary").attr("disabled", false);

	if (!($("#s_driver_open").is(":checked") || $("#s_driver_proprietary").is(":checked")))
		$("#s_driver_open").prop("checked", true);

	$("#drivers-toggle").removeClass("disabled");
}

export function handle_nvidia()
{
	$("#s_driver_open").attr("disabled", false);
	$("#s_driver_proprietary").attr("disabled", false);

	if (!($("#s_driver_open").is(":checked") || $("#s_driver_proprietary").is(":checked")))
		$("#s_driver_open").prop("checked", true);

	$("#drivers-toggle").removeClass("disabled");
}

export function handle_none_drivers()
{
	$("#s_driver_open").attr("disabled", true);
	$("#s_driver_proprietary").attr("disabled", true);
	$("#s_driver_open").prop("checked", false);
	$("#s_driver_proprietary").prop("checked", false);

	$("#drivers-toggle").addClass("disabled");
}
