function new_button (x, y, text, action, color, icon, width, height, padding)
  local button = {
    x = x, y = y,
    text = text,
    left_click = action or function () end,
    color = color or {1, 1, 1},
    icon = icon,
    width = 80, height = 35,
    padding = padding or 10,
    highlight = false
  }
  button.draw = function () return draw_button (button) end
  return button
end

function draw_button (button)
  local text_left_margin = button.padding
  love.graphics.setColor (button.color)
  if button.icon ~= nil then
    local icon_y = math.floor(button.y + button.height / 2 - button.icon.height / 2)
    love.graphics.draw (button.icon.texture, button.icon.quad, button.x + button.padding, icon_y)
    text_left_margin = button.padding + button.icon.width
  end
  local text_y = math.floor(button.y + button.height / 2 - love.graphics.getFont():getHeight() / 2)
  love.graphics.printf (" " .. button.text, button.x + text_left_margin, text_y, button.width - text_left_margin - button.padding, "center")
  if button.highlight then
    love.graphics.line (button.x, button.y + button.height, button.x + button.width, button.y + button.height)
  elseif point_inside_aabb (love.mouse.getX(), love.mouse.getY(), button.x, button.y, button.width, button.height) then
    love.graphics.setColor (1, 1, 1)
    love.graphics.line (button.x + button.padding, button.y + button.height, button.x + button.width - button.padding, button.y + button.height)
  end
end