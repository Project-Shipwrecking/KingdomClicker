## The one and only. Allows player to make inputs
class_name Player extends Entity

@onready var resources_ui = $"../CanvasLayer/ResourcesUI" as ResourcesUI

func _ready() -> void:
	self.res_changed.connect(_on_res_changed)

func _on_res_changed(res_list):
	resources_ui.update_resources_ui(res_list)
