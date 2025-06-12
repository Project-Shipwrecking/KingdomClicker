class_name Resources
extends Resource

@export var name : String
@export var texture : Texture2D
@export var probability : float = 1 :
	get:
		return probability
@export var atlas_coord : Vector2i :
	get:
		return atlas_coord

func print_string() -> String:
	return "Resources(name='%s', probability=%.2f, atlas_coord=%s)" % [name, probability, atlas_coord]
