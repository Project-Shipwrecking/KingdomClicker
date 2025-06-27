## The one and only. Allows player to make inputs
class_name Player extends Entity

@onready var hud = %HUD
@onready var resources_ui = hud.get_node(^"ResourcesUI") as ResourcesUI

func _ready() -> void:
	self.res_changed.connect(_on_res_changed)
	resource_ui_test()
	
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
