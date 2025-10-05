local rules = require "ruff-rules.rules"
local picker = require "ruff-rules.telescope"

return {
  rules = rules,
  create_picker = picker.create_picker,
  setup = function(opts)
    vim.api.nvim_create_user_command("RuffRules", function(input)
      picker.create_picker(input.args or "")
    end, {
      nargs = "?",
    })
  end,
}
