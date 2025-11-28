local default = require "ruff-rules.picker.default"
local ok, telescope = pcall(require, "ruff-rules.picker.telescope")

return {
  ---@param rules ruff.Rule[]
  ---@param opts? ruff.Config
  create_picker = function(rules, opts)
    if ok and (opts and opts.picker == "telescope") then
      return telescope(rules)
    else
      return default(rules)
    end
  end,
}
