class_name ResourcesUI extends Control

@onready var container := $NinePatchRect/MarginContainer/HBoxContainer as HBoxContainer
@onready var res_icon_scene = preload("res://Scenes/resource_container.tscn")
var resources : Array[Resources] = []

## Updates the resources that player has up to 8 slots
func update_resources_ui(resource_list):
	resources = resource_list
	for i in range(len(resources)):
		var resource_cont = container.get_node("ResourceContainer"+str(i+1)) as ResourceContainer
		var res = resources[i]
		resource_cont.set_texture(res.texture)
		resource_cont.set_text(str(res.amount))
