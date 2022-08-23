require "gui/button"

function init_gui (wind_width, wind_height)
  local gui = { elements = {}, font_regular = love.graphics.newFont (12), font_mono = love.graphics.newFont ("res/roboto-mono/RobotoMono-Regular.ttf") }
  
  gui.draw = function () return draw_gui (gui) end
  gui.click = function (x, y) return click_gui (gui, x, y) end
  gui.right_click = function (x, y) return right_click_gui (gui, x, y) end
  gui.add_element = function (element) table.insert (gui.elements, element) end
  
  return gui
end

function draw_gui (gui)
  love.graphics.setFont (gui.font_regular)
  love.graphics.setBlendMode ("alpha")
  for _, element in ipairs (gui.elements) do
    element.draw ()
  end
  if debug_mode then
    draw_debug (gui)
  end
end

function draw_debug (gui)
  love.graphics.setFont (gui.font_mono)
  love.graphics.setColor (0, 0, 1)
  love.graphics.print(last_profiler_report or "Please wait...", 3, 45)
end

function click_gui (gui, x, y)
  for _, element in ipairs (gui.elements) do
    if point_inside_aabb (x, y, element.x, element.y, element.width, element.height) then
      if element.left_click ~= nil then
        element.left_click (x, y)
        return true
      end
    end
  end
  return false
end

function right_click_gui (gui, x, y)
  for _, element in ipairs (gui.elements) do
    if point_inside_aabb (x, y, element.x, element.y, element.width, element.height) then
      return true
    end
  end
  return false
end
