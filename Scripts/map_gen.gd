extends Node2D

var map : Array[Array] = []

func _ready():
	gen_map(50,50)
	#map_visualize()
	pass

func _draw():
	map_visualize()

func gen_map(width : int, height : int) -> void:
	for x in range(width):
		map.append([])
		for y in range(height):
			var tile_type = Global.TILE_TYPE.LAND
			if x == 0 or x == width - 1 or y == 0 or y == height - 1:
				tile_type = Global.TILE_TYPE.SEA
			elif randf() < 0.1:
				tile_type = Global.TILE_TYPE.RESOURCE
			map[x].append(tile_type)
	
func map_visualize() -> void:
	for x in range(len(map)):
		for y in range(len(map[x])):
			var tile_type = map[x][y]
			var tile_color = Color(0, 0, 1)  # Default to sea color
			if tile_type == Global.TILE_TYPE.LAND:
				tile_color = Color(0, 1, 0)  # Green for land
			elif tile_type == Global.TILE_TYPE.RESOURCE:
				tile_color = Color(1, 1, 0)  # Yellow for resource
			
			draw_rect(Rect2(x*5, y*5, 5, 5), tile_color, true)
			
			# var rect = RectangleShape2D.new()
			# rect.extents = Vector2(16, 16)
			# var collision_shape = CollisionShape2D.new()
			# collision_shape.shape = rect
			
			# var sprite = Sprite2D.new()
			# sprite.texture = preload("res://Assets/icon.svg")  # Replace with your texture path
			# sprite.position = Vector2(x * 16, y * 16)
			# sprite.modulate = tile_color
			
			# add_child(sprite)
			# add_child(collision_shape)
