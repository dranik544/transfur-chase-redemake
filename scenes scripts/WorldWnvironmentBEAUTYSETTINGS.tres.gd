extends WorldEnvironment

func _ready() -> void:
	if Global.settings["beauty"]:
		environment.tonemap_mode = Environment.TONE_MAPPER_AGX
		environment.tonemap_exposure = 1.2
		environment.glow_enabled = true
		environment.fog_enabled = true
	else:
		environment.tonemap_mode = Environment.TONE_MAPPER_LINEAR
		environment.tonemap_exposure = 1.0
		environment.glow_enabled = false
		environment.fog_enabled = false
