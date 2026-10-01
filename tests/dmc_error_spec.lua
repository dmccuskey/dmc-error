--====================================================================--
-- tests/dmc_error_spec.lua
--
-- Unit tests for dmc-error, using Luna Test.
-- Run with tests/run_unit.sh
--
-- lua-error has the full specs; these check the wrapper, and that
-- lua-error's fixes come through it
--====================================================================--


module(..., package.seeall)



--====================================================================--
--== Setup


local Error, LuaError, Class

function suite_setup()
	Error = require 'dmc_corona.dmc_error'
	LuaError = require 'lib.dmc_lua.lua_error'
	Class = require 'lua_class'
end



--====================================================================--
--== Tests


function test_module()
	assert_equal( 'table', type( Error ) )
	assert_equal( '0.2.0', Error.VERSION )
	assert_equal( '0.4.1', Error.__version )
end

-- the shared class, so errors from other DMC modules are recognized
function test_shared_class()
	assert_equal( LuaError, Error )
	local NetworkError = Class.newClass( LuaError, { name="Network Error" } )
	local ok, err = pcall( error, NetworkError( 'no connection' ) )
	assert_false( ok )
	assert_true( err:isa( Error ) )
	assert_true( err:isa( NetworkError ) )
	assert_equal( 'no connection', err.message )
end

function test_globals()
	assert_equal( 'function', type( try ) )
	assert_equal( 'function', type( catch ) )
	assert_equal( 'function', type( finally ) )
end

function test_no_global_extend()
	assert_nil( rawget( _G, '_extend' ) )
end

function test_quick_start()
	local caught, ran
	try{
		function()
			local player = nil
			print( player.name )
		end,
		catch{ function( err ) caught = err end },
		finally{ function() ran = true end }
	}
	assert_match( "attempt to index local 'player'", caught )
	assert_true( ran )
end

-- fixed in lua-error 0.4.0; dmc-error's README named these as bugs

function test_finally_on_success_without_catch()
	local ran
	local a, b = try{
		function() return 1, 2 end,
		finally{ function() ran = true end }
	}
	assert_true( ran )
	assert_equal( 1, a )
	assert_equal( 2, b )
end

function test_finally_when_catch_raises()
	local ran
	local ok, err = pcall( try, {
		function() error( 'first', 0 ) end,
		catch{ function( e ) error( 'again: ' .. e, 0 ) end },
		finally{ function() ran = true end }
	} )
	assert_true( ran )
	assert_false( ok )
	assert_equal( 'again: first', err )
end

function test_no_catch_raises_again()
	local ok, err = pcall( try, {
		function() error( 'boom', 0 ) end
	} )
	assert_false( ok )
	assert_equal( 'boom', err )
end
