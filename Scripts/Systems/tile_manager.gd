class_name TileManager 
extends TileMapLayer

@onready var map_tile := $"../MapTile" as TileMapLayer
var tile_data: Array[Array]

func _ready():
	Global.map_made.connect(params)

func is_in_bounds(coords: Vector2i) -> bool:
	if coords.x < 0 or coords.x >= tile_data.size():
		return false
	if coords.y < 0 or coords.y >= tile_data[0].size():
		return false
	return true

func get_neighboring_cells(coords: Vector2i) -> Array:
	var neighbors = []
	var directions = [
		Vector2i(0, 1), Vector2i(0, -1), Vector2i(1, 0), Vector2i(-1, 0),
		Vector2i(1, 1), Vector2i(1, -1), Vector2i(-1, 1), Vector2i(-1, -1)
	]
	for dir in directions:
		var neighbor_pos = coords + dir
		if is_in_bounds(neighbor_pos):
			neighbors.append(neighbor_pos)
	return neighbors

func params(vec:Vector2i):
	for x in range(vec.x):
		tile_data.append([])
		for y in range(vec.y):
			tile_data[x].append(TileDatum.new())

func set_cell_resource_and_biome(coords:Vector2i, biome_type:BiomeManager.BiomeName, biome_atlas:Vector2i, res:Resources = null):
	var tile_datum = get_tile_datum(coords)
	tile_datum.biome = biome_type
	
	if res != null:
		set_cell(coords, res.tileset_id, res.atlas_coord)
		tile_datum.resource_on_tile = res
		tile_datum.resource_amount = randi_range(500, 1000)

func get_tile_datum(coords:Vector2i) -> TileDatum:
	if not is_in_bounds(coords):
		return null
	return tile_data[coords.x][coords.y]

func read_tile_datum(coords:Vector2i) -> String:
	var tile: TileDatum = get_tile_datum(coords)
	if not tile: return "Out of Bounds"
	
	var out = ""
	var biome_name = BiomeManager.BiomeName.keys()[tile.biome]
	biome_name = biome_name.to_lower().capitalize()
	out += "Biome: %s\n" % biome_name
	
	if tile.building_on_tile:
		var b = tile.building_on_tile
		out += "Building: %s\n" % b.type
		if is_instance_valid(b.owned_by):
			out += "Owner: %s\n" % b.owned_by.name
		out += "HP: %d / %d\n" % [b.health, b.max_health]
	
	if tile.resource_on_tile:
		var r = tile.resource_on_tile
		out += "Resource: %s\n" % r.name
		out += "Amount: %d\n" % tile.resource_amount
	
	if tile.territory_owned_by:
		out += "Territory of: %s" % tile.territory_owned_by.name
	
	return out
