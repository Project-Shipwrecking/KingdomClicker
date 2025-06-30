class_name Selection extends TileMapLayer

# Atlas coordinate for the white selection box tile
var WHITE_SELECTION_ICON = Vector2i(5, 4)

var current_selection_start: Vector2i = Vector2i(-1, -1)
var current_selection_end: Vector2i = Vector2i(-1, -1)

func _ready():
	# Make the layer transparent so the selection box doesn't have a background
	self.modulate = Color(1, 1, 1, 0.5)

func _process(_delta):
	clear()

	if Global.game_state != Global.GAME_STATE.GAME:
		return

	# Only draw the player's selection box. No more territory fills.
	if current_selection_start != Vector2i(-1, -1):
		if current_selection_end == Vector2i(-1, -1):
			set_cell(current_selection_start, 0, WHITE_SELECTION_ICON)
		else:
			var top_left = Vector2i(min(current_selection_start.x, current_selection_end.x), min(current_selection_start.y, current_selection_end.y))
			var bottom_right = Vector2i(max(current_selection_start.x, current_selection_end.x), max(current_selection_start.y, current_selection_end.y))
			for x in range(top_left.x, bottom_right.x + 1):
				for y in range(top_left.y, bottom_right.y + 1):
					set_cell(Vector2i(x, y), 0, WHITE_SELECTION_ICON)

func select(coords: Vector2i, coords2: Vector2i = Vector2i(-1,-1)):
	current_selection_start = coords
	current_selection_end = coords2
