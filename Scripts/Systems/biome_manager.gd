class_name BiomeManager extends Node

enum BiomeName {
	DESERT,
	FOREST,
	PLAINS
}

## Biomes index, where resource_scattering is from [0,1]: 
## [br]
## the higher this number is, the less resources there are.
var biomes : Array = [
	{
		'resource_scattering': .7,
		'cactus': {
			'probability': 0.1,
			'tilesheet_id': 1,
			'atlas_coord': Vector2i(4, 2),
			'yields': 'wood' # Example: Cacti could yield wood
		}
	},
	{
		'resource_scattering': .1,
		'tree1': {
			'probability': 0.2,
			'tilesheet_id': 1,
			'atlas_coord': Vector2i(9, 2),
			'yields': 'wood' # <-- MODIFIED
		},
		'tree2': {
			'probability': 0.2,
			'tilesheet_id': 1,
			'atlas_coord': Vector2i(9, 3),
			'yields': 'wood' # <-- MODIFIED
		},
		'tree3': {
			'probability': 0.3,
			'tilesheet_id': 1,
			'atlas_coord': Vector2i(9, 7),
			'yields': 'wood' # <-- MODIFIED
		},
		'stones': {
			'probability': 0.2,
			'tilesheet_id': 1,
			'atlas_coord': Vector2i(8, 2),
			'yields': 'stone' # <-- MODIFIED
		}
	},
	{
		'resource_scattering': .6,
		'grass': {
			'probability': 0.6,
			'tilesheet_id': 1,
			'atlas_coord': Vector2i(8, 3),
			'yields': 'berries' # Example: Grass could yield berries
		}
	}
];

func get_resources_for_biome(biome_index: int) -> Array:
	var typed_resources: Array[Resources]= []
	for res_name in biomes[biome_index].keys():
		if res_name == "resource_scattering": continue
		var res_data = biomes[biome_index][res_name]
		var resToPush = Resources.new(-1, res_name, res_data.atlas_coord, res_data.probability, res_data.tilesheet_id, res_data.get("yields", res_name))
		typed_resources.append(resToPush)
		
	return typed_resources


## Returns random resource based on the biome
func spawn_resource_in_biome(biome_index: int) -> Resources:
	return pick_weighted_random_resource(\
			get_resources_for_biome(biome_index))

## Uses probability to calculate random resource
func pick_weighted_random_resource(resources: Array) -> Resources:
	var total_weight = 0.0
	for res in resources:
		# print_debug(res is Resources)
		total_weight += res.probability

	var rnd = randf() * total_weight
	var cumulative = 0.0

	for res in resources:
		cumulative += res.probability
		if rnd <= cumulative:
			return res

	return null # fallback (shouldn't happen if weights are valid)
