# Development

How dmc-error is put together.

## Where the Code Lives

Only `dmc_corona/dmc_error.lua` is written in this repository. It loads the DMC boot loader and returns lua-error's `Error` class from `lib.dmc_lua.lua_error`. Everything else is a generated copy; fix it in its own repository, then rebuild:

| file | owner |
|---|---|
| `dmc_corona/lib/dmc_lua/lua_error.lua`, and every other file in `dmc_corona/lib/dmc_lua/` | [DMC-Lua-Library](https://github.com/dmccuskey/DMC-Lua-Library), which copies them from the `lua-*` repositories ([lua-error](https://github.com/dmccuskey/lua-error), [lua-class](https://github.com/dmccuskey/lua-class), ...) |
| `dmc_corona_boot.lua` | [dmc-corona-boot](https://github.com/dmccuskey/dmc-corona-boot) |

## Building

The copies are made by Snakemake from sibling checkouts of the repositories above (`../DMC-Lua-Library`, `../dmc-corona-boot`, `../DMC-Corona-Library` for the shared rules). From this repository's root folder:

```sh
snakemake --cores 1 build_all
```

The build copies all of DMC-Lua-Library, not only lua-error and lua-class.

## Testing

dmc-error has no tests of its own; lua-error's are in its `spec/`. The [Quick Start](../README.md#quick-start) is the check that the package loads in Solar2D.

## Known Issues

The bugs in `try`, `catch`, `finally` and `Error` are listed in lua-error's [Known Issues](https://github.com/dmccuskey/lua-error/blob/master/docs/api.md#known-issues). In `dmc_error.lua` itself:

- It sets the global `_extend` (its copy of `Utils.extend()` declares the inner function without `local`).
- Its version (`0.1.0`) isn't available to code; `Error.__version` is lua-error's.
