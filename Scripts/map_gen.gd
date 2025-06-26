extends Node2D

@export_range(1, 10) var sigma : float = 3.5 # smaller sigma means bigger island
@export var map_tile : TileMapLayer
@onready var resource_tile_manager := $ResourceTile as TileManager

# UI Labels
@onready var canvas_layer := $CanvasLayer as CanvasLayer
@onready var info_box := $CanvasLayer/InfoBox as Panel
@onready var info_text := info_box.get_node(^"Info") as RichTextLabel

var last_hovered_tile = null

@onready var biome_man = BiomeManager.new()
@onready var scale_vec : Vector2

# 3 layers: layer 1 is tile layer, 2 is biome, and 3 is resource

var schema_example = {
	'tiles': [[]],
	'biome': [[]],
	'resource': [[]]
}

func _ready():
	# Renders the map
	gen_map(50,50)
	#TODO Have the main scene initialize this.

func _process(_delta: float):
	#_get_biome_on_hover()
	if Global.game_state == Global.GAME_STATE.GAME:
		_read_tile_data_and_display()
	else: 
		info_box.hide()
	pass

func _read_tile_data_and_display():
	var mouse_hover_tile : Vector2i = resource_tile_manager.local_to_map(get_local_mouse_position())
	var tile_data : TileDatum = resource_tile_manager.get_tile_datum(mouse_hover_tile)
	if tile_data == null: 
		info_box.hide()
		return
	info_box.show()
	info_box.set_position(get_viewport().get_mouse_position() + Vector2(20,0), true)
	info_text.clear()
	info_text.append_text("[color=black]" + resource_tile_manager.read_tile_datum(mouse_hover_tile))
	info_box.size.y = info_text.get_content_height()

func gen_map(width : int, height : int) -> void:
#	Unit Vector Stuff (Honestly I still don't understand
	var scale_vec = Vector2(width, height)
#	Gets the noise for map generation
	var noise = _gen_noise(width, height)
#	Looping over a 2-D Array
	#resource_tile_manager.params(scale_vec)
	Global.map_made.emit(scale_vec, map_tile)
	
	var tiles_to_connect = []

	for x in range(width):
		for y in range(height):
			# Gaussian part
			var dist = (Vector2(x,y)/scale_vec).distance_to(Vector2(.5,.5))
			var gauss_noise = _gaussian(dist, sigma) * (1 + noise.get_noise_3d(x, y, -100)/4)
			if gauss_noise < 0.4: 
				map_tile.set_cell(Vector2i(x,y), 1, Global.TILE_ID["SEA"])
				continue # Skips everything else if sea
			
			# Biome layer begins here, once its decided that its land.
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
			
			# Once biome is picked, sets the land tile accordingly.
			map_tile.set_cell(Vector2i(x,y), 1, biome_atlas) 
			
			# Resource layer starts here
			if randf() < biome_man.biomes[biome_type]["resource_scattering"]: 
				resource_tile_manager.set_cell_resource_and_biome(Vector2i(x,y), biome_type, biome_atlas)
				continue # Sets the biome without resources
			var resource_to_spawn = biome_man.spawn_resource_in_biome(biome_type)
			resource_tile_manager.set_cell_resource_and_biome(Vector2i(x,y), biome_type, biome_atlas, resource_to_spawn)
	
	#map_tile.set_cells_terrain_connect(tiles_to_connect, 0, 0, false)
	#RIP Tile edges LOLLLL cri


## 1D Gaussian
func _gaussian(dist: float, sig: float) -> float:
	return exp(-pow(dist, 2) / 2 * pow(sig, 2))

func _gen_noise(width: float, height: float) -> FastNoiseLite:
	var noise = FastNoiseLite.new()
#	Sets the seed as a random int
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.fractal_type = FastNoiseLite.FRACTAL_NONE
	noise.fractal_octaves = 3
	noise.frequency = 0.08
#	Centers the noise at the center of the map
	noise.offset = Vector3(width/2, height/2, 0)
	#noise.fractal_gain
	#noise.fractal_lacunarity
	return noise
