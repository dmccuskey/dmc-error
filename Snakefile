# dmc-error

try:
	if not gSTARTED: print( gSTARTED )
except:
	MODULE = "dmc-error"
	include: "../DMC-Corona-Library/snakemake/Snakefile"

module_config = {
	"name": "dmc-error",
	"module": {
		"dir": "dmc_corona",
		"files": [
			"dmc_error.lua"
		],
		"requires": [
			"dmc-corona-boot",
			"DMC-Lua-Library"
		]
	},
	"tests": {
		"files": [],
		"requires": []
	}
}

register( "dmc-error", module_config )

