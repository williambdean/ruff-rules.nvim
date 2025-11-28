local buffer = require "ruff-rules.buffer"

---@param rules ruff.Rule[]
return function(rules)
  vim.ui.select(rules, {
    prompt = "Select a Ruff Rule:",
    format_item = function(item)
      return item.code .. ": " .. item.name
    end,
  }, function(rule)
    if rule then
      buffer.create_explanation_buffer(rule)
    end
  end)
end
