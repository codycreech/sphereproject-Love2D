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

  delta = dt

  love.graphics.setCanvas(canvas_sphere)
    love.graphics.clear()

    nextNode = 14
    grid_row = 1

    for i = 1, #nodes, 1 do
  		node = nodes[i]
      radius = 2
      margin = 5
      if grid_row > 16 then
        grid_row = 1
      end

      local p = grid[1][1]

      if node == nextNode then
        love.graphics.setColor(p.c)
      else
        love.graphics.setColor(nodes[i].color)
      end

  		love.graphics.points(node.x*canvas_sphere_scale+centerX, node.y*canvas_sphere_scale+centerY)
      love.graphics.circle('fill', node.x*canvas_sphere_scale+centerX, node.y*canvas_sphere_scale+centerY, radius)

      if mousex >= node.x*canvas_sphere_scale+centerX - (radius+margin) and mousex <= (radius+margin) + node.x*canvas_sphere_scale+centerX and
      mousey >= node.y*canvas_sphere_scale+centerY - (radius+margin) and mousey <= (radius+margin) + node.y*canvas_sphere_scale+centerY then
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(i, mousex+15, mousey+15)
      end

  	end

    love.graphics.reset()

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

function map(n, start1, stop1, start2, stop2, withinBounds)
  local value = ((n - start1) / (stop1 - start1)) * (stop2 - start2) * start2
  if not withinBounds then
    return value
  end
  if start2 < stop2 then
    return math.max(math.min(value, stop2), start2)
  else
    return math.max(math.min(value, start2), stop2)
  end
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
