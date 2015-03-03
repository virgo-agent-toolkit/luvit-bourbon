#!/usr/bin/env luvit

local fs = require('fs')
local Path = require('path')
local bourbon = require('./')
local async = require('async')
local string = require('string')
local table = require('table')
local fmt = require('string').format

local TEST_PATH = './tests'

local function runit(filename, callback)
  local modname = './' .. Path.join(TEST_PATH, filename)
  print(fmt('Executing test module [%s]\n\n', modname))
  bourbon.run(nil, require(modname), function()
    print('\n')
    callback()
  end)
end

fs.readdir(TEST_PATH, function(err, files)
  assert(err == nil)
  local test_files = {}

  for _, v in ipairs(files) do
    local _, _, ext = string.find(v, '^test-.*%.(.*)')
    if ext == 'lua' then
      table.insert(test_files, v)
    end
  end

  async.forEachSeries(test_files, runit, function(err)
    if err then
      p(err)
    end
  end)
end)

