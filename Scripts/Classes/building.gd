class_name Building
extends Node

var id = -1
var owned_by: Entity
var location: Vector2i
var health: float = 100.0
var max_health: int = 100
var health_regen_rate: float = 0.5
var is_working: bool = true
var type: String:
	set(value):
		type = value
		var data = BuildingTypes.buildings.get(type)
		if data: 
			self.max_health = data.get("hp", 100)
			self.health = self.max_health
			self.rate = data.get("rate", 0.0)
var production_progress: float = 0.0
var rate: float = 0.0
var level: int = 1

func _process_extraction(data, amount):
	var tile_datum = Global.tile_manager.get_tile_datum(location)
	if not tile_datum or not tile_datum.resource_on_tile or not data.has("output"):
		return

	var output_res_name = data["output"].keys()[0]
	
	if tile_datum.resource_on_tile and tile_datum.resource_amount > 0:
		var building_reqs = BuildingTypes.buildings[type]["requirements"]
		var required_res = building_reqs.get("location", {}).get("resource", "")
		if required_res and tile_datum.resource_on_tile.name.to_lower() != required_res.to_lower():
			is_working = false
			return
			
		var amount_to_gain = min(tile_datum.resource_amount, amount)
		
		var inv_res = owned_by._find_res(output_res_name, owned_by.resources)
		if inv_res:
			inv_res.amount += amount_to_gain
		
		tile_datum.resource_amount -= amount_to_gain
		if tile_datum.resource_amount <= 0:
			is_working = false
		
		owned_by.resources = owned_by.resources.duplicate()

func _process_refinement(data, amount):
	var inputs = data["inputs"]
	var outputs = data["output"]
	
	for res_name in inputs:
		var inv_res = owned_by._find_res(res_name, owned_by.resources)
		if not inv_res or inv_res.amount < inputs[res_name] * amount:
			return
	
	for res_name in inputs:
		owned_by._find_res(res_name, owned_by.resources).amount -= inputs[res_name] * amount
	
	for res_name in outputs:
		var list_to_check = owned_by.resources
		var inv_res = owned_by._find_res(res_name, list_to_check)
		if inv_res: 
			inv_res.amount += outputs[res_name] * amount
	
	owned_by.resources = owned_by.resources.duplicate()
	pass

func process_realtime(delta: float):
	if health < max_health:
		health = min(health + health_regen_rate * delta, max_health)
	
	if not is_working: return
	
	var data = BuildingTypes.buildings.get(type)
	if not data or self.rate == 0:
		return
	
	var citizen_bonus = 1.0
	var citizen_troop = owned_by._find_res("citizen", owned_by.troops)
	if is_instance_valid(citizen_troop):
		citizen_bonus += float(citizen_troop.amount) * 0.01
		
	production_progress += self.rate * citizen_bonus * delta
	
	if production_progress >= 1.0:
		var units_to_produce = floor(production_progress)
		var input_type = data["input"]
		
		if typeof(input_type) == TYPE_STRING:
			_process_extraction(data, units_to_produce)
		elif typeof(input_type) == TYPE_DICTIONARY:
			_process_refinement(data, units_to_produce)
		
		production_progress -= units_to_produce

func take_damage(amount: float) -> bool:
	health -= amount
	if health <= 0:
		health = 0
		print("%s at %s destoryed" % [type, location])
		return true
	return false

func can_upgrade() -> bool:
	var data = BuildingTypes.buildings.get(type)
	if not data or not data.has("upgrades"):
		return false
	var next_level_key = "level" + str(level + 1)
	if not data["upgrades"].has(next_level_key):
		return false
		
	var upgrade_data = data["upgrades"][next_level_key]
	for res_name in upgrade_data["cost"]:
		var inv_res = owned_by._find_res(res_name, owned_by.resources)
		if not inv_res or inv_res.amount < upgrade_data["cost"][res_name]:
			return false
	return true

func upgrade():
	if not can_upgrade():
		return
		
	var data = BuildingTypes.buildings.get(type)
	var next_level_key = "level" + str(level + 1)
	var upgrade_data = data["upgrades"][next_level_key]
	
	for res_name in upgrade_data["cost"]:
		owned_by._find_res(res_name, owned_by.resources).amount -= upgrade_data["cost"][res_name]
	
	level += 1
	self.rate = upgrade_data.get("new_rate", self.rate)
	self.max_health = upgrade_data.get("new_hp", self.max_health)
	self.health = self.max_health
	
	owned_by.resources = owned_by.resources.duplicate()
