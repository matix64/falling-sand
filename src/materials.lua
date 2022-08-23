function init_materials ()
  local materials = {
    void = {name = "Void", colors = {{0, 0, 0, 0}}, density = -1, gui_hidden = true, transparent = true},
    sand = {name = "Sand", colors = {{1, 1, 0, 1}}, fall = true, fall_sides = true, density = 2},
    water = {name = "Water", colors = {{0, 0, 1, 0.8}}, fall = true, fall_sides = true, slide = true, density = 1, transparent = true},
    stone = {name = "Stone", colors = {{0.8, 0.8, 0.8, 1}}, fall = true, density = 2},
    dirt = {name = "Dirt", colors = {{0.419, 0.329, 0.156, 1}}, fall = true, fall_sides = true, update = dirt_update, density = 2},
    grass = {name = "Grass", colors = {{19/255, 133/255, 16/255, 1}}, update = grass_update, density = 2, gui_hidden = true},
    fire = {name = "Fire", colors = {{234/255, 35/255, 0, 0}, {242/255, 85/255, 0, 0}, {1, 129/255, 0, 0}}, update = fire_update, density = 0, transparent = true},
    wood = {name = "Wood", colors = {{139/255, 90/255, 43/255, 1}}, update = flammable_update, density = 3}
  }
  return materials
end

function sand_update (pixel)
  if not fall_down (pixel) then
    fall_sides (pixel)
  end
end

function water_update (pixel)
  if not fall_down (pixel) then
    if not fall_sides (pixel) then
      slide (pixel)
    end
  end
end

function stone_update (pixel)
  fall_down (pixel)
  if chance_of_1_in (1000) and contact_with (pixel.x, pixel.y, materials.water) then
    grid.set_pixel (pixel.x, pixel.y, materials.sand)
  end
end

function dirt_update (pixel)
  if false or not fall_down (pixel) then
    if not fall_sides(pixel) then
      if chance_of_1_in(250) and grid.get_pixel (pixel.x, pixel.y - 1).material.transparent and (chance_of_1_in(50) or contact_with(pixel.x, pixel.y, materials.grass)) then
        grid.set_pixel (pixel.x, pixel.y, materials.grass)
      end
    end
  end
end

function grass_update (pixel)
  local under = grid.get_pixel (pixel.x, pixel.y + 1)
  if not grid.get_pixel (pixel.x, pixel.y - 1).material.transparent or (under and under.material == materials.void) then
    grid.set_pixel (pixel.x, pixel.y, materials.dirt)
  end
end

function fire_update (pixel)
  if chance_of_1_in (5) then
    pixel.stage = pixel.stage + 1
    if pixel.stage > 3 then
      grid.set_pixel (pixel.x, pixel.y, materials.void)
      return
    end
  end
  if chance_of_1_in (5) then
    slide (pixel)
  else
    local direction = one_or_minus_one()
    local moved = swap_if_less_density (pixel, grid.get_pixel (pixel.x, pixel.y - 1)) or 
      swap_if_less_density (pixel, grid.get_pixel (pixel.x + direction, pixel.y - 1)) or 
      swap_if_less_density (pixel, grid.get_pixel (pixel.x - direction, pixel.y - 1))
  end
end

function flammable_update (pixel)
  if chance_of_1_in (5) and contact_with (pixel.x, pixel.y, materials.fire) then
    grid.set_pixel (pixel.x, pixel.y, materials.fire)
  end
end