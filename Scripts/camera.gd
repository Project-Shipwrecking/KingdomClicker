extends Camera2D

@export_range(1,30) var CAMERA_SPEED : int = 10
@export_range(1,2) var CAMERA_ZOOM_MULTI : float = 1.1
var drag_start_pos : Vector2



func _process(delta_time : float):
	if Input.is_action_just_pressed("middle_click"):
		drag_start_pos = get_global_mouse_position()
	elif Input.is_action_pressed("middle_click"):
		position = position.lerp(position - (get_global_mouse_position() - drag_start_pos), CAMERA_SPEED*delta_time)
	elif Input.is_action_just_pressed("scroll_up"):
		zoom *= CAMERA_ZOOM_MULTI
	elif Input.is_action_just_pressed("scroll_down"):
		zoom /= CAMERA_ZOOM_MULTI
		
