function init_grid (width, height, fill_material)
  local grid = {}
  
  grid.width = width
  grid.height = height
  grid.max_index = width * height - 1
  grid.background_material = fill_material
  
  grid.set_pixel = function (x, y, material)
    return grid_set_pixel (grid, x, y, material)
  end
  grid.get_pixel = function (x, y)
    return grid_get_pixel (grid, x, y)
  end
  grid.draw_line = function (inicio, fin, material)
    return grid_draw_line (grid, inicio, fin, material)
  end
  grid.valid_coords = function (x, y)
    return grid_valid_coords (grid, x, y)
  end
  grid.swap_pixels = function (x1, y1, x2, y2)
    return grid_swap_pixels (grid, x1, y1, x2, y2)
  end
  grid.draw_pixel = function (x, y, material)
    return grid_draw_pixel (grid, x, y, material)
  end
  grid.iter = function (invert_x)
    return grid_iter (grid, invert_x)
  end
  grid.for_each = function (invert_x, func)
    grid_for_each_pixel (grid, invert_x, func)
  end
  
  for x = 0, width - 1 do
    for y = 0, height - 1 do
      grid [y * grid.width + x] = { update = 0, material = fill_material, direction = one_or_minus_one(), stage = 1, x = x, y = y }
    end
  end
  
  return grid
end

function grid_set_pixel (grid, x, y, material)
  local pixel = grid [y * grid.width + x]
  pixel.material = material
  pixel.stage = 1
end

function grid_get_pixel (grid, x, y)
  if x >= 0 and x < grid.width then
    return grid [y * grid.width + x]
  else
    return nil
  end
end

function grid_draw_pixel (grid, x, y, material)
  if grid.valid_coords (x, y) and (material == grid.background_material or grid.get_pixel (x, y).material == grid.background_material) then
    grid.set_pixel (x, y, material)
    last_active_line = math.max (last_active_line, y)
  end
end

function grid_draw_line (grid, inicio, fin, material)
  local floor, abs = math.floor, math.abs
  local dx = (fin.x - inicio.x)
  local dy = (fin.y - inicio.y)
  local step
  if (abs(dx) >= abs(dy)) then
    step = abs(dx)
  else
    step = abs(dy)
  end
  dx = dx / step
  dy = dy / step
  local x = inicio.x
  local y = inicio.y
  local i = 1
  if step == 0 then
    grid.draw_pixel (floor(inicio.x), floor(inicio.y), material)
  end
  while i <= step do
    grid.draw_pixel (floor(x), floor(y), material)
    x = x + dx
    y = y + dy
    i = i + 1
  end
end

function grid_swap_pixels (grid, pixel_a, pixel_b)
  grid [pixel_a.y * grid.width + pixel_a.x], grid [pixel_b.y * grid.width + pixel_b.x] = pixel_b, pixel_a
  pixel_a.x, pixel_b.x = pixel_b.x, pixel_a.x
  pixel_a.y, pixel_b.y = pixel_b.y, pixel_a.y
end

function grid_valid_coords (grid, x, y)
  return x >= 0 and x < grid.width and y >= 0 and y < grid.height and math.floor(x) == x and math.floor(y) == y
end

function grid_for_each_pixel (grid, invert_x, func)
  local x_start, x_end, x_step
  if invert_x then
    x_start, x_end, x_step = grid.width - 1, 0, -1
  else
    x_start, x_end, x_step = 0, grid.width - 1, 1
  end
  local row_index
  for y = grid.height - 1, 0, -1 do
    row_index = y * grid.width
    for x = x_start, x_end, x_step do
      func (grid [row_index + x], x, y)
    end
  end
end

function grid_iter (grid, invert_x)
  local x_start, x_end, x_step
  if invert_x then
    x_start, x_end, x_step = grid.width - 1, -1, -1
  else
    x_start, x_end, x_step = 0, grid.width, 1
  end
  local x = x_start - x_step
  local y, y_end = grid.height - 1, 0
  local row_starting_index = y * grid.width
  local grid_width = grid.width
  return function ()
    x = x + x_step
    if x == x_end then
      x = x_start
      y = y - 1
      row_starting_index = row_starting_index - grid_width
    end
    if y >= y_end then
      return grid [row_starting_index + x], x, y
    end
  end
end