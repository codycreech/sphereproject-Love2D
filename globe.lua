globe = {}
total = 25
r = 5

function loadGlobe()
  for i = 1, total do
    globe[i] = {}

    lat = map(i, 1, total, 1, math.pi*2)
    for j = 1, total do
      lon = map(j, 1, total, 1, math.pi*math.pi)
      x = r * math.sin(lat) * math.cos(lon)
      y = r * math.sin(lat) * math.sin(lon)
      z = r * math.cos(lat)

      if(i <= total - 10) then
        globe[i][j] = {x, y, z}
      end
    end
  end
end
