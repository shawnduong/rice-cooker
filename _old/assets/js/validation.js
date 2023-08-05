/* Validation definitions. */

/* Return true if n is a numerical. */
export function val_num(n)
{
	if (n >= "0" && n <= "9")
		return true;
	return false;
}
