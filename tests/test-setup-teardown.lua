--[[
Copyright 2012 Rackspace

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS-IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
--]]

local table = require('table')
local bourbon = require('../init')

local call_order = {}

local under_test = {}
under_test['setup'] = function(test)
  table.insert(call_order, 'setup')
  test.done()
end

under_test['teardown'] = function(test)
  table.insert(call_order, 'teardown')
  test.done()
end

local exports = {}

exports['test_setup_teardown'] = function(test, asserts)
  local options = {
    print_summary = false,
    verbose = false,
  }
  bourbon.run(options, under_test, function(err)
    assert(not err)
    asserts.equals(call_order[1], 'setup')
    asserts.equals(call_order[2], 'teardown')
    test.done()
  end)
end

exports['test_skipit'] = function(test)
  test.skip()
end

exports['test_skipit_with_reason'] = function(test)
  test.skip("Is there a reason?")
end

return exports
