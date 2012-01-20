#!/usr/bin/env luvit

exports = {}

exports['test_asserts_ok'] = function(test, asserts)
  asserts.ok(true)
  test.done()
end

exports['test_asserts_equals'] = function(test, asserts)
  asserts.equals(1, 1)
  test.done()
end

exports['test_asserts_dequals'] = function(test, asserts)
  asserts.dequals({1,2,3, foo = 'foo', bar = { 'baz' }}, {bar = { 'baz' }, 1,2,3, foo = 'foo'})
  test.done()
end

exports['test_asserts_nil'] = function(test, asserts)
  asserts.is_nil(nil)
  test.done()
end

exports['test_asserts_not_nil'] = function(test, asserts)
  asserts.not_nil(1)
  asserts.throws(asserts.not_nil, nil)
  test.done()
end

--[[exports['test_asserts_table'] = function(test, asserts)
  asserts.is_table({})
  asserts.is_table({1,2,3})
  asserts.is_table({a=1,b=3})
  asserts.is_table({a=1,0,2,3,b=3})
  _not(asserts.is_table, 1)
  _not(asserts.is_table, false)
  _not(asserts.is_table, true)
  _not(asserts.is_table, 'a')
  test.done()
end]]--

--[[
exports['test_asserts_array'] = function(test, asserts)
  asserts.is_table({})
  asserts.is_table({1,2,3})
  asserts.is_table({a=1,b=3})
  asserts.is_table({a=1,0,2,3,b=3})
  asserts.is_table(1)
  asserts.is_table(false)
  asserts.is_table(true)
  asserts.is_table('a')
  test.done()
end
]]--

return exports
