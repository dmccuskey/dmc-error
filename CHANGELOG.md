# Changelog

## 0.2.0 (2026-10-01)

### Changed

- The module is now lua-error 0.4.1's, from DMC-Lua-Library's `lib.dmc_lua.lua_error` (it was 0.3.0). From lua-error 0.4.0:
  - `finally` runs in every case: on success without a `catch`, and when the `catch` raises an error.
  - A `try` without a `catch` raises the error again instead of swallowing it.
  - `try` returns all the values of the function, or of the `catch`.
  - An `Error` object's `traceback` starts where the error was created.
  - The rest are in lua-error's [Known Issues](https://github.com/dmccuskey/lua-error/blob/master/docs/api.md#known-issues).
- Rebuilt with dmc-corona-boot 1.6.0 and the current DMC-Lua-Library.

### Added

- `Error.VERSION`, dmc-error's version, set on lua-error's shared `Error` class (`Error.__version` is lua-error's).
- Unit tests: `tests/run_unit.sh`, plain Lua 5.1.

### Removed

- The copy of `Utils.extend()`, which set the global `_extend`; the module uses DMC-Lua-Library's `lua_utils`.

## 0.1.0

- First release: lua-error packaged for Solar2D.
