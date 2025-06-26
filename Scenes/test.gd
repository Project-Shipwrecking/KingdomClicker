extends Node2D

func _ready():
	var res_c = map_resources.new()
	print(res_c._normalize_probabilities(res_c.taxanomy))
