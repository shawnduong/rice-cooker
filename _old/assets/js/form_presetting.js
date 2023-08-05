/* Form presetting definitions. */

/* State variables. */
var homePartitionSizeBuffer = "";

/* Handle locality presetting upon #preset_locality change. */
export function preset_locality(obj, presets)
{
	if ($(obj).val() != "Custom")
	{
		let preset = presets.filter(o => { return o.name == $(obj).val() })[0];
		$("#s_timezone").val(preset.timezone).change();
		$("#s_locale").val(preset.locale).change();
		$("#s_timezone").attr("disabled", true);
		$("#s_locale").attr("disabled", true);
		$("#locality-toggle").addClass("disabled");
	}
	else
	{
		$("#s_timezone").attr("disabled", false);
		$("#s_locale").attr("disabled", false);
		$("#locality-toggle").removeClass("disabled");
	}
}

/* Toggle what form items are disabled when selecting #preset_partitions_recommended. */
export function preset_partition_toggle_recommended()
{
	$("#preset_disk_size").attr("disabled", false);
	$("#s_size_boot").attr("disabled", true);
	$("#s_size_swap").attr("disabled", true);
	$("#s_size_root").attr("disabled", true);
	$("#home_remainder").attr("disabled", true);
	$("#s_size_home").attr("disabled", true);

	$("#home_remainder").prop("checked", true);
	homePartitionSizeBuffer = $("#s_size_home").val();
	$("#s_size_home").val("").change();

	$("#disk-toggle-1").removeClass("disabled");
	$("#disk-toggle-2").addClass("disabled");
}

/* Toggle what form items are disabled when selecting #preset_partitions_custom. */
export function preset_partition_toggle_custom()
{
	$("#preset_disk_size").val("").change();
	$("#preset_disk_size").attr("disabled", true);
	$("#s_size_boot").attr("disabled", false);
	$("#s_size_swap").attr("disabled", false);
	$("#s_size_root").attr("disabled", false);
	$("#home_remainder").attr("disabled", false);

	if ($("#home_remainder").is(":checked"))
		$("#s_size_home").attr("disabled", true);
	else
		$("#s_size_home").attr("disabled", false);

	$("#disk-toggle-1").addClass("disabled");
	$("#disk-toggle-2").removeClass("disabled");
}

/* Toggle whether the home item is enabled or not when selecting #home_remainder. */
export function preset_partition_toggle_home(obj)
{
	if ($(obj).is(":checked"))
	{
		homePartitionSizeBuffer = $("#s_size_home").val();
		$("#s_size_home").val("").change();
		$("#s_size_home").attr("disabled", true);
	}
	else
	{
		$("#s_size_home").val(homePartitionSizeBuffer).change();
		$("#s_size_home").attr("disabled", false);
	}
}
