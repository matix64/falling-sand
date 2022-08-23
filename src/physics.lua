function update_pixel (pixel, update_number)
  if pixel.update ~= update_number then
    pixel.update = update_number
    local material = pixel.material
    if material.fall and not fall_down (pixel) then
      if material.slide then
        if slide (pixel) then
          fall_down (pixel)
        end
      else
        if material.fall_sides then
          fall_sides (pixel)
        end
      end
    end
    
    if material.update ~= nil then
      material.update (pixel)
    end
  end
end

function swap_if_less_density (from_pixel, to_pixel)
  if from_pixel and to_pixel and to_pixel.material.density < from_pixel.material.density then
    to_pixel.update = from_pixel.update
    grid.swap_pixels (from_pixel, to_pixel)
    return true
  else
    return false
  end
end

function contact_with (my_x, my_y, material)
  for x = -1, 1 do
    for y = -1, 1 do
      if x ~= 0 or y ~= 0 then
        local neighbour = grid.get_pixel (x + my_x, y + my_y)
        if neighbour and neighbour.material == material then
          return true
        end
      end
    end
  end
  return false
end

function fall_down (pixel)
  return swap_if_less_density (pixel, grid.get_pixel(pixel.x, pixel.y + 1))
end

function fall_sides (pixel)
  local side_pixel = grid.get_pixel (pixel.x + pixel.direction, pixel.y)
  if side_pixel == nil or side_pixel.material.density >= pixel.material.density or not swap_if_less_density (pixel, grid.get_pixel (pixel.x + pixel.direction, pixel.y + 1)) then      
    pixel.direction = pixel.direction * -1
  end
end

function slide (pixel)
  if slide_one_side (pixel, pixel.direction) then
    return true
  elseif slide_one_side (pixel, -pixel.direction) then
    pixel.direction = pixel.direction * -1
    return true
  else
    return false
  end
end

function slide_one_side (pixel, side)
  local side_pixel = grid.get_pixel (pixel.x + side, pixel.y)
  if side_pixel ~= nil then
    return swap_if_less_density (pixel, side_pixel)
  end
end