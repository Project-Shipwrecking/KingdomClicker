
## Class that describes and holds data for resources collectable by the player.
class_name Resources extends Resource

@export var name : String
@export var probability : float = 1 
@export var tileset_id : int = 0
@export var atlas_coord : Vector2i 

func _init(given_name:String, given_atlas_coord:Vector2i, given_probability:float=1, given_tileset_id:int = 0) -> void:
	self.name = given_name
	self.atlas_coord = given_atlas_coord
	self.probability = given_probability
	self.tileset_id = given_tileset_id
	

func print_string() -> String:
	return "Resources(name='%s', probability=%.2f, atlas_coord=%s)" % [name, probability, atlas_coord]
