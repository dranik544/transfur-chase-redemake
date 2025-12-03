extends SpotLight3D


func _ready() -> void:
	if !Global.settings["light"]:
		queue_free()
	light_energy = 8.5
