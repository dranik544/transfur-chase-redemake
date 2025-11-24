extends Node2D


func _ready() -> void:
	$btnexit.pressed.connect(btnexitpressed)
	
	$scc/vboxc/winterevent.disabled = true
	
	$scc/vboxc/cabels.button_pressed = Global.settings["cabels"]
	$scc/vboxc/effects.button_pressed = Global.settings["effects"]
	$scc/vboxc/soundslider.value = Global.settings["soundvolume"]
	$scc/vboxc/musicslider.value = Global.settings["musicvolume"]
	$scc/vboxc/winterevent.button_pressed = Global.settings["winterevent"]
	$scc/vboxc/windowmode.selected = Global.settings["windowmode"]

func updatesettings():
	Global.settings["soundvolume"] = $scc/vboxc/soundslider.value
	Global.settings["musicvolume"] = $scc/vboxc/musicslider.value
	Global.settings["effects"] = $scc/vboxc/effects.button_pressed
	Global.settings["cabels"] = $scc/vboxc/cabels.button_pressed
	Global.settings["winterevent"] = $scc/vboxc/winterevent.button_pressed
	Global.settings["windowmode"] = $scc/vboxc/windowmode.selected
	
	print(Global.settings["windowmode"])
	
	Global.updatesoundandmusic.emit()
	Global.updatewindowmode()
	
	SavingManager.save("settings", Global.settings)

func btnexitpressed():
	updatesettings()
