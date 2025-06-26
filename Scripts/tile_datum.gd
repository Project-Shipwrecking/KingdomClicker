## Used to hold extra information, like biome. 
## [br]
## The goal is to make adding metadata easier with this class
class_name TileDatum extends Node


var tile_type : int = 0 # Default to SEA, uses Global.TILE_TYPE enum
var tile_contents = null
var biome : BiomeManager.BiomeName
## Whatever the tile actually holds
var holding : Object
## Assigning Parent-Child Relationship with Building and Map Tile
#var building : Building = null
## Stores who owns the land
var territory_owned_by : Entity = null

#func assign_random_resource():
	#var resource_types = [Global.RESOURCE_WOOD, Global.RESOURCE_STONE, Global.RESOURCE_FOOD]
	#var random_index = randi() % resource_types.size()
	#holding = resource_types[random_index]
