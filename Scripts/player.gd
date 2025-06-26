class_name player
extends Node

var resources = {
	
}

var entities = {
	
}

var buildings = {
	
}

var possessed_land = [] # add coords here

# states of action
var expanding = false
var build_order = []


func _resource_fill():
	for item in global_resources.RESOURCES:
		resources[item] = 0
	for item in global_resources.ENTITIES:
		entities[item] = 0

func add_resource_entity(resource_entity, amounts):
	for idx in range(min(resource_entity.size(), amounts.size())):
		var item = resource_entity[idx]
		var amount = amounts[idx]

		if item in resources:
			resources[item] += amount
		elif item in entities:
			entities[item] += amount
		else:
			if typeof(item) == TYPE_INT:
				resources[item] = amount
			else:
				entities[item] = amount

func remove_resource_entity(resource_entity, amounts):
	for idx in range(min(resource_entity.size(), amounts.size())):
		var item = resource_entity[idx]
		var amount = amounts[idx]

		if item in resources:
			resources[item] = max(resources[item] - amount, 0)
		elif item in entities:
			entities[item] = max(entities[item] - amount, 0)
		else:
			if typeof(item) == TYPE_INT:
				resources[item] = amount
			else:
				entities[item] = amount

func set_resource_entity(resource_entity, amounts):
	for idx in range(min(resource_entity.size(), amounts.size())):
		var item = resource_entity[idx]
		
		if item in resources:
			resources[item] = amounts[idx]
		elif item in entities:
			entities[item] = amounts[idx]

func add_building():
	pass

func destroy_building():
	pass

func add_territory(tiles):
	for tile in tiles:
		if tile not in possessed_land:
			possessed_land.append(tile)

func remove_territory(tiles):
	for tile in possessed_land:
		possessed_land.erase(tile)

func check_death():
	return (len(possessed_land) <= 0)
