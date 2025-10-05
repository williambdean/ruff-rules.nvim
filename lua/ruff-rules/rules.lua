--- Module to fetch and filter Ruff rules using Plenary Job.
local _, Job = pcall(require, "plenary.job")
local groups = require "ruff-rules.groups"
local utils = require "ruff-rules.utils"

--- Extract the group from a rule code.
--- For example, "E501" -> "E", "B007" -> "B", "PLR0912" -> "PLR"
--- @param rule string The rule code.
--- @return string The extracted group.
local get_group = function(rule)
  return rule:match "^[A-Z]+" or ""
end

local function contains(table, val)
  for i = 1, #table do
    if table[i] == val then
      return true
    end
  end
  return false
end

local get_rules = function(group, code)
  local job = Job:new {
    enable_recording = true,
    command = "uvx",
    args = {
      "ruff",
      "rule",
      "--output-format=json",
      "--all",
    },
  }
  job:sync()
  local stderr = table.concat(job:stderr_result(), "\n")
  if stderr ~= "" then
    print("Error:", stderr)
    return {}
  end
  local stdout = table.concat(job:result(), "\n")

  local rules = vim.json.decode(stdout)

  for _, rule in ipairs(rules) do
    local parts = utils.split_rule(rule.code)
    rule.group = parts.code
    rule.number = parts.number
  end

  if group == "" then
    return rules
  end

  local filtered_rules = {}
  for _, rule in ipairs(rules) do
    if rule.group == group then
      table.insert(filtered_rules, rule)
    end
  end

  if code == "" then
    return filtered_rules
  end

  local final_rules = {}
  for _, rule in ipairs(filtered_rules) do
    if rule.number == code then
      table.insert(final_rules, rule)
    end
  end

  return final_rules
end

-- uvx ruff rule --output-format=json --all
-- The keys
-- [
--   "code",
--   "explanation",
--   "fix",
--   "linter",
--   "message_formats",
--   "name",
--   "preview",
--   "summary"
-- ]
return function(rule)
  local parts = utils.split_rule(rule or "")
  local group = parts.code or ""

  if group ~= "" and not contains(groups, group) then
    error("Invalid group: " .. group)
    return {}
  end

  local number = parts.number or ""
  return get_rules(group, number)
end
