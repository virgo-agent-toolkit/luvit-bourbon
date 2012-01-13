Bourbon - testing for luvit
===========================

This is a test runner for luvit inspired by whiskey. A basic testing file looks something like this:

    exports = {}

    exports['test_asserts_ok'] = function(test)
      asserts.ok(true)
      test.done()
    end

    exports['test_asserts_equal'] = function(test)
      asserts.equals(1, 1)
      test.done()
    end

    return exports

Hacking
=======
#### Running the tests

    ./test.lua

License
=======

Apache 2.0, for more info see [LICENSE](/racker/bourbon/blob/master/LICENSE).