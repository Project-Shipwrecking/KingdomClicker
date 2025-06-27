class_name HUD extends Control


@export var fade_in_duration := 0.3
@export var fade_out_duration := 0.2

@onready var center_cont := self


func _ready() -> void:
	hide()
	Global.game_state_changed.connect(state_changed)

func state_changed(new:int, old:int):
	if new == Global.GAME_STATE.GAME:
		open()
	else:
		close()

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


func open() -> void:
	show()
	#resume_button.grab_focus()

	modulate.a = 0.0
	center_cont.anchor_bottom = 0.5
	var tween := create_tween()
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
