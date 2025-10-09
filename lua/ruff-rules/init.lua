local rules = require "ruff-rules.rules"
local picker = require "ruff-rules.telescope"
local log = require "ruff-rules.log"

---@param code string
---@return ruff.Rule|nil
local get_rule = function(code)
  local rule_details = rules(code)
  if #rule_details == 0 then
    log.error("No rule found for code: " .. code)
    return nil
  end
  if #rule_details > 1 then
    log.warn(
      "Total of "
        .. #rule_details
        .. " rules found for code: "
        .. code
        .. ". Please use `rules` function instead."
    )
    return
  end
  return rule_details[1]
end

---Explanation
return {
  groups = require "ruff-rules.groups",
  rule = get_rule,
  rules = rules,
  create_picker = picker.create_picker,
  create_explanation_buffer = function(code)
    local rule = get_rule(code)
    if rule then
      picker.create_explanation_buffer(rule)
    end
  end,
  setup = function(_)
    vim.api.nvim_create_user_command("RuffRules", function(input)
      local selected_rules = rules(input.args or "")
      if #selected_rules == 0 then
        log.error "No rules found for the given input."
        return
      end
      if #selected_rules == 1 then
        picker.create_explanation_buffer(selected_rules[1])
        return
      end
      picker.create_picker(selected_rules):find()
    end, {
      nargs = "?",
    })
  end,
}
