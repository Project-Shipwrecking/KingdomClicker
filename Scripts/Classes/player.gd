class_name Player extends Entity

@onready var hud: HUD = get_node("HUD")

var expand_cooldown: float = 2.0
var time_since_expand: float = 0.0

func _ready() -> void:
	super()
	self.res_changed.connect(on_res_or_troop_changed)
	
func _process(delta:float):
	if Global.game_state == Global.GAME_STATE.GAME:
		update_selection()
	
	process_entity(delta)
	
	time_since_expand += delta
	
	if is_expanding and time_since_expand >= expand_cooldown:
		expand()
		time_since_expand = 0.0

func on_res_or_troop_changed(_res_list):
	if is_instance_valid(hud):
		var resources_ui = hud.get_node_or_null("ResourcesUI")
		if is_instance_valid(resources_ui):
			resources_ui.update_resource_ui(self.resources)

var start_select_pos: Vector2i = Vector2i(-1, -1)

func _unhandled_input(event: InputEvent) -> void:
	if not Global.is_ready:
		return

	if Global.game_state != Global.GAME_STATE.GAME:
		return
	
	if not is_instance_valid(Global.selection_layer): return
	var mouse_pos = Global.selection_layer.local_to_map(get_local_mouse_position())
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			start_select_pos = mouse_pos
		else:
			var end_select_pos = mouse_pos
			var tile_datum = Global.tile_manager.get_tile_datum(end_select_pos)
			
			if start_select_pos == end_select_pos and is_instance_valid(tile_datum):
				if tile_datum.territory_owned_by == self:
					if tile_datum.resource_on_tile and tile_datum.resource_amount > 0 and not tile_datum.building_on_tile:
						var res_on_tile = tile_datum.resource_on_tile
						var inv_res = _find_res(res_on_tile.name, resources)
						if inv_res:
							inv_res.amount += 1
							tile_datum.resource_amount -= 1
							self.resources = self.resources.duplicate()
					elif tile_datum.building_on_tile:
						Global.selected_building = tile_datum.building_on_tile
					else:
						Global.selected_building = null
				else:
					Global.selected_building = null

			start_select_pos = Vector2i(-1,-1)
	
	if Input.is_key_pressed(KEY_E):
		is_expanding = not is_expanding
		print("Expansion toggled " + ("ON" if is_expanding else "OFF"))
	
	if Input.is_key_pressed(KEY_1): add_building("lumber_mill", mouse_pos)
	if Input.is_key_pressed(KEY_2): add_building("stone_quarry", mouse_pos)
	if Input.is_key_pressed(KEY_3): add_building("iron_mine", mouse_pos)
	if Input.is_key_pressed(KEY_4): add_building("farm", mouse_pos)
	if Input.is_key_pressed(KEY_5): add_building("smelter", mouse_pos)
	if Input.is_key_pressed(KEY_6): add_building("barracks", mouse_pos)
	if Input.is_key_pressed(KEY_7): add_building("wall", mouse_pos)

func update_selection():
	var mouse = get_local_mouse_position()
	var mouse_tile = Global.selection_layer.local_to_map(mouse)
	if Global.tile_manager.is_in_bounds(mouse_tile):
		if start_select_pos == Vector2i(-1, -1):
			Global.selection_layer.select(mouse_tile)
		else:
			Global.selection_layer.select(start_select_pos, mouse_tile)
