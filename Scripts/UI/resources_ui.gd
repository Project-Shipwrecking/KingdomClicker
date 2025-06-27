class_name ResourceUI extends Control

@onready var map_man = $"../../../MapManager" as MapManager
var tile_man : TileManager
var resources : Array[Resources]


func get_tile_manager():
	tile_man = Global.tile_manager
	
