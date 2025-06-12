extends Node

enum TILE_TYPE {
	SEA,
	LAND,
	RESOURCE,
}

@onready var screen_size : Vector2 = get_viewport().get_visible_rect().size
