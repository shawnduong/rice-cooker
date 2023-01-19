/* Help menu definitions. */

/* State variables. */
var helpItem = "";

/* Handle what happens when clicking (?). */
export function help(obj, e)
{
	/* If the same (?) is clicked again, close it. */
	if (helpItem == obj.parentElement.htmlFor)
	{
		$("#help-menu").fadeOut("slow", function() { $("#help-menu").addClass("hidden") });
		helpItem = "";
	}
	/* Bring up the new help menu. */
	else
	{
		/* If there is already no help menu, fade it in. Else, slide the old
		   menu to the new position. */
		if ($("#help-menu").hasClass("hidden"))
		{
			$("#help-menu").css("top", e.pageY - 64);
			$("#help-menu").fadeIn("slow");
			$("#help-menu").removeClass("hidden");
		}
		else
		{
			$("#help-menu").animate({top: e.pageY-64});
		}

		/* Fill in the help text. */
		helpItem = obj.parentElement.htmlFor;
		$("#help-menu-bar-title").text("Help: "+obj.parentElement.textContent.slice(0, -4));
		$("#help-menu-body").load("/assets/html/help/"+helpItem+".html");
	}
}

/* Handle what happens when clicking X. */
export function help_close()
{
	$("#help-menu").fadeOut("slow", function() { $("#help-menu").addClass("hidden") });
	helpItem = "";
}
