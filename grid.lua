grid = {}
margin = 30
letters = {'A','B','C','D','E','F'}

function loadGrid()
  local x = 0
  local y = 0
  for gridCol = 1, 12 do
    grid[gridCol] = {}
    for gridRow = 1, 16 do
      grid_pattern = {}
      -- table.insert(grid, gridRow, {grid_pattern = loadPattern(x + margin, y + margin, gridCol, gridRow)})
      table.insert(grid_pattern, loadPattern(x + margin, y + margin, gridCol, gridRow))
      grid[gridCol][gridRow] = {grid_pattern}

      x = x + 40
    end
    x = 0
    y = y + 60
  end
end

function drawGrid()
  tempX = 40
  tempY = 38
  for x = 1,16 do
    love.graphics.print(x, x * 41, 0)
    for i = 1,4 do
      love.graphics.print(letters[i], tempX, 20)
      tempX = tempX + 10
    end
  end
  for y = 1,11 do
    love.graphics.print(y, 0, y * 61)
    for i = 1,6 do
      love.graphics.print(letters[i], 22, tempY)
      tempY = tempY + 10
    end
  end
  love.graphics.print(letters[1], 22, tempY)
  for i,v in ipairs(grid) do
    for j,v2 in ipairs(v) do
      drawPattern()
    end
  end
end
