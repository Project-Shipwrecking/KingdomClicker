## Class to hold all of the expansion and inventory logic
## [br]
class_name Entity extends Node2D

var resources : Array[Resources] = []

var entities : Array[Troop] = []

var buildings : Array[Building]= []

## List of coordinates that are territory of this entity in Vector2i
var possessed_land : Array[Vector2i] = [] # add coords here

# states of action
var expanding = false
var build_order = []
var peace_treaties = []

var players = []
var tile_man : TileManager

## Function with expansion logic every turn
func expand():
	var map_gen = tile_man.tile_data
	var expansion_tiles = []
	for tile in possessed_land:
		
		var possible_tiles = []
		var contested_tiles = []
		var x = tile.x
		var y = tile.y
		var surrounding_tiles = tile_man.get_surrounding_cells(tile)
		for surr_tile in surrounding_tiles:
			var data = tile_man.get_tile_datum(surr_tile)
			if data.territory_owned_by == null:
				possible_tiles.append(data)
			elif data.territory_owned_by == self:
				pass
			else:
				contested_tiles.append(data)
		
		var total_list = possible_tiles + contested_tiles
		if total_list.size() == 0:
			continue
		# Expansion is randomized
		var move_tile = total_list[randi() % total_list.size()]
		
		# Combat system
		#TODO give player chance to skip soldier
		#if move_tile in contested_tiles:
			#for part in players:
				#if move_tile in part.possessed_land:
					## Assuming troops are spread evenly
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
			
	for coordinate in expansion_tiles:
		var tile = tile_man.get_tile_datum(coordinate)
		tile.territory_owned_by = self
	possessed_land = possessed_land + expansion_tiles


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
		# Initializes resource with 'type_id' of 'item'
		var res = Resources.new(item)
		resources.append(res)
		#resources[item] = 0
	for item in GlobalResources.TROOPS:
		resources.append(Troop.new(item))
		#entities[item] = 0

## Returns the item in the inventory with the same name as passed through.
func _find_res(name, list:Array) -> Object:
	for obj in list:
		if obj.name == name:
			return obj
	return null
	#list.get_typed_class_name().new()
	# Just realized that i need to access the id somehow using the name...

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
	return false

func add_territory(tiles:Array[Vector2i]):
	for tile:Vector2i in tiles:
		if tile not in possessed_land:
			possessed_land.append(tile)
			var tile_datum = tile_man.get_tile_datum(tile)
			# if tile is owned, remove it from the other entity's possessed land
			var prev_owner = tile_datum.territory_owned_by
			if prev_owner != null:
				prev_owner.remove_territory([tile])
			tile_datum.territory_owned_by = self

func remove_territory(tiles:Array[Vector2i]):
	for tile in possessed_land:
		possessed_land.erase(tile)
		var tile_datum = tile_man.get_tile_datum(tile)
		tile_datum.territory_owned_by = null

func check_death():
	return (len(possessed_land) <= 0)
