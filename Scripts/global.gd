extends Node

@onready var screen_size : Vector2 = get_viewport().get_visible_rect().size
enum TILE_TYPE {
	SEA,
	LAND,
	RESOURCE,
} 
var TILE_ID = {
	"SEA": Vector2i(4,1),
	"LAND": Vector2i(6,1),
	"RESOURCE": Vector2i(8,2),
} # Made to match the MapTile tileset

var game_state = 0

enum GAME_STATE {
	MAIN_MENU,
	GAME,
	PAUSE,
	GAME_OVER
}

func game_loop():
	pass
