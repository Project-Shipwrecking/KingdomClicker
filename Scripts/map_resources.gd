class_name map_resources
extends Node

# General Biomes: Desert, Forest, Plains
var taxanomy = {
	'desert': {
		'sand': 0.6,
		'salt': 0.1,
		'cactus': 0.1,
	},
	'forest': {
		'tree': 0.6,
		'berries': 0.1,
		'stones': 0.1
	},
	'plains': {
		'grass': 0.6,
		'flowers': 0.1,
		'wheat': 0.1
	}
}

func _normalize_probabilities(resource_taxonomy: Dictionary):
	for biome in resource_taxonomy:
		var values = resource_taxonomy[biome]
		var total = 0.0
		for value in values.values():
			total += value
		for item in values:
			values[item] = values[item] / total
	return resource_taxonomy
