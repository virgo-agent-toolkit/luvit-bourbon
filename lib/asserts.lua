local async = require 'async'
local table = require 'table'
local string = require 'string'
local math = require 'math'

local fmt = string.format

local checked = 0

local asserts = {}
asserts.equal = function(a, b)
  checked = checked + 1
  assert(a == b)
end
asserts.ok = function(a)
  checked = checked + 1
  assert(a)
end
asserts.equals = function(a, b)
  checked = checked + 1
  assert(a == b)
end
asserts.array_equals = function(a, b)
  checked = checked + 1
  assert(#a == #b)
  for k=1, #a do
    assert(a[k] == b[k])
  end
end
asserts.not_nil = function(a)
  checked = checked + 1
  assert(a ~= nil)
end
asserts.checked = function()
  return checked
end

return asserts
