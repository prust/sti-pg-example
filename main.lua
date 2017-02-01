local sti = require("sti")
local gamera = require("gamera")
--love.window.setFullscreen(true)

-- create a new orthogonal map that is 64x64 tiles, each tile is 32x32 pixels
local map = {
  orientation = "orthogonal",
  width = 64,
  height = 64,
  tilewidth = 32,
  tileheight = 32,
  tilesets = {},
  layers = {}
}

-- create a tileset from an image (Liberated Pixel Cup terrain_atlas.png from opengameart.org)
local tileset = {
  name = "terrain_atlas",
  firstgid = 1,
  tilewidth = 32,
  tileheight = 32,
  spacing = 0,
  margin = 0,
  image = "assets/terrain_atlas.png",
  imagewidth = 1024,
  imageheight = 1024,
  tileoffset = {x = 0, y = 0},
  tilecount = 1024,
  tiles = {}
}
table.insert(map.tilesets, tileset)

-- create a layer of the map, with the same height/width as the map
local layer = {
  type = "tilelayer",
  name = "",
  x = 0,
  y = 0,
  width = 64,
  height = 64,
  visible = true,
  opacity = 1,
  offsetx = 0,
  offsety = 0,
  properties = {},
  encoding = "lua",
  data = {}
}
table.insert(map.layers, layer)

-- populate the layer with empty tiles
function populateLayer(layer)
  for i=1, layer.width * layer.height do
    table.insert(layer.data, 0)
  end
end

-- helper function to set a tile in the layer based on x,y coordinates
function setTile(layer, x, y, tile_id)
  layer.data[x + y * layer.width] = tile_id
end

-- helper function to get the ID of a tile from the tileset using x,y coordinates
function getTileID(tileset, x, y)
  local width = tileset.imagewidth / tileset.tilewidth
  return x + y * width
end

local layer = map.layers[1]
populateLayer(layer)

setTile(layer, 1, 1, getTileID(tileset, 31, 0))
setTile(layer, 2, 1, getTileID(tileset, 32, 0))
setTile(layer, 1, 2, getTileID(tileset, 31, 1))
setTile(layer, 2, 2, getTileID(tileset, 32, 1))
setTile(layer, 1, 3, getTileID(tileset, 31, 2))
setTile(layer, 2, 3, getTileID(tileset, 32, 2))
setTile(layer, 1, 4, getTileID(tileset, 31, 3))
setTile(layer, 2, 4, getTileID(tileset, 32, 3))

local tileMap = sti(map)
local w, h = tileMap.tilewidth * tileMap.width, tileMap.tileheight * tileMap.height
local camera = gamera.new(0, 0, w, h)

function love.draw()
  local dt = love.timer.getDelta()
  camera:draw(function(l, t, w, h)
    tileMap:update(dt)
    tileMap:setDrawRange(-l, -t, w, h)
    tileMap:draw()
  end)
end