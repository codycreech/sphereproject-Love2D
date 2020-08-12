require 'pattern'
require 'grid'
require 'sphere'
require 'simple-slider'
local nuklear = require 'nuklear'
local ui, ui_grid, mousex, mousey, canvas_sphere_x, canvas_sphere_y

function love.load()
  ui = nuklear.newUI()
  ui_grid = nuklear.newUI()
  font1 = love.graphics.newFont('pixelmix.ttf', 14)
  font2 = love.graphics.newFont('pixelmix.ttf', 2)

  mouseIsDown = false
	drawEdges = false
  canvas_sphere_scale = 150
  delta = 0

  nodes = sphere.nodes
	edges = sphere.edges

  loadGrid()

  canvas_grid = love.graphics.newCanvas(800, 725)
  love.graphics.setCanvas(canvas_grid)
    love.graphics.clear()
    love.graphics.setBlendMode("alpha", "premultiplied")
    --love.graphics.setColor(0, 0.5, 0.75)
    drawGrid()

  love.graphics.setCanvas()

  canvas_sphere = love.graphics.newCanvas(500, 500)

  centerX, centerY = canvas_sphere:getDimensions()
	centerX = centerX/2
	centerY = centerY/2

  love.graphics.setCanvas(canvas_sphere)
  love.graphics.clear()
  love.graphics.setBlendMode("alpha", "premultiplied")
	love.graphics.setLineStyle('smooth')

  love.graphics.setCanvas()

  -- items = {}
  -- for x = 1, #nodes, 1 do
  --   table.insert(items, x)
  -- end
  -- items2 = {}
  -- -- for x = 1,12 do
  -- --   table.insert(items2, x)
  -- -- end
  -- for i,v in ipairs(grid) do
  --   for j,v2 in ipairs(v) do
  --     for k,v3 in ipairs(grid_pattern) do
  --       -- print('Grid['..i..','..j..']')
  --       -- print('Pattern['..k..']')
  --       -- love.timer.sleep(1)
  --     end
  --   end
  -- end

  -- local p = grid[4][10]
  -- for i,v in ipairs(p) do
  --   for j,v2 in ipairs(v) do
  --     print(v2)
  --   end
  -- end

  -- combo = {value = 1, items = items}
  -- combo2 = {value = 1, items = items2}
  -- combo3 = {value = 1, items = items3}

  -- for i = 1, #nodes, 1 do
  --   table.insert(nodes[i], {color = {1,1,0}})
  -- end
  red = 128/255
  green = 181/255
  blue = 64/255

  sliderR = newSlider(1200, 40, 90, red, 0, 1, function (v) red=v end, {width=12, orientation='horizontal', track='roundrect', knob='circle'})
  sliderG = newSlider(1200, 60, 90, green, 0, 1, function (v) green=v end, {width=12, orientation='horizontal', track='roundrect', knob='circle'})
  sliderB = newSlider(1200, 80, 90, blue, 0, 1, function (v) blue=v end, {width=12, orientation='horizontal', track='roundrect', knob='circle'})
end

function love.update(dt)
  mousex, mousey = love.mouse.getPosition()
  canvas_sphere_x, canvas_sphere_y = love.graphics.inverseTransformPoint(mousex, mousey)

  sliderR:update()
  sliderG:update()
  sliderB:update()

  -- ui:frameBegin()
  -- if ui:windowBegin('Nodes', 1050, 160, 200, 175, 'border', 'title') then
  --   ui:layoutRow('dynamic', 30, 1)
  --   ui:label('Nodes:')
  --   if ui:combobox(combo, combo.items) then
  --     print(combo.items[combo.value])
  --   end
  --
  --   ui:layoutRow('dynamic', 30, 1)
  --   ui:label('Set Color of Selected Node:')
  --   ui:layoutRow('dynamic', 30, 2)
  --   if ui:button('Set') then
  --     nodes[combo.value].color = {red, green, blue}
  --   end
  -- end
  -- ui:windowEnd()
  -- ui:frameEnd()
  --
  -- ui_grid:frameBegin()
  -- if ui_grid:windowBegin('Grid', 1050, 350, 200, 200, 'border', 'title') then
  --   ui_grid:layoutRow('dynamic', 30, 3)
  --   ui_grid:label('Grid:')
  --   if ui_grid:combobox(combo2, combo2.items) then
  --     print(combo2.items[combo2.value])
  --   end
  -- end
  -- ui_grid:windowEnd()
  -- ui_grid:frameEnd()

  delta = dt

  -- canvas_sphere:renderTo(function()
  love.graphics.setCanvas(canvas_sphere)
    love.graphics.clear()

    -- love.graphics.setColor(nodes[1].color)
    --draw sphere
    nextNode = 14
    grid_row = 1

    for i = 1, #nodes, 1 do
  		node = nodes[i]
      radius = 2
      margin = 5
      if grid_row > 16 then
        grid_row = 1
      end
      -- if i % 2 == 0 then
      --   love.graphics.setColor(1,0,0)
      -- else
      --   love.graphics.setColor(1,1,1)
      -- end
      -- if i == 452 then
      --   love.graphics.setColor(red, green, blue)
      -- end
      local p = grid[1][1]

      if node == nextNode then
        love.graphics.setColor(p.c)
      else
        love.graphics.setColor(nodes[i].color)
      end
      -- love.graphics.setColor(nodes[i].color)
      -- love.graphics.setPointSize(3)
  		love.graphics.points(node.x*canvas_sphere_scale+centerX, node.y*canvas_sphere_scale+centerY)
      love.graphics.circle('fill', node.x*canvas_sphere_scale+centerX, node.y*canvas_sphere_scale+centerY, radius)
      -- love.graphics.print(i, node.x*scale+centerX, node.y*scale+centerY)
      -- love.graphics.reset()
      if mousex >= node.x*canvas_sphere_scale+centerX - (radius+margin) and mousex <= (radius+margin) + node.x*canvas_sphere_scale+centerX and
      mousey >= node.y*canvas_sphere_scale+centerY - (radius+margin) and mousey <= (radius+margin) + node.y*canvas_sphere_scale+centerY then
        love.graphics.setColor(1, 1, 1)
        --love.graphics.draw(love.graphics.newText(font1, i), mousex, mousey)
        love.graphics.print(i, mousex+15, mousey+15)
      end
      -- nextNode = nextNode + 15
      -- grid_row = grid_row + 1
  	end

    -- if drawEdges == true then
    --   love.graphics.setColor(1, 1, 1)
  	-- 	for n = 1, #edges, 1 do
  	-- 		n0 = edges[n][1]
  	-- 		n1 = edges[n][2]
  	-- 		node00 = nodes[n0]
  	-- 		node11 = nodes[n1]
  	-- 		love.graphics.line(node00.x*scale+centerX, node00.y*scale+centerY, node11.x*scale+centerX, node11.y*scale+centerY)
  	-- 		print(n0)
  	-- 	end
  	-- end

    -- love.graphics.setLineWidth(1.75)
    -- love.graphics.setLineStyle('smooth')
    -- love.graphics.line(nodes[463].x*scale+centerX, nodes[463].y*scale+centerY, nodes[477].x*scale+centerX, nodes[477].y*scale+centerY)


    love.graphics.reset()
    --drawPatternToSphere()

  -- end);
  love.graphics.setCanvas()

  if love.mouse.isDown('1') then
		mouseIsDown = true
	else
		mouseIsDown = false
	end

  if love.keyboard.isDown('up') and mousex >= 0 and mousey >= 0 and mousex <= 500 and mousey <= 500 then
		canvas_sphere_scale = canvas_sphere_scale + 1
	end

	if love.keyboard.isDown('down') and mousex >= 0 and mousey >= 0 and mousex <= 500 and mousey <= 500 then
	 	canvas_sphere_scale = canvas_sphere_scale - 1
	end
end

function love.draw()
  love.graphics.scale(0.8, 0.8)
  love.graphics.draw(canvas_grid, 620, 20)
  love.graphics.reset()

  love.graphics.draw(canvas_sphere, 2, 2)

  -- drawSquare(pattern, 1, nodes[451], scale, centerX, centerY)

  ui:draw()
  ui_grid:draw()
  love.graphics.setColor(red, green, blue)
  love.graphics.rectangle('fill', 1150, 95, 100, 50)
  love.graphics.setColor(1, 1, 1)

  love.graphics.setFont(font1)
  love.graphics.print('R', 1130, 32)
  sliderR:draw()
  love.graphics.print('G', 1130, 52)
  sliderG:draw()
  love.graphics.print('B', 1130, 72)
  sliderB:draw()
  love.graphics.reset()

  love.graphics.print("Size of pattern: " .. #grid_pattern*#grid_pattern[1], 10, 700)
  love.graphics.print("Size of grid: " .. #grid*#grid[1], 200, 700)
  love.graphics.print("FPS: " .. love.timer.getFPS(), 350, 700)
  love.graphics.print("Nodes: "..#nodes, 10, 725)
  love.graphics.print("(Rotate sphere with left mouse button)" , 200, 725)
  love.graphics.print("(Zoom in/out with up/down)", 450, 725)
  love.graphics.print('Mouse Coordinates: '..'x='..mousex..' y='..mousey, 650, 725)
  love.graphics.print("dt: " .. delta, 450, 700)
  love.graphics.print('Memory: ' .. math.floor(collectgarbage 'count') ..
  'kb ' .. string.format('%.2f', (math.floor(collectgarbage 'count') * 0.001)) .. 'mb', 650, 700)
end

function love.keypressed(key, scancode, isrepeat)
  ui:keypressed(key, scancode, isrepeat)
  if key == 'escape' then
    love.event.push('quit')
  end
end

function love.keyreleased(key, scancode)
	ui:keyreleased(key, scancode)
end

function love.mousepressed(x, y, button, istouch, presses)
	ui:mousepressed(x, y, button, istouch, presses)
end

function love.mousereleased(x, y, button, istouch, presses)
	ui:mousereleased(x, y, button, istouch, presses)
end

function love.mousemoved(x, y, dx, dy, istouch)
  ui:mousemoved(x, y, dx, dy, istouch)
	if mouseIsDown == true and x >= 0 and y >= 0 and x <= 500 and y <= 500 then
		rotateY3D((x+dx-x) * 0.01)
    rotateX3D((y+dy-y) * 0.01)
    end
end

function love.wheelmoved(x, y)
	ui:wheelmoved(x, y)
end

-- function rotateZ3D(alpha)
-- 	sin = math.sin(alpha)
-- 	cos = math.cos(alpha)
-- 	for a = 1, #nodes, 1 do
-- 		node = nodes[a]
-- 		x = node.x
-- 		y = node.y
-- 		node.x = (x * cos - y * sin)
-- 		node.y = (y * cos + x * sin)
-- 	end
-- end


function rotateY3D(alpha)
	sin = math.sin(alpha)
	cos = math.cos(alpha)
	for a = 1, #nodes, 1 do
		node = nodes[a]
		x = node.x
		z = node.z
		node.x = (x * cos - z * sin)
		node.z = (z * cos + x * sin)
	end
end

function rotateX3D(alpha)
	sin = math.sin(alpha)
	cos = math.cos(alpha)
	for a = 1, #nodes, 1 do
		node = nodes[a]
		y = node.y
		z = node.z
		node.y = (y * cos - z * sin)
		node.z = (z * cos + y * sin)
	end
end
