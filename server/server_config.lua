VitrineRewards = {
    { item = 'rolex',        amount = {min = 1, max = 4}, probability = 0.4},
    { item = 'diamond_ring', amount = {min = 1, max = 4}, probability = 0.3},
    { item = 'goldchain',    amount = {min = 1, max = 4}, probability = 0.2},
    { item = 'tenkgoldchain',amount = {min = 1, max = 4}, probability = 0.1},
}

Locations = {
    {coords = vector3(-627.04, -235.08, 38.22), size = {length = 1.2, width = 1.0, rotation = 36.0}, animLoc = vector4(-626.67, -235.71, 37.05, 48.38)},
    {coords = vector3(-626.00, -234.41, 38.22), size = {length = 1.2, width = 1.0, rotation = 36.0}, animLoc = vector4(-625.57, -235.03, 37.05, 48.38)},
    {coords = vector3(-626.78, -233.39, 38.22), size = {length = 1.2, width = 1.0, rotation = 36.0}, animLoc = vector4(-627.21, -232.74, 37.05, 235.89)},
    {coords = vector3(-627.80, -234.12, 38.22), size = {length = 1.2, width = 1.0, rotation = 36.0}, animLoc = vector4(-628.13, -233.70, 37.05, 235.89)},
    {coords = vector3(-625.52, -238.07, 38.22), size = {length = 1.2, width = 1.0, rotation = 36.0}, animLoc = vector4(-626.09, -237.62, 37.05, 218.31)},
    {coords = vector3(-626.55, -238.82, 38.22), size = {length = 1.2, width = 1.0, rotation = 36.0}, animLoc = vector4(-626.94, -238.26, 37.05, 218.31)},
    {coords = vector3(-624.21, -230.92, 38.22), size = {length = 1.2, width = 1.0, rotation = 36.0}, animLoc = vector4(-625.07, -231.31, 37.05, 321.64)},
    {coords = vector3(-622.89, -232.74, 38.22), size = {length = 1.2, width = 1.0, rotation = 36.0}, animLoc = vector4(-623.51, -233.15, 37.05, 319.16)},
    {coords = vector3(-620.07, -234.68, 38.22), size = {length = 1.2, width = 1.0, rotation = 36.0}, animLoc = vector4(-620.56, -234.03, 37.06, 210.99)},
    {coords = vector3(-618.83, -233.78, 38.22), size = {length = 1.2, width = 1.0, rotation = 36.0}, animLoc = vector4(-619.43, -233.2, 37.06, 222.22),},
    {coords = vector3(-620.30, -232.99, 38.22), size = {length = 1.0, width = 1.0, rotation = 36.0}, animLoc = vector4(-617.86, -230.92, 37.06, 309.74)},
    {coords = vector3(-617.63, -230.58, 38.22), size = {length = 1.2, width = 1.0, rotation = 36.0}, animLoc = vector4(-618.96, -229.88, 37.06, 307.74)},
    {coords = vector3(-618.33, -229.55, 38.22), size = {length = 1.2, width = 1.0, rotation = 36.0}, animLoc = vector4(-618.87, -229.78, 37.06, 306.22)},
    {coords = vector3(-620.01, -230.68, 38.22), size = {length = 1.2, width = 1.0, rotation = 36.0}, animLoc = vector4(-619.37, -230.01, 37.06, 141.76)},
    {coords = vector3(-621.24, -228.80, 38.22), size = {length = 1.2, width = 1.0, rotation = 36.0}, animLoc = vector4(-620.44, -228.26, 37.06, 131.12)},
    {coords = vector3(-619.48, -227.43, 38.22), size = {length = 1.2, width = 1.0, rotation = 36.0}, animLoc = vector4(-620.14, -227.97, 37.06, 321.91)},
    {coords = vector3(-620.16, -226.48, 38.22), size = {length = 1.2, width = 1.0, rotation = 36.0}, animLoc = vector4(-620.89, -226.74, 37.06, 302.62)},
    {coords = vector3(-624.10, -226.84, 38.22), size = {length = 1.0, width = 1.0, rotation = 36.0}, animLoc = vector4(-623.73, -227.56, 37.06, 35.34)},
    {coords = vector3(-625.15, -227.54, 38.22), size = {length = 1.0, width = 1.0, rotation = 36.0}, animLoc = vector4(-624.6, -228.23, 37.06, 41.24)},
    {coords = vector3(-623.81, -228.39, 38.22), size = {length = 0.9, width = 1.0, rotation = 36.0}, animLoc = vector4(-624.18, -227.8, 37.06, 226.72)}
}

for i = 1, #Locations do
    Locations[i].isOpened = false
    Locations[i].isBusy = false
end
GlobalState.QBJewelery = Locations
