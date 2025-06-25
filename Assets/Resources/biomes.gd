class_name BiomeManager
extends Node

enum BiomeName {
	DESERT,
	FOREST,
	PLAINS
}

var biomes = [
	# [
	# 	preload("res://Assets/Resources/sand.tres"),
	# ],
	{
		'sand': {
			'probability': 0.6,
			'atlas_coord': Vector2i(6, 2)
			},
		'salt': {
			'probability': 0.1,
			'atlas_coord': Vector2i(6, 2)
		},
		'cactus': {
			'probability': 0.1,
			'atlas_coord': Vector2i(6, 2)
		}
	},
	{
		'tree': {
			'probability': 0.6,
			'atlas_coord': Vector2i(6, 2)
		},
		'berries': {
			'probability': 0.1,
			'atlas_coord': Vector2i(6, 2)
		},
		'stones': {
			'probability': 0.1,
			'atlas_coord': Vector2i(6, 2)
		}
	},
	{
		'grass': {
			'probability': 0.6,
			'atlas_coord': Vector2i(6, 2)
		},
		'flowers': {
			'probability': 0.1,
			'atlas_coord': Vector2i(6, 2)
		},
		'wheat': {
			'probability': 0.1,
			'atlas_coord': Vector2i(6, 2)
		}
	}
]

func get_resources_for_biome(biome_index: int) -> Array:
	var typed_resources: Array[Resources]= []
	for res_name in biomes[biome_index].keys():
		var res_data = biomes[biome_index][res_name]
		var resToPush = Resources.new()
		resToPush.name = res_name
		resToPush.probability = res_data.probability
		resToPush.atlas_coord = res_data.atlas_coord
		typed_resources.append(resToPush)
		
		#typed_resources.append(res)
		#print_debug(res is Resources)
		#print(res, " is Resources: ", res is Resources)
		#print(res, " is Resource: ", res is Resource)
		#print(res.get_script())
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
