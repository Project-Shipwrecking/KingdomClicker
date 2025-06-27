class_name ResourceUI extends Control

@onready var map_man = $"../../../MapManager" as MapManager
var tile_man : TileManager
var resources : Array[Resources]

func _ready() -> void:
	Global.map_made.connect(get_tile_manager)

func get_tile_manager(_size, tilemaplayer):
	tile_man = tilemaplayer
	
