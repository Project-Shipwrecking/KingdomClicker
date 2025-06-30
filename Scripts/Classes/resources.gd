class_name Resources extends Resource

@export var name : String
@export var probability : float = 1 
@export var tileset_id : int = 0
@export var atlas_coord : Vector2i 
var amount : int = -1
var texture : Texture2D :
	get:
		var source = Global.tile_manager.tile_set.get_source(1)
		source = source as TileSetAtlasSource
		var region = source.get_tile_texture_region(atlas_coord)
		var image = source.texture.get_image()
		image = image.get_region(region)
		var texture_final = ImageTexture.create_from_image(image)
		return texture_final
var type_id : int = -1

func _init(given_type_id:int = -1, given_name:String = "", given_atlas_coord:Vector2i = Vector2i(-1, -1), given_probability:float=1, given_tileset_id:int = 0) -> void:
	self.name = given_name
	self.type_id = given_type_id
	self.atlas_coord = given_atlas_coord
	self.probability = given_probability
	self.tileset_id = given_tileset_id

func _to_string() -> String:
	return "%s" % name

func print_string() -> String:
	return "Resources(name='%s', probability=%.2f, atlas_coord=%s)" % [name, probability, atlas_coord]
