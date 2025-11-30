local utils = require "ruff-rules.utils"

local M = {}

M.get_lines_from_explanation = function(explanation, rule_code)
  if explanation and explanation ~= "" then
    local normalized_explanation =
      explanation:gsub("\r\n", "\n"):gsub("\r", "\n")
    return vim.split(normalized_explanation, "\n", { plain = true })
  else
    return { "No explanation available for " .. rule_code }
  end
end

M.open_in_browser_lhs = "<C-b>"

---@param rule ruff.Rule
function M.create_explanation_buffer(rule)
  vim.cmd "only | enew"
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "wipe"
  vim.bo.filetype = "markdown"
  vim.api.nvim_buf_set_name(0, rule.code .. "-" .. rule.name .. ".md")

  local lines = M.get_lines_from_explanation(rule.explanation, rule.code)
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)

  vim.api.nvim_buf_set_keymap(0, "n", M.open_in_browser_lhs, "", {
    noremap = true,
    silent = true,
    callback = function()
      utils.open_in_browser(rule.documentation_url)
    end,
  })

  vim.bo.readonly = true
  vim.bo.modifiable = false
end

return M
