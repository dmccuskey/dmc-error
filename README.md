# dmc-error

`try`, `catch` and `finally` for Solar2D (formerly Corona SDK), and error classes you can raise and recognize.

dmc-error is [lua-error](https://github.com/dmccuskey/lua-error) packaged like the other DMC Solar2D libraries. It puts a structure around Lua's `error()` and `pcall()`, modeled on Python's `try` / `except` / `finally`, and adds an `Error` class to raise instead of a string, so a handler can tell its own errors from everyone else's:

```lua
local Error = require 'dmc_corona.dmc_error'

try{
	function()
		loadLevel( 3 )
	end,

	catch{
		function( err )
			print( 'could not load the level:', err )
		end
	}
}
```

## Features

- `try{}`, `catch{}` and `finally{}`: three global functions that read like the statements in other languages
- The error, a string or an object, is passed to the `catch` function
- An `Error` base class with a message, a prefix and the traceback from where it was created
- Subclass `Error` for your own kinds of error, and tell them apart with `isa()`
- The same module the other DMC libraries use for their errors (dmc-websockets, dmc-wamp, dmc-autostore)
- `finally` runs in every case; a `try` without a `catch` passes the error on
- Pure Lua, no plugins needed; MIT licensed

## Quick Start

The following code will get you up and running in about 10 minutes in the Solar2D Simulator on macOS or Windows. It catches a Lua error, then raises and catches an error class of its own.

Prerequisites: the [Solar2D](https://solar2d.com/) Simulator and a copy of this repository (`git clone https://github.com/dmccuskey/dmc-error.git`, or download the ZIP from GitHub).

### 1. Copy the Library into Your Project

Copy these from this repository into the root of your project folder:

```text
dmc_corona_boot.lua     loader for the DMC libraries
dmc_corona.cfg          configuration
dmc_corona/             dmc-error and the modules it needs
```

**Going further:** keep the libraries in a subfolder, or combine several DMC libraries ([dmc-corona-boot Configuration](https://github.com/dmccuskey/dmc-corona-boot/blob/master/docs/configuration.md)).

### 2. Catch an Error

Create `main.lua` in the project folder:

```lua
local Error = require 'dmc_corona.dmc_error'

try{
	function()
		local player = nil
		print( player.name )  -- a mistake: raises an error
	end,

	catch{
		function( err )
			print( 'caught:', err )
		end
	},

	finally{
		function()
			print( 'finally: runs either way' )
		end
	}
}

print( 'still running' )
```

Open the project in the Simulator. The screen stays black; the console shows:

```text
caught:	/path/to/project/main.lua:6: attempt to index local 'player' (a nil value)
finally: runs either way
still running
```

If the console shows `module 'dmc_corona.dmc_error' not found` instead, `dmc_corona/` is missing from the root of the project folder.

Requiring dmc-error creates the global functions `try`, `catch` and `finally`. `try` runs the first function; when it raises an error, the `catch` function gets the error, and the app goes on instead of stopping with a runtime error.

**Going further:** what `try()` returns, and which parts can be left out ([try, catch, finally](https://github.com/dmccuskey/lua-error/blob/master/docs/api.md#try-catch-finally)).

### 3. Raise Your Own Kind of Error

Add this to the end of `main.lua`:

```lua
local Class = require 'lua_class'

local NetworkError = Class.newClass( Error, { name="Network Error" } )

local function loadScores( url )
	error( NetworkError( 'no connection to ' .. url ) )
end

try{
	function()
		loadScores( 'https://scores.example.com/top10' )
	end,

	catch{
		function( err )
			if type( err )=='table' and err:isa( NetworkError ) then
				print( 'caught:', err.NAME, '/', err.message )
			else
				error( err )  -- not ours: raise it again
			end
		end
	}
}
```

The Simulator restarts the app when the file is saved, and the console now also shows:

```text
caught:	Network Error	/	no connection to https://scores.example.com/top10
```

`NetworkError` is a subclass of `Error`; calling it creates an error object, and `error()` raises it. The `catch` checks the kind of error with `isa()` and raises anything else again. Check `type( err )=='table'` first: Lua's own errors are strings, which have no `isa()`.

`lua_class` is the class module the `Error` class is built on, [lua-class](https://github.com/dmccuskey/lua-class); it is in `dmc_corona/lib/dmc_lua/`. Require it by that name, `'lua_class'`, as dmc-error does: under a second name, such as `'dmc_corona.lib.dmc_lua.lua_class'`, Lua loads a second copy.

**Going further:** the error object's fields, prefixes and default messages ([The Error Class](https://github.com/dmccuskey/lua-error/blob/master/docs/api.md#the-error-class)). An `Error` object nobody catches leaves no message in the console: see [Known Issues](https://github.com/dmccuskey/lua-error/blob/master/docs/api.md#known-issues).

To update, copy `dmc_corona_boot.lua` and `dmc_corona/` again from the newer version. Keep your own `dmc_corona.cfg` if you have changed it.

## Documentation

- [lua-error API reference](https://github.com/dmccuskey/lua-error/blob/master/docs/api.md): `try`, `catch`, `finally`, the `Error` class, subclasses, known issues
- [Configuration](docs/README.md#configuration): dmc-error has no settings of its own
- [Changelog](CHANGELOG.md)

Everything else is listed on the [documentation home](docs/README.md).

## License

dmc-error is released under the [MIT License](LICENSE).
