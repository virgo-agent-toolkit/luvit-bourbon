local async = require 'async'
local table = require 'table'
local string = require 'string'
local math = require 'math'

local TS = tostring
local fmt = string.format

local checked = 0

-- ###########
-- # Results #
-- ###########

local function msec(t)
   if t and type(t) == "number" then 
      return fmt(" (%.2fms)", t * 1000)
   else
      return ""
   end
end


local RPass = {}
local passMT = {__index=RPass}
function RPass:tostring_char() return "." end
function RPass:add(s, name) s.pass[name] = self end
function RPass:type() return "pass" end
function RPass:tostring(name)
   return fmt("PASS: %s%s%s",
              name or "(unknown)", msec(self.elapsed),
              self.msg and (": " .. tostring(self.msg)) or "")
end


local RFail = {}
local failMT = {__index=RFail}
function RFail:tostring_char() return "F" end
function RFail:add(s, name) s.fail[name] = self end
function RFail:type() return "fail" end
function RFail:tostring(name)
   return fmt("FAIL: %s%s: %s%s",
              name or "(unknown)",
              msec(self.elapsed), self.reason or "",
              self.msg and (" - " .. tostring(self.msg)) or "")
end


local RSkip = {}
local skipMT = {__index=RSkip}
function RSkip:tostring_char() return "s" end
function RSkip:add(s, name) s.skip[name] = self end
function RSkip:type() return "skip" end
function RSkip:tostring(name)
   return fmt("SKIP: %s()%s", name or "unknown",
              self.msg and (" - " .. tostring(self.msg)) or "")
end


local RError = {}
local errorMT = {__index=RError}
function RError:tostring_char() return "E" end
function RError:add(s, name) s.err[name] = self end
function RError:type() return "error" end
function RError:tostring(name)
   return self.msg or
      fmt("ERROR (in %s%s, couldn't get traceback)",
          msec(self.elapsed), name or "(unknown)")
end


local function Pass(t) return setmetatable(t or {}, passMT) end
local function Skip(t) return setmetatable(t, skipMT) end
local function Error(t) return setmetatable(t, errorMT) end
local function Fail(t) return setmetatable(t, failMT) end

local function wraptest(flag, msg, t)
   checked = checked + 1
   t.msg = msg
   if not flag then error(Fail(t)) end
end

---exp == got.
function assert_equal(exp, got, tol, msg)
  wraptest(exp == got, msg, { reason=fmt(""), TS(exp), TS(tol), TS(got)})
end

function is_test_key(k)
  return type(k) == "string" and k:match("_*test.*")
end

local function get_tests(mod)
  local ts = {}
  for k,v in pairs(mod) do
    if is_test_key(k) and type(v) == "function" then
      ts[k] = v
    end
  end
  ts.setup = rawget(mod, "setup")
  ts.teardown = rawget(mod, "teardown")
  ts.ssetup = rawget(mod, "suite_setup")
  ts.steardown = rawget(mod, "suite_teardown")
  return ts
end

local run_test = function(runner, callback)
  local test_baton = {}
  test_baton.done = function()
  end
  runner.func(test_baton)
  callback()
end

local run = function(mods)
  local runners = {}

  for k, v in pairs(get_tests(mods)) do
    table.insert(runners, 1, { name = k, func = v })
  end

  async.forEachSeries(runners, function(runner, callback)
    run_test(runner, callback)
  end, function(err)
    print(fmt("Executed %s", checked))
  end)
end

function assert_array_equal(_a, _b)
  for k=1,#_b do
    print(_a[k])
    print(_b[k])
    assert_equal(_a[k], _b[k])
  end
end

--got ~= nil
function assert_not_nil(got, msg)
   wraptest(got ~= nil, msg,
            { reason=fmt("Expected non-nil value, got %s", TS(got)) })
end

function assert_true(got, msg)
   wraptest(got, msg, { reason=fmt("Expected success, got %s.", TS(got)) })
end

local exports = {}
exports.asserts = {}
exports.asserts.equal = assert_equal
exports.asserts.True = assert_true
exports.asserts.array_equal= assert_array_equal
exports.asserts.not_nil = assert_not_nil
exports.run = run
return exports
