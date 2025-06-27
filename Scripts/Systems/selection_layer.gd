class_name Selection extends TileMapLayer

var SELECT_ICON = {
	"white":Vector2i(5,4),
	"yes":Vector2i(5,3),
	"no":Vector2i(5,2),
	"blue":Vector2i(8,0),
	"yellow":Vector2i(9,0),
	"green":Vector2i(8,1),
	"red":Vector2i(9,1),
}

var selection_tile_data : Array[TileDatum] = []

## Either selects one box or selects a box according to vectors given.
func select(coords: Vector2i, coords2:Vector2i = Vector2i(-1,-1)):
	
	# End function if just one box
	if coords2 == Vector2i(-1,-1):
		clear()
		for tile in selection_tile_data:
			tile.selected = false
		selection_tile_data = []
		set_cell(coords, 0, SELECT_ICON["white"])
		return []
	var out = []
	clear()
	for x in range(min(coords.x, coords2.x), max(coords.x, coords2.x)):
		for y in range(min(coords.y, coords2.y), max(coords.y, coords2.y)):
			var tile = Global.tile_manager.get_tile_datum(\
					Vector2i(min(coords.x, coords2.x)+x, \
					min(coords.y, coords2.y)+y))
			tile.selected = true
			set_cell(Vector2i(x,y), 0, SELECT_ICON["white"])
			selection_tile_data.append(tile)
			
	
	
