function new_material_picker (x, y, materials)
  local material_picker = { x = x, y = y, buttons = {} }
  
  local icons = {}
  local iconspng = love.graphics.newImage ('res/material_icons.png')
  iconspng:setFilter ("nearest", "nearest")
  
  for i = 0, math.floor(iconspng:getWidth() / 12) do
    icons[i+1] = {
      texture = iconspng,
      quad = love.graphics.newQuad (12 * i, 0, 12, 12, iconspng:getWidth(), iconspng:getHeight()),
      width = 12,
      height = 12
    }
  end
  
  local icons_for_materials = {
    [materials.water] = icons[1],
    [materials.stone] = icons[2],
    [materials.fire] = icons[3],
    [materials.wood] = icons[4],
    [materials.dirt] = icons[5],
    [materials.sand] = icons[6]
  }
  local button_width, button_height = 80, 35
  for _, mat in pairs (materials) do
    if not mat.gui_hidden then
      table.insert(material_picker.buttons, new_button (x, y, mat.name, function () current_material = mat end, color_without_alpha(mat.colors[1]), icons_for_materials[mat]))
      x = x + button_width
    end
  end
  material_picker.width = x + button_width
  material_picker.height = button_height
  material_picker.left_click = function (x, y) return material_picker_left_click (material_picker, x, y) end
  material_picker.draw = function () return material_picker_draw (material_picker) end
  return material_picker
end

function material_picker_left_click (picker, x, y)
  for _, button in ipairs (picker.buttons) do
    if point_inside_aabb (x, y, button.x, button.y, button.width, button.height) then
      if button.left_click ~= nil then
        if picker.highlighted_button ~= nil then
          picker.highlighted_button.highlight = false
        end
        button.highlight = true
        picker.highlighted_button = button
        button.left_click (x, y)
        return true
      end
    end
  end
  return false
end

function material_picker_draw (material_picker)
  for _, button in ipairs (material_picker.buttons) do
    button.draw ()
  end
end
