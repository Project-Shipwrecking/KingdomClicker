class_name Selection extends TileMapLayer

var SELECT_ICON = {
	"white":Vector2i(5,4),
	"blue":Vector2i(8,0),
	"reds": [
		Vector2i(9, 1),
		Vector2i(10, 1),
		Vector2i(11, 1),
		Vector2i(12, 1)
	]
}

var current_selection_start: Vector2i = Vector2i(-1, -1)
var current_selection_end: Vector2i = Vector2i(-1, -1)

func _process(_delta):
	clear()
	
	if Global.game_state != Global.GAME_STATE.GAME:
		return
	
	for entity in get_tree().get_nodes_in_group("entities"):
		if not is_instance_valid(entity) or entity.possessed_land.is_empty():
			continue
		
		var color_icon = _get_entity_color(entity)
		if color_icon == Vector2i(-1, -1): continue

		var all_land_tiles = {}
		for tile in entity.possessed_land:
			all_land_tiles[tile] = true

		for tile_coord in entity.possessed_land:
			var is_border = false
			for neighbor in _get_cardinal_neighbors(tile_coord):
				if not all_land_tiles.has(neighbor):
					is_border = true
					break
			if is_border:
				set_cell(tile_coord, 0, color_icon)
	
	if current_selection_start != Vector2i(-1, -1):
		if current_selection_end == Vector2i(-1, -1):
			set_cell(current_selection_start, 0, SELECT_ICON["white"])
		else:
			var top_left = Vector2i(min(current_selection_start.x, current_selection_end.x), min(current_selection_start.y, current_selection_end.y))
			var bottom_right = Vector2i(max(current_selection_start.x, current_selection_end.x), max(current_selection_start.y, current_selection_end.y))
			for x in range(top_left.x, bottom_right.x + 1):
				for y in range(top_left.y, bottom_right.y + 1):
					set_cell(Vector2i(x, y), 0, SELECT_ICON["white"])

func select(coords: Vector2i, coords2: Vector2i = Vector2i(-1,-1)):
	current_selection_start = coords
	current_selection_end = coords2

func _get_cardinal_neighbors(coords: Vector2i) -> Array[Vector2i]:
	return [
		coords + Vector2i.UP,
		coords + Vector2i.DOWN,
		coords + Vector2i.LEFT,
		coords + Vector2i.RIGHT
	]

func _get_entity_color(entity: Entity) -> Vector2i:
	if entity is Player:
		return SELECT_ICON["blue"]
	elif entity is Enemy:
		if entity.territory_color_index >= 0 and entity.territory_color_index < SELECT_ICON["reds"].size():
			return SELECT_ICON["reds"][entity.territory_color_index]
		else:
			return SELECT_ICON["reds"][0]
	return Vector2i(-1, -1)
