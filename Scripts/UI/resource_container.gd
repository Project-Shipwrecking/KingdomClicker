extends VBoxContainer

@onready var texture := $TextureRect as TextureRect
@onready var label := $RichTextLabel as RichTextLabel

func set_image(image:Texture2D):
	texture.texture = image
func set_text(text:String):
	label.append_text("[color=black]%s" % text)
