extends Panel

@onready var info_text: RichTextLabel = $Info

func update_info() -> void:
	var mouse_tile = Global.tile_manager.local_to_map(get_local_mouse_position())
	
	if not Global.tile_manager.is_in_bounds(mouse_tile) or get_node("/root/Main/MapManager/FogManager").fog_data[mouse_tile.x][mouse_tile.y] == FogManager.FogState.HIDDEN:
		hide()
		return
		
	show()
	global_position = get_viewport().get_mouse_position() + Vector2(20, 20)
	info_text.clear()
	info_text.append_text("[color=black]" + Global.tile_manager.read_tile_datum(mouse_tile))
	size.y = info_text.get_content_height() + 10
