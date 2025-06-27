## The one and only. Allows player to make inputs
class_name Player extends Entity

@onready var hud = %HUD
@onready var resources_ui = hud.get_node(^"ResourcesUI") as ResourcesUI
@onready var selection_layer := $SelectionLayer as TileMapLayer

func _ready() -> void:
	self.res_changed.connect(_on_res_changed)
	resource_ui_test()
	
func _process(delta:float):
	if Global.game_state == Global.GAME_STATE.GAME:
		update_selection()

## Only to test if resources displayed
func resource_ui_test():
	for i in range(8):
		var biome_man = BiomeManager.new()
		var res = biome_man.spawn_resource_in_biome(1)
		res.amount = randi_range(0, 1)
		resources.append(res)
		resources = resources.duplicate()

func _on_res_changed(res_list):
	resources_ui.update_resources_ui(res_list)

var start_select_pos : Vector2i = Vector2i(-1,-1)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		start_select_pos = selection_layer.local_to_map(get_local_mouse_position())
	elif event.is_action_released("left_click"):
		start_select_pos = Vector2i(-1,-1)

func update_selection():
	var mouse = get_local_mouse_position()
	mouse = selection_layer.local_to_map(mouse)
	if Global.tile_manager.is_in_bounds(mouse): 
		var tiles = selection_layer.select(mouse, start_select_pos)
