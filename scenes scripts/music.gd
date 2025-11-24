extends AudioStreamPlayer


func _ready() -> void:
	Global.updatesoundandmusic.connect(update)
	update()

func update():
	volume_db = Global.settings["musicvolume"] / 10
