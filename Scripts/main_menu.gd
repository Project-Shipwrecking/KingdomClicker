class_name MainMenu extends Control


@export var fade_out_duration := 0.2

@onready var center_cont := $ColorRect/CenterContainer as CenterContainer
@onready var start := center_cont.get_node(^"VBoxContainer/StartButton") as Button


func _ready() -> void:
	show()
	#start.grab_focus()


func close() -> void:
	var tween := create_tween()
	get_tree().paused = false
	tween.tween_property(
		self,
		^"modulate:a",
		0.0,
		fade_out_duration
	).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(
		center_cont,
		^"anchor_bottom",
		0.5,
		fade_out_duration
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_callback(hide)


func _on_start_button_pressed() -> void:
	Global.game_state = Global.GAME_STATE.GAME
	close()


func _on_quit_button_pressed() -> void:
	if visible:
		get_tree().quit()
