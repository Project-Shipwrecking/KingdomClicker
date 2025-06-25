class_name MapTile
extends Node

var tile_type : int = 0 # Default to SEA, uses Global.TILE_TYPE enum
var tile_contents = null

# Assigning Parent-Child Relation with Resource and the Map Tile
var resources : map_resources = null

# Assigning Parent-Child Relationship with Building and Map Tile
var building : building = null

func assign_random_resource():
	var resource_types = [Global.RESOURCE_WOOD, Global.RESOURCE_STONE, Global.RESOURCE_FOOD]
	var random_index = randi() % resource_types.size()
	resources = resource_types[random_index]
