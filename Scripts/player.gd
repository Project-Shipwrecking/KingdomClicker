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
var peace_treaties = []

var map_gen = [[]]
var players = []

func expand():
	var expansion_tiles = []
	for tile in possessed_land:
		var possible_tiles = []
		var contested_tiles = []
		var x = tile[0]
		var y = tile[1]
		if (y + 1 < map_gen[0].size() and map_gen[x][y + 1] == "OPEN"):
			possible_tiles.append(Vector2(x, y + 1))
		if (y - 1 >= 0 and map_gen[x][y - 1] == "OPEN"):
			possible_tiles.append(Vector2(x, y - 1))
		if (x + 1 < map_gen.size() and map_gen[x + 1][y] == "OPEN"):
			possible_tiles.append(Vector2(x + 1, y))
		if (x - 1 >= 0 and map_gen[x - 1][y] == "OPEN"):
			possible_tiles.append(Vector2(x - 1, y))
		if (y + 1 < map_gen[0].size() and map_gen[x][y + 1] == "OCCUPIED"):
			contested_tiles.append(Vector2(x, y + 1))
		if (y - 1 >= 0 and map_gen[x][y - 1] == "OCCUPIED"):
			contested_tiles.append(Vector2(x, y - 1))
		if (x + 1 < map_gen.size() and map_gen[x + 1][y] == "OCCUPIED"):
			contested_tiles.append(Vector2(x + 1, y))
		if (x - 1 >= 0 and map_gen[x - 1][y] == "OCCUPIED"):
			contested_tiles.append(Vector2(x - 1, y))
		var total_list = possible_tiles + contested_tiles
		if total_list.size() == 0:
			continue
		var move_tile = total_list[randi() % total_list.size()]
		if move_tile in contested_tiles:
			for part in players:
				if move_tile in part.possessed_land:
					var soldiers_per_tile_enemy = len(part.entities['SOLDIERS']) / len(part.possessed_land) # update logic later
					var soldiers_per_tile_self = len(entities['SOLDIERS']) / len(possessed_land) # update logic later
					if soldiers_per_tile_self > soldiers_per_tile_enemy:
						expansion_tiles.append(move_tile)
						part.possessed_land.erase(move_tile)
						part.entities['SOLDIERS'] -= soldiers_per_tile_enemy
						entities['SOLDIERS'] -= soldiers_per_tile_enemy
					else:
						part.entities['SOLDIERS'] -= soldiers_per_tile_self
						entities['SOLDIERS'] -= soldiers_per_tile_self
		else:
			expansion_tiles.append(move_tile)
	possessed_land = possessed_land + expansion_tiles

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

var building_list = {
}

func check_requirements(location, resources, building_name):
	pass

func add_building(building_name, location):
	var build = building_list[building_name]
	if check_requirements(location, resources, building_name): # should be check reqs from building class
		buildings[building_name] += 1
		for item in build['requirements']['resources']:
			resources[item] -= build['requirements']['resources']['item']

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
