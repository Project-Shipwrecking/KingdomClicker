class_name global
extends Node

@onready var screen_size : Vector2 = get_viewport().get_visible_rect().size
enum TILE_TYPE {
	SEA,
	LAND,
	RESOURCE,
} 

var TILE_ID = {
	"SEA": Vector2i(15,11),
	"DESERT": Vector2i(1,1),
	"FOREST": Vector2i(6,1),
	"PLAINS": Vector2i(6,5),
} # Made to match the MapTile tileset

# Game State
signal game_state_changed(new_val, old_val)
var game_state = 0 :
	set(val):
		if val == game_state: return
		game_state_changed.emit(val, game_state)
		game_state = val

enum GAME_STATE {
	MAIN_MENU,
	GAME,
	PAUSE,
	GAME_OVER
}

var players = []

var map = [[]]
## Signal to tell everything that the map has been generated.
signal map_made(size:Vector2i)
var tile_manager : TileManager

func game_loop():
	pass
