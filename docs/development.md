# Development

How dmc-error is put together.

## Where the Code Lives

Only `dmc_corona/dmc_error.lua` and `tests/` are written in this repository. `dmc_error.lua` loads the DMC boot loader and returns lua-error's `Error` class from `lib.dmc_lua.lua_error`, with `VERSION` set on it. It is the shared class, not a copy: a copy would break `isa()` for the errors other DMC modules raise with `lib.dmc_lua.lua_error`. Everything else is a generated copy; fix it in its own repository, then rebuild:

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

The unit tests check the wrapper and that lua-error's fixes come through it; lua-error's full specs are in its `spec/`. They run under plain Lua 5.1 with dkjson, with stand-ins for the Solar2D globals the boot loader uses. From the repository's root folder:

```sh
tests/run_unit.sh
```

The [Quick Start](../README.md#quick-start) is the check that the package loads in Solar2D.

## Known Issues

The bugs in `try`, `catch`, `finally` and `Error` are listed in lua-error's [Known Issues](https://github.com/dmccuskey/lua-error/blob/master/docs/api.md#known-issues). `dmc_error.lua` itself has none known.
