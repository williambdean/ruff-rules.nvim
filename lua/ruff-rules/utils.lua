local groups = require "ruff-rules.groups"

local M = {}

--- Split ruff rule into group and number
M.split_rule = function(rule)
  local letters = rule:match "^[A-Z]+"
  local numbers = rule:match "%d+$"
  return {
    code = letters,
    number = numbers,
  }
end

--- Taken from octo.nvim
---@param url string
function M.open_in_browser(url)
  local os_name = vim.loop.os_uname().sysname
  local is_windows = vim.loop.os_uname().version:match "Windows"

  if os_name == "Darwin" then
    os.execute("open " .. url)
  elseif os_name == "Linux" then
    os.execute("xdg-open " .. url)
  elseif is_windows then
    os.execute("start " .. url)
  end
end

return M
