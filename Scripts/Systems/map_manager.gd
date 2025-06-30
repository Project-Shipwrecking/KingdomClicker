class_name MapManager extends Node2D

@export_range(1, 10) var sigma : float = 3.5
@export_range(1, 10) var number_of_enemies: int = 3
@onready var map_tile := $MapTile as TileMapLayer
@onready var resource_tile_manager := $ResourceTile as TileManager

@onready var canvas_layer := $CanvasLayer as CanvasLayer
@onready var info_box := $CanvasLayer/InfoBox as Panel
@onready var info_text := info_box.get_node(^"Info") as RichTextLabel

var selection_layer: Selection
var last_hovered_tile = null
var map_generated = false

@onready var biome_man = BiomeManager.new()
@onready var scale_vec : Vector2

func is_map_generated() -> bool:
	return map_generated

func _ready():
	selection_layer = Selection.new()
	selection_layer.name = "SelectionLayer"
	selection_layer.tile_set = resource_tile_manager.tile_set
	add_child(selection_layer)
	Global.selection_layer = selection_layer
	info_box.hide()

func _process(_delta: float):
	if Global.game_state == Global.GAME_STATE.GAME:
		_read_tile_data_and_display()
	else: 
		info_box.hide()

func _read_tile_data_and_display():
	var mouse_hover_tile : Vector2i = resource_tile_manager.local_to_map(get_local_mouse_position())
	
	if not resource_tile_manager.is_in_bounds(mouse_hover_tile):
		info_box.hide()
		return
		
	var tile_data : TileDatum = resource_tile_manager.get_tile_datum(mouse_hover_tile)
	if tile_data == null: 
		info_box.hide()
		return
	info_box.show()
	info_box.set_position(get_viewport().get_mouse_position() + Vector2(20,0), true)
	info_text.clear()
	
	var text_to_display = resource_tile_manager.read_tile_datum(mouse_hover_tile)
	
	info_text.append_text("[color=black]" + text_to_display)
	info_box.size.y = info_text.get_content_height()

func gen_map(width : int, height : int) -> void:
	if map_generated: return
	map_generated = true
	
	var scale_vec = Vector2(width, height)
	var noise = _gen_noise(width, height)
	Global.tile_manager = resource_tile_manager
	Global.map_made.emit(scale_vec)
	await get_tree().process_frame
	
	var land_tiles = []
	for x in range(width):
		for y in range(height):
			var dist = (Vector2(x,y)/scale_vec).distance_to(Vector2(.5,.5))
			var gauss_noise = _gaussian(dist, sigma) * (1 + noise.get_noise_3d(x, y, -100)/4)
			if gauss_noise < 0.4: 
				map_tile.set_cell(Vector2i(x,y), 1, Global.TILE_ID["SEA"])
				continue
			
			land_tiles.append(Vector2i(x, y))
			var biome_noise = noise.get_noise_3d(x, y, 100) 
			var biome_type : BiomeManager.BiomeName
			var biome_atlas : Vector2i
			if biome_noise < -0.3:
				biome_type = BiomeManager.BiomeName.DESERT
				biome_atlas = Global.TILE_ID["DESERT"]
			elif biome_noise < 0.3:
				biome_type = BiomeManager.BiomeName.FOREST
				biome_atlas = Global.TILE_ID["FOREST"]
			else:
				biome_type = BiomeManager.BiomeName.PLAINS
				biome_atlas = Global.TILE_ID["PLAINS"]
			
			map_tile.set_cell(Vector2i(x,y), 1, biome_atlas) 
			
			if randf() < biome_man.biomes[biome_type]["resource_scattering"]: 
				resource_tile_manager.set_cell_resource_and_biome(Vector2i(x,y), biome_type, biome_atlas)
				continue
			var resource_to_spawn = biome_man.spawn_resource_in_biome(biome_type)
			
			if resource_to_spawn:
				var new_res_instance = resource_to_spawn.duplicate()
				resource_tile_manager.set_cell_resource_and_biome(Vector2i(x,y), biome_type, biome_atlas, new_res_instance)
	
	_spawn_entities(land_tiles)

func _spawn_entities(land_tiles: Array):
	if land_tiles.is_empty():
		print("Error: No land tiles available to spawn entities.")
		return
	
	land_tiles.shuffle()
	
	var min_spawn_distance = 15
	var spawn_points = []
	
	var total_entities_to_spawn = 1+ number_of_enemies
	
	for potential_spawn_point in land_tiles:
		if spawn_points.size() == total_entities_to_spawn:
			break
		
		var is_valid = true
		for existing_point in spawn_points:
			if potential_spawn_point.distance_to(existing_point) < min_spawn_distance:
				is_valid = false
				break
		
		if is_valid:
			spawn_points.append(potential_spawn_point)
	
	if spawn_points.size() < total_entities_to_spawn:
		print("Warning: Could not find enough spaced-out spawn points")
	
	if not spawn_points.is_empty():
		var player_spawn = spawn_points.pop_front()
		var player = Player.new()
		player.name = "Player"
		add_child(player)
		player.add_territory([player_spawn])
		Global.players.append(player)
		Global.player_spawned.emit(player_spawn)
	else:
		print("Critical: No valid spawn point found for the player!")
		return
	
	var enemy_color_idx = 0
	for enemy_spawn_point in spawn_points:
		var enemy = Enemy.new()
		enemy.name = "Enemy " + str(enemy_color_idx + 1)
		enemy.territory_color_index = enemy_color_idx
		add_child(enemy)
		enemy.add_territory([enemy_spawn_point])
		Global.players.append(enemy)
		enemy_color_idx += 1

func _gaussian(dist: float, sig: float) -> float:
	return exp(-pow(dist, 2) / (2.0 * pow(sig, 2)))

func _gen_noise(width: float, height: float) -> FastNoiseLite:
	var noise = FastNoiseLite.new()
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.fractal_type = FastNoiseLite.FRACTAL_NONE
	noise.fractal_octaves = 3
	noise.frequency = 0.08
	noise.offset = Vector3(width/2, height/2, 0)
	return noise
