extends Node

func _ready():
	#var res = preload("res://Assets/Resources/sand.tres")
	#print(res)  # Should not be null
	#print(res is Resources)  # Should be `true
	#
	#var biome_man = BiomeManager.new()
	#var resources = biome_man.get_resources_for_biome(1)
	#print_debug(biome_man.pick_weighted_random_resource(resources))
	#print_debug(biome_man.get_resources_for_biome(1))
	pass
	
func get_res() -> Resources:
	var biome_man = BiomeManager.new()
	return biome_man.spawn_resource_in_biome(1)
	
