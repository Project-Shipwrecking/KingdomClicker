extends Node2D

@onready var pause_menu := $CanvasLayer/PauseMenu as Control # Adjust type if it has a class_name
@onready var main_menu := $CanvasLayer/MainMenu as Control # Adjust type if it has a class_name


func _ready():
	# res_c = MapResources.new() # Example initialization
	# print(res_c._normalize_probabilities(res_c.taxanomy))
	#await get_tree().process_frame
	#main_menu.show()
	#pause_menu.hide()
	Global.game_state = Global.GAME_STATE.MAIN_MENU

func _unhandled_input(event: InputEvent) -> void:
	match Global.game_state:
		Global.GAME_STATE.GAME:
			if event.is_action_pressed("quit"):
				pause_menu.open() 
				Global.game_state = Global.GAME_STATE.PAUSE
		Global.GAME_STATE.PAUSE:
			if event.is_action_pressed("quit"):
				pause_menu.close() 
				Global.game_state = Global.GAME_STATE.GAME
		Global.GAME_STATE.MAIN_MENU:
			pass
