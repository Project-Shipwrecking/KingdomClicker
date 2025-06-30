class_name ResourcesUI extends Control

@onready var container := $NinePatchRect/MarginContainer/HBoxContainer as HBoxContainer
@onready var res_icon_scene = preload("res://Scenes/resource_container.tscn")
var resources : Array[Resources] = []
var resource_containers: Array[ResourceContainer] = []

func _ready():
	# Pre-populate the containers array for easier access
	for i in range(container.get_child_count()):
		var child = container.get_child(i)
		if child is ResourceContainer:
			resource_containers.append(child)

func update_resource_ui(resource_list: Array[Resources]):
	self.resources = resource_list
	# Iterate up to the minimum of available UI slots and resources to display
	var max_items = min(resource_containers.size(), resources.size())
	for i in range(max_items):
		var resource_cont = resource_containers[i]
		var res = resources[i]
		if is_instance_valid(res):
			resource_cont.set_texture(res.texture)
			resource_cont.set_text(str(res.amount))
