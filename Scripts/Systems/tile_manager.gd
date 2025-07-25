class_name TileManager 
extends TileMapLayer

@onready var map_tile := $"../MapTile" as TileMapLayer
var tile_data : Array[Array]

func _ready():
	Global.map_made.connect(params)

func is_in_bounds(coords:Vector2i) -> bool:
	if coords.x < 0 or coords.x >= len(tile_data):
		return false
	elif coords.y < 0 or coords.y >= len(tile_data[0]):
		return false
	return true

## Used to init tile_data
func params(vec:Vector2i):
	for x in range(vec.x):
		tile_data.append([])
		for y in range(vec.y):
			tile_data[x].append(null)

## Uses given parameters to add textures to the resource_tile but also add tiledata to an internal 2d array.
func set_cell_resource_and_biome(coords:Vector2i, biome_type:BiomeManager.BiomeName, biome_atlas:Vector2i, res:Resources = null):
	var tile_datum = TileDatum.new()
	tile_datum.biome = biome_type
	if res != null: 
		set_cell(coords, res.tileset_id, res.atlas_coord)
		tile_datum.holding = res
	tile_data[coords.x][coords.y] = tile_datum

## Both erases the cell in the resource_tile and the info in the digitalized tile_data 2d array
func erase_coords(coords:Vector2):
	tile_data[coords.x][coords.y] = null
	erase_cell(coords)

## Returns the TileDatum object placed in the resource_tile at coords and null if there is nothing.
func get_tile_datum(coords:Vector2i) -> TileDatum:
	coords = coords.clamp(Vector2i(0,0), Vector2i(len(tile_data)-1, len(tile_data[0])-1))
	var tile = tile_data[coords.x][coords.y]
	if tile != null:
		return tile_data[coords.x][coords.y]
	return TileDatum.new()

## Spits out a string version of the data in the tile

func read_tile_datum(coords:Vector2i) -> String:
	var tile : TileDatum = get_tile_datum(coords)
	var out = ""
	if tile.biome != null:
		var biome_name = BiomeManager.BiomeName.keys()[tile.biome]
		biome_name = biome_name.to_lower().capitalize()
		out += "Biome: %s\n" % biome_name
	if tile.holding is Resources: 
		var res = tile.holding as Resources
		out += "Resource: %s\n" % res.name
	return out
