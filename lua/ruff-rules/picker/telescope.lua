---This is a Telescope picker for Ruff rules.
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local previewers = require "telescope.previewers"
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local utils = require "ruff-rules.utils"
local buffer = require "ruff-rules.buffer"

local open_explanation_in_buffer = function(prompt_bufnr)
  local entry = action_state.get_selected_entry()
  actions.close(prompt_bufnr)

  if not entry or not entry.obj then
    print "Could not get entry data."
    return
  end

  buffer.create_explanation_buffer(entry.obj)
end

---@param rules ruff.Rule[]
local function create_picker(rules)
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
          buffer.get_lines_from_explanation(entry.obj.explanation, entry.value)
        vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
      end,
    },
    attach_mappings = function(prompt_bufnr, map)
      map("i", "<CR>", open_explanation_in_buffer)
      map("n", "<CR>", open_explanation_in_buffer)
      map("i", buffer.open_in_browser_lhs, function()
        actions.close(prompt_bufnr)
        local entry = action_state.get_selected_entry()
        utils.open_in_browser(entry.obj.documentation_url)
      end)
      return true
    end,
  })
end

---@param rules ruff.Rule[]
return function(rules)
  create_picker(rules):find()
end
