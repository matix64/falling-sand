function love.keypressed (key)
  if key == "space" then
    in_pause = not in_pause
  elseif key == "f3" then
    if debug_mode then
      debug_mode = false
      profiler.stop()
    else
      debug_mode = true
      profiler.start()
    end
  end
end

function screen_to_world_coords (x, y)
  local w, h = love.window.getMode()
  return {x = math.floor(x * (grid.width / w)), y = math.floor(y * (grid.height / h))}
end

function mouse_input ()
  if love.mouse.isDown (1) and not love.mouse.isDown (2) then
    if not gui.click(love.mouse.getPosition()) then
      local position = screen_to_world_coords(love.mouse.getPosition())
      if last_position ~= nil then
        grid.draw_line (last_position, position, current_material)
      end
      last_position = position
    end
  elseif love.mouse.isDown (2) then
    if not gui.right_click (love.mouse.getPosition ()) then
      local position = screen_to_world_coords(love.mouse.getPosition())
      if last_position ~= nil then
        grid.draw_line (last_position, position, materials.void)
      end
      last_position = position
    end
  else
    last_position = nil
  end
end