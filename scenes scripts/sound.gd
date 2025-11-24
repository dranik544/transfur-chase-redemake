extends AudioStreamPlayer3D


func _ready() -> void:
	Global.updatesoundandmusic.connect(update)
	update()

func update():
	volume_db = Global.settings["soundvolume"] / 10
