class_name Entity extends Node2D

signal res_changed(res)

var territory_color_index: int = -1

var resources: Array[Resources] = []:
	set(value):
		resources = value
		if self is Player:
			self.res_changed.emit(value)

var troops: Array[Troop] = []:
	set(value):
		troops = value
		if self is Player:
			self.res_changed.emit(value)
			
var possessed_land: Array[Vector2i] = []
var is_expanding: bool = false
var buildings: Array[Building] = []

var tile_man: TileManager

func _ready():
	_resource_fill()
	update_internal_map()
	add_to_group("entities")

func _get_expansion_targets() -> Dictionary:
	var expansion_targets: Dictionary = {}
	var border_tiles: Dictionary = {}
	for tile_coord in possessed_land:
		var surrounding = tile_man.get_neighboring_cells(tile_coord)
		for surr_coord in surrounding:
			border_tiles[surr_coord] = true
	
	for border_coord in border_tiles.keys():
		if border_coord in possessed_land:
			continue
		var tile_data = tile_man.get_tile_datum(border_coord)
		if tile_data:
			expansion_targets[border_coord] = tile_data.territory_owned_by
	return expansion_targets

func _calculate_power() -> float:
	var power = 0.0
	for troop_instance in self.troops:
		var troop_data = GlobalResources.TROOPS.get(troop_instance.name.to_lower())
		if troop_data:
			power += troop_instance.amount * troop_data.get("power", 1.0)
	return power / max(1.0, float(self.possessed_land.size()))

func _has_building_of_category(category: String) -> bool:
	for b in buildings:
		if BuildingTypes.buildings[b.type]["category"] == category:
			return true
	return false

func _find_res(name: String, list: Array) -> Resource:
	for obj in list:
		if obj.name.to_lower() == name.to_lower():
			return obj
	return null

func _resource_fill():
	for res_name in GlobalResources.RESOURCES.keys():
		var res = Resources.new()
		res.name = res_name
		res.amount = 100 if self is Player else 25
		resources.append(res)
	
	for troop_name in GlobalResources.TROOPS.keys():
		var troop = Troop.new()
		troop.name = troop_name
		if troop_name == "citizen":
			troop.amount = 10 if self is Player else 15
		else:
			troop.amount = 0
		troops.append(troop)
	
	self.resources = self.resources.duplicate()
	self.troops = self.troops.duplicate()

func update_internal_map():
	tile_man = Global.tile_manager

func add_territory(tiles: Array[Vector2i]):
	for tile: Vector2i in tiles:
		if tile not in possessed_land:
			possessed_land.append(tile)
			var tile_datum = tile_man.get_tile_datum(tile)
			var prev_owner = tile_datum.territory_owned_by
			if is_instance_valid(prev_owner):
				var tile_to_remove_arr: Array[Vector2i] = []
				tile_to_remove_arr.append(tile)
				prev_owner.remove_territory(tile_to_remove_arr)
			tile_datum.territory_owned_by = self

func remove_territory(tiles:Array[Vector2i]):
	var tiles_to_remove = tiles.duplicate()
	for tile in tiles_to_remove:
		if tile in possessed_land:
			possessed_land.erase(tile)
			var tile_datum = tile_man.get_tile_datum(tile)
			if tile_datum:
				if tile_datum.building_on_tile and tile_datum.building_on_tile.owned_by == self:
					destroy_building(tile)
				tile_datum.territory_owned_by = null
	
	if possessed_land.is_empty() and is_inside_tree():
		print("%s has been defeated!" % self.name)
		queue_free()

func process_buildings(delta:float):
	for building in buildings:
		building.process_realtime(delta)

func process_entity(delta: float):
	process_buildings(delta)

func expand():
	var expansion_targets = _get_expansion_targets()
	var target_coords = expansion_targets.keys()
	target_coords.shuffle()
	
	for target_coord in target_coords:
		if randf() < 0.5:
			continue
		
		var defender = expansion_targets[target_coord]
		var attacker_power = _calculate_power()
		
		if not is_instance_valid(defender):
			add_territory([target_coord])
		else:
			var defender_power = defender._calculate_power()
			var tile_datum = tile_man.get_tile_datum(target_coord)
			
			if tile_datum.building_on_tile and tile_datum.building_on_tile.owned_by == defender:
				defender_power += tile_datum.building_on_tile.health * 10
			
			if attacker_power > defender_power:
				add_territory([target_coord])
			else:
				if tile_datum.building_on_tile and tile_datum.building_on_tile.owned_by == defender:
					var building = tile_datum.building_on_tile
					var damage = attacker_power / 5.0
					if building.take_damage(damage):
						defender.destroy_building(target_coord)

func add_building(building_name: String, location: Vector2i):
	var tile_datum = tile_man.get_tile_datum(location)
	if tile_datum.building_on_tile:
		return
	
	if BuildingTypes.check_requirements(self, tile_datum, building_name):
		var build = Building.new()
		build.owned_by = self
		build.type = building_name
		build.name = BuildingTypes.buildings[building_name]["name"]
		build.location = location
		
		tile_datum.building_on_tile = build
		buildings.append(build)
		
		var reqs = BuildingTypes.buildings[building_name]["requirements"]["resources"]
		for item_name in reqs:
			_find_res(item_name, resources).amount -= reqs[item_name]
		
		self.resources = self.resources.duplicate()

func destroy_building(location: Vector2i):
	var building_to_remove = null
	for b in buildings:
		if b.location == location:
			building_to_remove = b
			break
	
	if building_to_remove:
		buildings.erase(building_to_remove)
		var tile_datum = tile_man.get_tile_datum(location)
		if tile_datum:
			tile_datum.building_on_tile = null
		print("%s's %s at %s was removed." % [name, building_to_remove.name, location])

func _ai_try_build(building_id: String) -> bool:
	for tile_coord in possessed_land:
		var tile_datum = tile_man.get_tile_datum(tile_coord)
		if not tile_datum.building_on_tile and BuildingTypes.check_requirements(self, tile_datum, building_id):
			add_building(building_id, tile_coord)
			return true
	return false

func _ai_process_build_logic():
	if not _has_building_of_category("production"):
		if _ai_try_build("lumber_mill"): return
		if _ai_try_build("stone_quarry"): return
	if not _has_building_of_category("refining"):
		if _ai_try_build("smelter"): return
		if _ai_try_build("blacksmith"): return
	if not _has_building_of_category("military"):
		if _ai_try_build("barracks"): return
