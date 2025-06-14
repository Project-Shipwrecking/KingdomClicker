extends Node2D

@export_range(1, 10) var sigma : float = 3.5 # smaller sigma means bigger island
@export var map_tile : TileMapLayer
@export var resource_tile : TileMapLayer
var map : Array[Array] = []

func _ready():
	gen_map(50,50)
	#TODO Have the main scene initialize this.


func gen_map(width : int, height : int) -> void:
	var scale_vec = Vector2(width, height)
	var noise = _gen_noise(width, height)
	for x in range(width):
		map.append([])
		for y in range(height):
			var tile_id: Vector2i = Global.TILE_ID["SEA"]
			var dist = (Vector2(x,y)/scale_vec).distance_to(Vector2(.5,.5))
			if _gaussian(dist, sigma) * (1 + noise.get_noise_2d(x, y)/4) > 0.4:
				#TODO Scale sigma and noise according to scale
				tile_id = Global.TILE_ID["LAND"]
				if randf() > .3:
					resource_tile.set_cell(Vector2i(x-int(width/2.),y-int(height/2.)), 0, Global.TILE_ID["RESOURCE"])
					# resource_tile above map_tile visually
					
			map_tile.set_cell(Vector2i(x-int(width/2.), y-int(height/2.)), 0, tile_id)

func _gaussian(dist: float, sig: float) -> float:
	return exp(-pow(dist, 2) / 2 * pow(sig, 2))
	
func _gen_noise(width: float, height: float) -> FastNoiseLite:
	var noise = FastNoiseLite.new()
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.fractal_type = FastNoiseLite.FRACTAL_NONE
	noise.fractal_octaves = 3
	noise.frequency = 0.08
	noise.offset = Vector3(width/2, height/2, 0)
	#noise.fractal_gain
	#noise.fractal_lacunarity
	return noise
