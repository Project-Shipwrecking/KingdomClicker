class_name BiomeManager
extends Node

enum BiomeName {
	DESERT,
	FOREST,
	PLAINS
}

var biomes = [
	[
		preload("res://Assets/Resources/sand.tres"),
	],
	#{
		#'sand': 0.6,
		#'salt': 0.1,
		#'cactus': 0.1,
	#},
	[
		preload("res://Assets/Resources/wood.tres"),
		preload("res://Assets/Resources/stone.tres"),
	],
	#{
		#'tree': 0.6,
		#'berries': 0.1,
		#'stones': 0.1
	#},
	[
		preload("res://Assets/Resources/wheat.tres"),
	]
	#{
		#'grass': 0.6,
		#'flowers': 0.1,
		#'wheat': 0.1
	#}
]

func get_resources_for_biome(biome_index: int) -> Array:
	var typed_resources: Array[Resources]= []
	for res in biomes[biome_index]:
		typed_resources.append(res)
		print_debug(res is Resources)
		print(res, " is Resources: ", res is Resources)
		print(res, " is Resource: ", res is Resource)
		print(res.get_script())
	print_debug(typed_resources)
	return typed_resources

func spawn_resource_in_biome(biome_index: int) -> Resources:
	return pick_weighted_random_resource(\
			get_resources_for_biome(biome_index))
	
func pick_weighted_random_resource(resources: Array) -> Resources:
	var total_weight = 0.0
	for res in resources:
		print_debug(res is Resources)
		total_weight += res.probability

	var rnd = randf() * total_weight
	var cumulative = 0.0

	for res in resources:
		cumulative += res.probability
		if rnd <= cumulative:
			return res

	return null # fallback (shouldn't happen if weights are valid)
