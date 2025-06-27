## Class to hold all of the expansion and inventory logic
## [br]
class_name Entity extends Node2D

signal res_changed(res)

var resources : Array[Resources] = [] :
	set(value):
		resources = value
		if self is Player:
			self.res_changed.emit(value)

var troops : Array[Troop] = []

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
	var expansion_targets: Dictionary = {}

	var border_tiles: Dictionary = {}
	for tile_coord in possessed_land:
		var surrounding = tile_man.get_surrounding_cells(tile_coord)
		for surr_coord in surrounding:
			border_tiles[surr_coord] = true

	for border_coord in border_tiles.keys():
		if border_coord in possessed_land:
			continue
		var tile_data = tile_man.get_tile_datum(border_coord)
		expansion_targets[border_coord] = tile_data.territory_owned_by

	var new_territory_this_turn: Array[Vector2i] = []

	for target_coord in expansion_targets.keys():
		var defender = expansion_targets[target_coord]

		if defender == null:
			new_territory_this_turn.append(target_coord)
		else:
			var attacker_power = 0
			for troop in self.troops:
				attacker_power += troop.amount

			var defender_power = 0
			for troop in defender.troops:
				defender_power += troop.amount

			var attacker_force_projection = float(attacker_power) / max(1, self.possessed_land.size())
			var defender_force_projection = float(defender_power) / max(1, defender.possessed_land.size())

			if attacker_force_projection > defender_force_projection:
				new_territory_this_turn.append(target_coord)

	if not new_territory_this_turn.is_empty():
		self.add_territory(new_territory_this_turn)

func _ready() -> void:
	_resource_fill()
	update_internal_map()
	
func update_internal_map():
	tile_man = Global.tile_manager

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
			var ent = _find_res(res.name, troops)
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
			var ent = _find_res(res.name, troops)
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
