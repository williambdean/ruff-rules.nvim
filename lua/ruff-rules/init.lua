local rules = require "ruff-rules.rules"
local picker = require "ruff-rules.telescope"
local log = require "ruff-rules.log"

return {
  rules = rules,
  create_picker = picker.create_picker,
  setup = function(_)
    vim.api.nvim_create_user_command("RuffRules", function(input)
      local selected_rules = rules(input.args or "")
      if #selected_rules == 0 then
        log.error "No rules found for the given input."
        return
      end
      if #selected_rules == 1 then
        picker.create_buffer_with_explanation { obj = selected_rules[1] }
        return
      end
      picker.create_picker(selected_rules):find()
    end, {
      nargs = "?",
    })
  end,
}
