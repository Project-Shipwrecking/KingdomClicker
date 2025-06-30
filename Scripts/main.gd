extends Node2D

@onready var pause_menu := $CanvasLayer/PauseMenu as Control
@onready var main_menu := $CanvasLayer/MainMenu as Control
@onready var map_manager := $MapManager as MapManager

func _ready():
	main_menu.show()
	pause_menu.hide()
	Global.game_state_changed.connect(_on_game_state_changed)

func _on_game_state_changed(new_state, _old_state):
	match new_state:
		Global.GAME_STATE.GAME:
			main_menu.close()
			if not map_manager.is_map_generated():
				map_manager.gen_map(100, 100)
		Global.GAME_STATE.PAUSE:
			pause_menu.open()
		Global.GAME_STATE.MAIN_MENU:
			main_menu.open()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("quit"):
		if Global.game_state == Global.GAME_STATE.GAME:
			Global.game_state = Global.GAME_STATE.PAUSE
		elif Global.game_state == Global.GAME_STATE.PAUSE:
			Global.game_state = Global.GAME_STATE.GAME
