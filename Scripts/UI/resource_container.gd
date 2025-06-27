class_name ResourceContainer extends VBoxContainer

@onready var texture := $TextureRect as TextureRect
@onready var label := $RichTextLabel as RichTextLabel

func set_texture(image:Texture2D):
	texture.texture = image
func set_text(text:String):
	label.clear()
	label.append_text("[color=black][font_size=12]")
	label.append_text("%s" % text)
