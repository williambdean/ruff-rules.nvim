---This is a Telescope picker for Ruff rules.
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local previewers = require "telescope.previewers"
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local M = {}

local get_lines_from_explanation = function(explanation, rule_code)
  if explanation and explanation ~= "" then
    local normalized_explanation =
      explanation:gsub("\r\n", "\n"):gsub("\r", "\n")
    return vim.split(normalized_explanation, "\n", { plain = true })
  else
    return { "No explanation available for " .. rule_code }
  end
end

---@param rule ruff.Rule
M.create_explanation_buffer = function(rule)
  vim.cmd "only | enew"
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "wipe"
  vim.bo.filetype = "markdown"
  vim.api.nvim_buf_set_name(0, rule.code .. "-" .. rule.name .. ".md")

  local lines = get_lines_from_explanation(rule.explanation, rule.code)
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)

  vim.bo.readonly = true
  vim.bo.modifiable = false
end

local open_explanation_in_buffer = function(prompt_bufnr)
  local entry = action_state.get_selected_entry()
  actions.close(prompt_bufnr)

  if not entry or not entry.obj then
    print "Could not get entry data."
    return
  end

  M.create_explaination_buffer(entry.obj)
end

function M.create_picker(rules)
  local opts = {}
  return pickers.new(opts, {
    finder = finders.new_table {
      results = rules,
      entry_maker = function(entry)
        return {
          value = entry.code,
          display = entry.code .. ": " .. entry.name,
          ordinal = entry.code .. " " .. entry.name,
          obj = entry,
        }
      end,
    },
    sorter = conf.generic_sorter(opts),
    previewer = previewers.new_buffer_previewer {
      title = "Ruff Rule Explanation",
      get_buffer_by_name = function(_, entry)
        return entry.value
      end,
      define_preview = function(self, entry)
        vim.bo[self.state.bufnr].filetype = "markdown"
        local lines =
          get_lines_from_explanation(entry.obj.explanation, entry.value)
        vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
      end,
    },
    attach_mappings = function(prompt_bufnr, map)
      map("i", "<CR>", open_explanation_in_buffer)
      map("n", "<CR>", open_explanation_in_buffer)
      return true
    end,
  })
end

return M
