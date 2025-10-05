local groups = require "ruff-rules.groups"

local M = {}

--- Split ruff rule into group and number
M.split_rule = function(rule)
  local letters = rule:match("^[A-Z]+")
  local numbers = rule:match("%d+$")
  return {
    code = letters,
    number = numbers,
  }
end


return M
