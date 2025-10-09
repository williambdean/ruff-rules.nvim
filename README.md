# ruff-rules.nvim

This provides buffers and a telescope picker for ruff rules:

![Ruff Rules Picker](assets/ruff-rules-preview.png)

Press `<CR>` to create a buffer with the rule explanation.
Press `<C-b>` from picker or buffer to open the rule in your browser.

## Dependencies

This relies on [`uv`](https://docs.astral.sh/uv/) in order to get a version of ruff.

## Installation

Using your favorite plugin manager. For example, with `lazy.nvim`:

```lua
{
  "williambdean/ruff-rules.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim"
    "nvim-lua/plenary.nvim"
  },
}
```

## Usage

The plugin provides the following command:

```lua
:RuffRules <optional rule prefix or exact rule>
```

Examples:

```lua
--- Picker for all rules
:RuffRules

--- Picker for Pyflakes rules
:RuffRules F

--- Pull up buffer for a specific rule
:RuffRules F401
```

## Lua API

There is also a Lua API:

```lua
local ruff_rules = require "ruff-rules"

---@type string[]
local rule_groups = ruff_rules.groups

---@type ruff.Rule
local rule_detail = ruff_rules.rule("F401")

---@type ruff.Rule[]
local all_rule_details = ruff_rules.rules()

---@type ruff.Rule[]
local pyflakes_rule_details = ruff_rules.rules("F")

--- Create a buffer with specified rule
ruff_rules.create_explanation_buffer("F401")
```

## References

- [Ruff Rules](https://docs.astral.sh/ruff/rules/)
