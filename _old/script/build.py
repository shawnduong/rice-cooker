#!/usr/bin/env python3

MODULE_ROOT="./modules/"

def main():

	print("Building rice-cooker.sh...", end="")

	output = ""

	for line in open("template.sh", "r").readlines():
		if line.lstrip().startswith("{{ include"):
			module = line.split()[-2]
			output += open(MODULE_ROOT + module).read()
		else:
			output += line

	open("rice-cooker.sh", "w").write(output)

	print(" done.")

if __name__ == "__main__":
	main()
