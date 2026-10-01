# dmc-error Documentation

New here? The [Quick Start](../README.md#quick-start) catches a Lua error, then raises and catches an error class of its own, in about 10 minutes.

dmc-error is a Solar2D front end for [lua-error](https://github.com/dmccuskey/lua-error): `require 'dmc_corona.dmc_error'` returns lua-error's `Error` class and creates its globals. The API is documented there. dmc-error adds one field, `Error.VERSION`, its own version; `Error.__version` is lua-error's.

## Start

- [Quick Start](../README.md#quick-start): copy the library in, catch an error, raise your own kind of error

## Use

- [lua-error API reference](https://github.com/dmccuskey/lua-error/blob/master/docs/api.md): `try`, `catch`, `finally`, the `Error` class, subclasses, known issues
- [Configuration](#configuration): dmc-error has no settings
- [lua-class](https://github.com/dmccuskey/lua-class): the class model behind `Error` and its subclasses

## Contribute

- [Development](development.md): which files are generated, building, testing
- [Changelog](../CHANGELOG.md)
- [Issues](https://github.com/dmccuskey/dmc-error/issues); bugs in `try`, `catch`, `finally` and `Error` belong to [lua-error](https://github.com/dmccuskey/lua-error/issues)

## Configuration

dmc-error has no settings: `dmc_corona.cfg` needs no `[DMC_ERROR]` section, only the `[DMC_CORONA]` section that tells the loader where the libraries are. See [dmc-corona-boot Configuration](https://github.com/dmccuskey/dmc-corona-boot/blob/master/docs/configuration.md).

## Project Structure

```text
README.md                   landing page and Quick Start
CHANGELOG.md
LICENSE
docs/                       this documentation
dmc_corona/                 what apps copy
├── dmc_error.lua           the library (source)
└── lib/dmc_lua/            lua-error and the other DMC Lua modules (generated copies)
tests/                      unit tests (tests/run_unit.sh)
dmc_corona_boot.lua         loader, from dmc-corona-boot (generated copy)
dmc_corona.cfg              library configuration
Snakefile                   build rules for the generated copies
```
