local sti = require("sti")
local gamera = require("gamera")
--love.window.setFullscreen(true)

local map = {
  orientation = "orthogonal",
  width = 64,
  height = 64,
  tilewidth = 32,
  tileheight = 32,
  tilesets = {
    {
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
  },
  layers = {
    {
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
  }
}

-- populate the programmatically created layer with empty tiles
function populateLayer(layer)
  for i=1, layer.width * layer.height do
    table.insert(layer.data, 0)
  end
end

-- set a tile in the layer based on x,y coordinates
function setTile(layer, x, y, tile_id)
  layer.data[x + y * layer.width] = tile_id
end

-- get the ID of a tile from the tileset using x,y coordinates
function getTileID(tileset, x, y)
  local width = tileset.imagewidth / tileset.tilewidth
  return x + y * width
end

local layer = map.layers[1]
local tileset = map.tilesets[1]
populateLayer(layer)

setTile(layer, 3, 3, getTileID(tileset, 31, 0))
setTile(layer, 4, 3, getTileID(tileset, 32, 0))
setTile(layer, 3, 4, getTileID(tileset, 31, 1))
setTile(layer, 4, 4, getTileID(tileset, 32, 1))
setTile(layer, 3, 5, getTileID(tileset, 31, 2))
setTile(layer, 4, 5, getTileID(tileset, 32, 2))
setTile(layer, 3, 6, getTileID(tileset, 31, 3))
setTile(layer, 4, 6, getTileID(tileset, 32, 3))

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