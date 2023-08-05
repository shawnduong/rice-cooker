/* Recommendation definitions. */

/* Recommend disk sizes. */
export function recommend_disk(value)
{
	if (value < 16)
	{
		$("#s_size_boot").val("").change();
		$("#s_size_swap").val("").change();
		$("#s_size_root").val("").change();
	}
	else if (value < 32)
	{
		$("#s_size_boot").val("512").change();
		$("#s_size_swap").val("1").change();
		$("#s_size_root").val("8").change();
	}
	else if (value < 64)
	{
		$("#s_size_boot").val("512").change();
		$("#s_size_swap").val("1").change();
		$("#s_size_root").val("16").change();
	}
	else if (value < 128)
	{
		$("#s_size_boot").val("512").change();
		$("#s_size_swap").val("1").change();
		$("#s_size_root").val("32").change();
	}
	else
	{
		$("#s_size_boot").val("512").change();
		$("#s_size_swap").val("1").change();
		$("#s_size_root").val("64").change();
	}
}
