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

var game_state = 0

enum GAME_STATE {
	MAIN_MENU,
	GAME,
	PAUSE,
	GAME_OVER
}

func game_loop():
	pass
