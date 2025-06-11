extends Camera2D

@export_range(1,30) var CAMERA_SPEED : int = 10
var drag_start_pos : Vector2



func _process(delta_time : float):
	if Input.is_action_just_pressed("middle_click"):
		drag_start_pos = get_global_mouse_position()
	elif Input.is_action_pressed("middle_click"):
		position = position.lerp(position - (get_global_mouse_position() - drag_start_pos), CAMERA_SPEED*delta_time)
		
