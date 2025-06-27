
## Class that describes and holds data for resources collectable by the player.
class_name Resources extends Resource

@export var name : String
@export var probability : float = 1 
@export var tileset_id : int = 0
@export var atlas_coord : Vector2i 
var type_id : int = -1

func _init(given_type_id:int, given_name:String = "", given_atlas_coord:Vector2i = Vector2i(-1, -1), given_probability:float=1, given_tileset_id:int = 0) -> void:
	self.name = given_name
	self.type_id = given_type_id
	self.atlas_coord = given_atlas_coord
	self.probability = given_probability
	self.tileset_id = given_tileset_id
	
#func _normalize_probabilities(resource_taxonomy: Dictionary):
	#for biome in resource_taxonomy:
		#var values = resource_taxonomy[biome]
		#var total = 0.0
		#for value in values.values():
			#total += value
		#for item in values:
			#values[item] = values[item] / total
	#return resource_taxonomy

func _to_string() -> String:
	return "%s" % name

func print_string() -> String:
	return "Resources(name='%s', probability=%.2f, atlas_coord=%s)" % [name, probability, atlas_coord]
