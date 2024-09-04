local M = {}

local color = require('src.color')

local default_config = {
  gradient_level = 12,
  background = nil,
  base_colors = {
    "#34A853",
    "#4285F4",
    "#EA4335",
    "#FBBC05",
  },
}

M.indent_colors = {}
M.delimiter_colors = {}
M.scope_color_keys = {}
M.indent_color_keys = {}

function M.setup(config)
  default_config.background = string.format(
    "#%06x",
    vim.api.nvim_get_hl(0, { name = "Normal" }).bg
  )

  if config == nil then config = {} end
  setmetatable(config, { __index = default_config })

  vim.print(config)

  local colors = color.gen_gradient(config.base_colors, config.gradient_level)
  for i, _color in ipairs(colors) do
    local delimiter_color_key = "DelimiterColor" .. i
    table.insert(M.delimiter_colors, { key = delimiter_color_key, color = _color })
    table.insert(M.scope_color_keys, delimiter_color_key)

    local indent_color_key = "IndentColor" .. i
    table.insert(M.indent_colors, { key = indent_color_key, color = color.leap(_color, config.background, 0.8) })
    table.insert(M.indent_color_keys, indent_color_key)
  end
end

function M.apply()
  for _, pair in ipairs(M.indent_colors) do
    vim.api.nvim_set_hl(0, pair.key, { fg = pair.color })
  end
  for _, pair in ipairs(M.delimiter_colors) do
    vim.api.nvim_set_hl(0, pair.key, { fg = pair.color })
  end
end

return M
