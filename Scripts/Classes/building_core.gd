class_name BuildingTypes
extends Node

static var buildings = {}

func add_building_data(id, name, description, reqs, input, output, rate, hp, category, upgrades = {}):
	buildings[id] = {
		'name': name,
		'description': description,
		'requirements': reqs,
		'input': input,
		'output': output,
		'rate': rate,
		'hp': hp,
		'category': category,
		'upgrades': upgrades
	}

static func check_requirements(entity: Entity, tile_datum: TileDatum, building_id: String) -> bool:
	var building_data = buildings.get(building_id)
	if not building_data:
		return false
	
	var reqs = building_data['requirements']
	
	if reqs.has('location'):
		var loc_reqs = reqs['location']
		if loc_reqs.has('biome') and BiomeManager.BiomeName.keys()[tile_datum.biome].to_lower() != loc_reqs['biome'].to_lower():
			return false
		if loc_reqs.has("resource"):
			if not tile_datum.resource_on_tile or tile_datum.resource_on_tile.name.to_lower() != loc_reqs['resource'].to_lower():
				return false
	
	if reqs.has('resources'):
		var res_reqs = reqs['resources']
		for item_name in res_reqs:
			var player_res = entity._find_res(item_name, entity.resources)
			if not player_res or player_res.amount < res_reqs[item_name]:
				return false
	
	return true

func _ready():
	add_building_data("lumber_mill", "Lumber Mill", "Gathers wood from adjacent forests.",
		{'location': {'resources': 'tree1'}, 'resources': {'wood': 10}}, 'extract', {'wood': 2}, 0.5, 80, 'production',
		{"level2": {"cost": {"wood": 50, "stone": 25}, "new_rate": 0.7, "new_hp": 120}})
	
	add_building_data("stone_quarry", "Stone Quarry", "Extracts stone from stone deposits.",
		{'location': {'resources': 'stones'}, 'resources': {'wood': 20}}, 'extract', {'stone': 1}, 0.3, 120, "production",
		{"level2": {"cost": {"wood": 50, "stone": 75}, "new_rate": 0.5, "new_hp": 180}})

	add_building_data("iron_mine", "Iron Mine", "Mines iron ore.",
		{'location': {'resources': 'iron_ore'}, 'resources': {'wood':50, 'stone': 25}}, 'extract', {'iron_ore': 1}, 0.2, 150, "production")

	add_building_data("coal_mine", "Coal Mine", "Mines coal.",
		{'location': {'resources': 'coal'}, 'resources': {'wood':50, 'stone': 25}}, 'extract', {'coal': 1}, 0.2, 150, "production")

	add_building_data("farm", "Farm", "Grows berries on plains.",
		{'location': {'biome': 'plains'}, 'resources': {'wood': 30}}, 'extract_from_biome', {'berries': 1}, 0.4, 60, "production")
	
	add_building_data("oil_well", "Oil Well", "Extracts crude oil.",
		{'location': {'resources': 'oil'}, 'resources': {'wood': 100, 'stone': 50}}, 'extract', {'oil': 1}, 0.1, 200, "production")
		
	add_building_data("fishery", "Fishery", "Gathers fish from water tiles.",
		{'location': {'biome': 'water'}, 'resources': {'wood': 40}}, 'extract_from_biome', {'fish': 2}, 0.3, 70, "production")

	add_building_data("smelter", "Smelter", "Refines iron ore and coal into iron ingots.",
		{'resources': {'stone': 100}}, {'iron_ore': 2, 'coal': 1}, {'iron_ingot': 1}, 0.1, 200, "refining")

	add_building_data("blacksmith", "Blacksmith", "Forges iron ingots into swords.",
		{'resources': {'wood': 100, 'stone': 50}}, {'iron_ingot': 1}, {'swords': 1}, 0.05, 250, "refining")
	
	add_building_data("steel_mill", "Steel Mill", "Fuses iron and coal to produce strong steel.",
		{'resources': {'bricks': 100, 'cement': 50}}, {'iron_ingot': 3, 'coal': 2}, {'steel': 1}, 0.05, 400, "refining")
		
	add_building_data("glassworks", "Glassworks", "Superheats sand to create glass.",
		{'resources': {'bricks': 50}}, {'sand': 2, 'coal': 1}, {'glass': 1}, 0.1, 180, "refining")

	add_building_data("barracks", "Barracks", "Trains citizens into soldiers.",
		{'resources': {'wood': 150, 'stone': 100}}, {'swords': 1, 'berries': 5}, {'soldier': 1}, 0.02, 300, "military")

	add_building_data("archery_range", "Archery Range", "Crafts crossbows and trains archers.",
		{'resources': {'wood': 200, 'fabric': 20}}, {'wood': 10, 'iron_ingot': 2}, {'crossbows': 1}, 0.03, 280, "military")
	
	add_building_data("stables", "Stables", "Trains knights, requires steel armor.",
		{'resources': {'wood': 300, 'stone': 200}}, {'steel': 5, 'berries': 10}, {'knight': 1}, 0.01, 500, "military")

	add_building_data("wall", "Wall", "A defensive structure.",
		{'resources': {'stone': 25}}, {}, {}, 0, 750, "defense")
