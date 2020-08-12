pattern = {}

width = 10
height = 10
spacing = 10
margin = 30

function loadPattern(g_x, g_y, g_c, g_r)
  local x_count = g_x
  local y_count = g_y
  local color = {1,1,1}
  for col = 1, 4 do
    -- pattern[col] = {}
    for row = 1, 6 do
      if col == 1 or col == 3 then
        color = {1,0,0}
        loc = outer
      elseif row == 2 or row == 4 or row == 6 then
        color = {0,1,0}
        loc = inner
      elseif row == 3 or row == 5 then
        color = {1,1,0}
        loc = inner
      end

      if g_c < 12 then
        if g_c % 2 == 0 then
          if col == 3 and row == 1 then
            table.insert(pattern, row, {x = (col * spacing) + x_count, y = (row * spacing) + y_count, w = width, h = height, c = color, id = loc})
            -- pattern[col][row] = {x = (col * spacing) + x_count, y = (row * spacing) + y_count, w = width, h = height, c = color, id = loc}
          end
          if col == 2 and row > 1 then
            table.insert(pattern, row, {x = (col * spacing) + x_count, y = (row * spacing) + y_count, w = width, h = height, c = color, id = loc})
            -- pattern[col][row] = {x = (col * spacing) + x_count, y = (row * spacing) + y_count, w = width, h = height, c = color, id = loc}
          end
          if col == 4 and row > 1 then
            table.insert(pattern, row, {x = (col * spacing) + x_count, y = (row * spacing) + y_count, w = width, h = height, c = color, id = loc})
            -- pattern[col][row] = {x = (col * spacing) + x_count, y = (row * spacing) + y_count, w = width, h = height, c = color, id = loc}
          end
        else
          if col == 1 and row == 1 then
            table.insert(pattern, row, {x = (col * spacing) + x_count, y = (row * spacing) + y_count, w = width, h = height, c = color, id = loc})
            -- pattern[col][row] = {x = (col * spacing) + x_count, y = (row * spacing) + y_count, w = width, h = height, c = color, id = loc}
          end
          if col == 2 and row > 1 then
            table.insert(pattern, row, {x = (col * spacing) + x_count, y = (row * spacing) + y_count, w = width, h = height, c = color, id = loc})
            -- pattern[col][row] = {x = (col * spacing) + x_count, y = (row * spacing) + y_count, w = width, h = height, c = color, id = loc}
          end
          if col == 4 and row > 1 then
            table.insert(pattern, row, {x = (col * spacing) + x_count, y = (row * spacing) + y_count, w = width, h = height, c = color, id = loc})
            -- pattern[col][row] = {x = (col * spacing) + x_count, y = (row * spacing) + y_count, w = width, h = height, c = color, id = loc}
          end
        end
      elseif g_c == 12 and row == 1 and col == 3 then
        table.insert(pattern, row, {x = (col * spacing) + x_count, y = (row * spacing) + y_count, w = width, h = height, c = color, id = loc})
        -- pattern[col][row] = {x = (col * spacing) + x_count, y = (row * spacing) + y_count, w = width, h = height, c = color, id = loc}
      end
    end
  end
  return pattern
end

function drawPattern()
  for i,v in ipairs(pattern) do
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", v.x, v.y, v.w, v.h)
    love.graphics.setColor(v.c)
    love.graphics.rectangle("fill", v.x+1, v.y+1, v.w-2, v.h-2)
  end
end

function drawSquare(p, i, n, s, cX, cY)
  v = p[i]
  -- love.graphics.setColor(1, 1, 1)
  -- love.graphics.rectangle("line", n.x, n.y, v.w, v.h)
  love.graphics.setColor(v.c)
  --love.graphics.rectangle("fill", n.x*scale+cX, n.y*scale+cY, v.w/2, v.h/2)
  love.graphics.circle('fill', n.x*scale+cX, n.y*scale+cY, (v.w/2)/2, 100)
  love.graphics.reset()
end
