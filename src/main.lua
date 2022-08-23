require "grid"
require "gui/gui"
require "gui/material_selector"
require "input"
require "materials"
require "physics"
require "util"
require "draw"

function love.load ()
  profiler = require('profile')
  materials = init_materials ()
  current_material = materials.sand
  grid = init_grid (212, 120, materials.void)
  gui = init_gui (848, 480)
  gui.add_element (new_material_picker (0, 0, materials))
  love.window.setMode (848, 480)
  last_active_line = grid.height - 1
  grid_renderer = new_grid_renderer (grid)
  love.window.setVSync(true)
end

current_frame = 0
function love.run ()
  love.load()
	love.timer.step()
  
	return function()
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a or 0
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end
    mouse_input ()
 
		local dt = love.timer.step()
    
    love.window.setTitle (love.timer.getFPS())
    if debug_mode and current_frame % 10 == 0 then
      last_profiler_report = profiler.report(20)
      profiler.reset()
    end

    if not in_pause then
      grid_renderer.begin()
      grid.for_each (current_frame % 2 == 0, process_pixel)
    end
    grid_renderer.finish ()
    
    gui.draw ()
    current_frame = current_frame + 1

    love.graphics.present()
 
		love.timer.sleep(0.001)
	end
end

function process_pixel (pixel, x, y)
  if pixel.material ~= grid.background_material then
    grid_renderer.put (x, y + 1, pixel.material, pixel.stage)
    update_pixel (pixel, current_frame % 2)
  end
end
