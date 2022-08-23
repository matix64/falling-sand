function new_grid_renderer (grid)
  local shader_source = [[
    uniform vec2 pixel_distance;
    
    float light_from (Image tex, vec2 coord) {
      return 1 - Texel (tex, coord).a;
    }
    
    float rand(vec2 n) { 
      return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
    }

    float noise(vec2 p){
      vec2 ip = floor(p);
      vec2 u = fract(p);
      u = u*u*(3.0-2.0*u);
      
      float res = mix(
        mix(rand(ip),rand(ip+vec2(1.0,0.0)),u.x),
        mix(rand(ip+vec2(0.0,1.0)),rand(ip+vec2(1.0,1.0)),u.x),u.y);
      return res*res;
    }
    
    vec4 effect (vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
    {
      float light = 0.6;
      float next_light_weight = 0.4;
      for (int i = 1; i <= 24; i++) {
        float current_light = 1 - Texel (tex, texture_coords - vec2(0, pixel_distance.y * i)).a;
        light += current_light * next_light_weight;
        next_light_weight *= 0.9 * (1 - current_light); // Stop adding light after finding the first one
      }
      vec3 litcolor = Texel(tex, texture_coords).rgb * light;
      float noise = 1 - noise(vec2(floor(texture_coords.x / pixel_distance.x), floor(texture_coords.y / pixel_distance.y))) * 0.2 / length (litcolor);
      return vec4 (litcolor * noise, 1);
    }
  ]]
  local draw_object = {
    grid = grid,
    shader = love.graphics.newShader (shader_source),
    canvas = love.graphics.newCanvas (grid.width, grid.height)
  }
  draw_object.shader:send ("pixel_distance", {1 / grid.width, 1 / grid.height})
  draw_object.canvas:setFilter ("nearest", "nearest")
  draw_object.put = function (x, y, material, stage) return draw_object_put (draw_object, x, y, material, stage) end
  draw_object.begin = function () return draw_object_begin (draw_object) end
  draw_object.finish = function () return draw_object_finish (draw_object) end
  return draw_object
end

function draw_object_put (draw, x, y, material, stage)
  love.graphics.setColor (material.colors[stage])
  love.graphics.points (x, y)
end

function draw_object_begin (draw)
  love.graphics.setCanvas (draw.canvas)
  love.graphics.setBlendMode ("replace", "premultiplied")
  love.graphics.clear (draw.grid.background_material.color)
end

function draw_object_finish (draw)
  local scale = love.window.getMode() / draw.grid.width
  love.graphics.setCanvas ()
  love.graphics.setShader (draw.shader)
  love.graphics.draw (draw.canvas, 0, 0, 0, scale, scale)
  love.graphics.setShader ()
end