local table = require('table')

local call_order = {}

local under_test = {}
under_test['setup'] = function(test, asserts)
  table.insert(call_order, 'setup')
  test.done()
end

under_test['teardown'] = function(test, asserts)
  table.insert(call_order, 'teardown')
  test.done()
end

local exports = {}

exports['test_setup_teardown'] = function(test, asserts)
  local bourbon = require('./init.lua')
  local options = {
    print_summary = false,
    verbose = false,
  }
  bourbon.run(options, under_test, function(err, stats)
    asserts.equals(call_order[1], 'setup')
    asserts.equals(call_order[2], 'teardown')
    test.done()
  end)
end

return exports
