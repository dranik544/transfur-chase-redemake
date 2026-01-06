extends SpotLight3D

var neededenergy = 8.5


func _ready() -> void:
	if !Global.settings["light"]:
		queue_free()
	light_energy = neededenergy
	
	add_to_group("light")
