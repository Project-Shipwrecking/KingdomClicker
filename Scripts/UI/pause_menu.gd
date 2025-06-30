class_name PauseMenu extends Control


@export var fade_in_duration := 0.3
@export var fade_out_duration := 0.2

@onready var center_cont := $ColorRect/CenterContainer as CenterContainer
@onready var resume_button := center_cont.get_node(^"VBoxContainer/ResumeButton") as Button


func _ready() -> void:
	hide()
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED


func close() -> void:
	var tween := create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
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
	await tween.finished
	hide()
	get_tree().paused = false


func open() -> void:
	show()
	resume_button.grab_focus()
	get_tree().paused = true

	modulate.a = 0.0
	center_cont.anchor_bottom = 0.5
	var tween := create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(
		self,
		^"modulate:a",
		1.0,
		fade_in_duration
	).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(
		center_cont,
		^"anchor_bottom",
		1.0,
		fade_out_duration
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)


func _on_resume_button_pressed() -> void:
	Global.game_state = Global.GAME_STATE.GAME
	close()

func _on_quit_button_pressed() -> void:
	if visible:
		get_tree().quit()
