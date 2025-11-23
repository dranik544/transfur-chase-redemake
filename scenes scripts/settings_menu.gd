extends Node2D


func _ready() -> void:
	$scc/vboxc/winterevent.disabled = not Global.iswinter

func updatesettings():
	Global.settings["soundvolume"] = $scc/vboxc/soundslider.value
	Global.settings["musicvolume"] = $scc/vboxc/soundandmusic.value
	Global.settings["effects"] = $scc/vboxc/effects.toggle_mode
	Global.settings["cabels"] = $scc/vboxc/cabels.toggle_mode
	Global.settings["winterevent"] = $scc/vboxc/winterevent.toggle_mode
	SavingManager.save("settings", Global.settings)
