local M = {}

local notify = function(msg, level)
  vim.notify(msg, level, { title = "Ruff Rules" })
end

M.info = function(msg)
  notify(msg, vim.log.levels.INFO)
end

M.warn = function(msg)
  notify(msg, vim.log.levels.WARN)
end

M.error = function(msg)
  notify(msg, vim.log.levels.ERROR)
end

return M
