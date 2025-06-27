extends Camera2D

@export_range(1,30) var CAMERA_MOVE_SPEED : int = 10
@export_range(1,2,0.05) var CAMERA_ZOOM_MULTI : float = 1.1
var drag_start_pos : Vector2

func _process(delta_time : float):
	match Global.game_state:
		
		Global.GAME_STATE.GAME:
			if Input.is_action_just_pressed("middle_click") or Input.is_action_just_pressed("right_click"):
				drag_start_pos = get_global_mouse_position()
			elif Input.is_action_pressed("middle_click") or Input.is_action_pressed("right_click"):
				position = position.lerp(position - (get_global_mouse_position() - drag_start_pos), CAMERA_MOVE_SPEED*delta_time)
			elif Input.is_action_just_pressed("scroll_down"):
				_zoom_update(1 / CAMERA_ZOOM_MULTI)
			elif Input.is_action_just_pressed("scroll_up"):
				_zoom_update(CAMERA_ZOOM_MULTI)

func _zoom_update(mult: float) -> void:
	var zoom_index = zoom.x
	zoom_index *= mult
	zoom_index = clamp(zoom_index, 0.2, 5)
	zoom = Vector2(zoom_index, zoom_index)
	
func _ready() -> void:
	Global.map_made.connect(center_on_map)

func center_on_map(size:Vector2i):
	var center = Global.tile_manager.map_to_local(size)/2
	position = center
