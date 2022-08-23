function point_inside_aabb (point_x, point_y, box_x, box_y, width, height)
  return 
    point_x >= box_x and 
    point_x < box_x + width and 
    point_y >= box_y and 
    point_y < box_y + height
end

function one_or_minus_one ()
  return math.floor(math.random() + 0.5) * 2 - 1
end

function chance_of_1_in (num)
  return math.random() < (1/num)
end

function color_without_alpha (color)
  if color ~= nil then
    return {color[1], color[2], color[3]}
  else
    return nil
  end
end