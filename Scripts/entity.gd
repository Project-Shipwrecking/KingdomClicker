## Class to hold all of the expansion and inventory logic
## [br]
class_name Entity extends Node2D

var resources : Array[Resources] = []

var entities : Array[Troop] = []

var buildings : Array[Building]= []

var possessed_land = [] # add coords here

# states of action
var expanding = false
var build_order = []
var peace_treaties = []

var map_gen = [[]]
var players = []
var tile_man : TileManager

## Function with expansion logic every turn
#func expand():
	#var expansion_tiles = []
	#for tile in possessed_land:
		#var possible_tiles = []
		#var contested_tiles = []
		#var x = tile[0]
		#var y = tile[1]
		#if (y + 1 < map_gen[0].size() and map_gen[x][y + 1] == "OPEN"):
			#possible_tiles.append(Vector2(x, y + 1))
		#if (y - 1 >= 0 and map_gen[x][y - 1] == "OPEN"):
			#possible_tiles.append(Vector2(x, y - 1))
		#if (x + 1 < map_gen.size() and map_gen[x + 1][y] == "OPEN"):
			#possible_tiles.append(Vector2(x + 1, y))
		#if (x - 1 >= 0 and map_gen[x - 1][y] == "OPEN"):
			#possible_tiles.append(Vector2(x - 1, y))
		#if (y + 1 < map_gen[0].size() and map_gen[x][y + 1] == "OCCUPIED"):
			#contested_tiles.append(Vector2(x, y + 1))
		#if (y - 1 >= 0 and map_gen[x][y - 1] == "OCCUPIED"):
			#contested_tiles.append(Vector2(x, y - 1))
		#if (x + 1 < map_gen.size() and map_gen[x + 1][y] == "OCCUPIED"):
			#contested_tiles.append(Vector2(x + 1, y))
		#if (x - 1 >= 0 and map_gen[x - 1][y] == "OCCUPIED"):
			#contested_tiles.append(Vector2(x - 1, y))
		#var total_list = possible_tiles + contested_tiles
		#if total_list.size() == 0:
			#continue
		#var move_tile = total_list[randi() % total_list.size()]
		#if move_tile in contested_tiles:
			#for part in players:
				#if move_tile in part.possessed_land:
					#var soldiers_per_tile_enemy = len(part.entities['SOLDIERS']) / len(part.possessed_land) # update logic later
					#var soldiers_per_tile_self = len(entities['SOLDIERS']) / len(possessed_land) # update logic later
					#if soldiers_per_tile_self > soldiers_per_tile_enemy:
						#expansion_tiles.append(move_tile)
						#part.possessed_land.erase(move_tile)
						#part.entities['SOLDIERS'] -= soldiers_per_tile_enemy
						#entities['SOLDIERS'] -= soldiers_per_tile_enemy
					#else:
						#part.entities['SOLDIERS'] -= soldiers_per_tile_self
						#entities['SOLDIERS'] -= soldiers_per_tile_self
		#else:
			#expansion_tiles.append(move_tile)
			#
	#for coordinate in expansion_tiles:
		#var tile = tile_man.get_tile_datum(coordinate)
		#tile.territory_owned_by = self
	#possessed_land = possessed_land + expansion_tiles

func _ready() -> void:
	_resource_fill()
	Global.map_made.connect(update_internal_map)
	
func update_internal_map(_size, tilemap:TileMapLayer):
	#map_gen = tilemap.
	#TODO Mapgen needs work...
	tile_man = tilemap as TileManager

## Init function for filling inventory
func _resource_fill():
	for item in GlobalResources.RESOURCES:
		var res = Resources.new(item)
		resources.append(res)
		#resources[item] = 0
	for item in GlobalResources.ENTITIES:
		resources.append(Troop.new())
		#entities[item] = 0

## Returns the item in the inventory with the same name as passed through.
func _find_res(name, list:Array):
	for obj in list:
		if obj.name == name:
			return obj


## Assumes all Item and Resources are all in the inventory with amount 0
## [br]
## Also assumes items and resources are differentiated by their 'name' variable
## [br]
## Can be positive or negative
func increment_resource_entity(resource_entity : Array[Resources], amounts:Array[int]):
	for idx in range(min(resource_entity.size(), amounts.size())):
		var res = resource_entity[idx]
		var amount_of_res = amounts[idx]

		if res is Troop:
			var ent = _find_res(res.name, entities)
			ent.amount = max(ent.amount + amount_of_res, 0)
		elif res is Resources:
			var ent = _find_res(res.name, resources)
			ent.amount = max(ent.amount + amount_of_res, 0)
		
#
#func remove_resource_entity(resource_entity, amounts):
	#for idx in range(min(resource_entity.size(), amounts.size())):
		#var item = resource_entity[idx]
		#var amount = amounts[idx]
#
		#if item in resources:
			#resources[item] = max(resources[item] - amount, 0)
		#elif item in entities:
			#entities[item] = max(entities[item] - amount, 0)
		#else:
			#if typeof(item) == TYPE_INT:
				#resources[item] = amount
			#else:
				#entities[item] = amount
## Assumes all Item and Resources are all in the inventory with amount 0
## [br]
## Also assumes items and resources are differentiated by their 'name' variable
## [br]
## Amounts can only be positive, or it will clamp to 0
func set_resource_entity(resource_entity : Array[Resources], amounts:Array[int]):
	for idx in range(min(resource_entity.size(), amounts.size())):
		var res = resource_entity[idx]
		var amount_of_res = amounts[idx]

		if res is Troop:
			var ent = _find_res(res.name, entities)
			ent.amount = max(amount_of_res, 0)
		elif res is Resources:
			var ent = _find_res(res.name, resources)
			ent.amount = max(amount_of_res, 0)

var building_list = {
}

## Works differently from troop or resources, there will be multiple of the same if you build it twice or more.
func add_building(building_name, location: Vector2):
	# Retrieve tile_datum and read it
	var tile = tile_man.get_tile_datum(location)
	if tile.holding is Building: return # If already holding building, fail
	
	var build = Building.new()
	build.owned_by = self
	build.type = building_name
	build.name = building_name
	build.location = location
	
	if build.check_requirements(location, resources, building_name): 
		# should be check reqs from building class
		
		# Add the building to the TileDatum on the location
		tile.holding = build
		
		# Takes resources required to build
		for item in build['requirements']['resources']:
			resources[item] -= build['requirements']['resources']['item']

## Returns true if a building was destroyed and false if it doesn't.
func destroy_building() -> bool:
	pass

func add_territory(tiles):
	for tile in tiles:
		if tile not in possessed_land:
			possessed_land.append(tile)
			map_man
			

func remove_territory(tiles):
	for tile in possessed_land:
		possessed_land.erase(tile)

func check_death():
	return (len(possessed_land) <= 0)
