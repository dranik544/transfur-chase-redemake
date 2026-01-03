extends Control


func _ready() -> void:
	$btnexit.pressed.connect(btnexitpressed)
	
	$scc/vboxc/winterevent.disabled = true
	$scc/vboxc/winterevent.button_pressed = true
	
	$scc/vboxc/cabels.button_pressed = Global.settings["cabels"]
	$scc/vboxc/effects.button_pressed = Global.settings["effects"]
	$scc/vboxc/soundslider.value = Global.settings["soundvolume"]
	$scc/vboxc/musicslider.value = Global.settings["musicvolume"]
	$scc/vboxc/winterevent.button_pressed = Global.settings["winterevent"]
	$scc/vboxc/windowmode.selected = Global.settings["windowmode"]
	$scc/vboxc/tubes.button_pressed = Global.settings["tubes"]
	$scc/vboxc/beauty.button_pressed = Global.settings["beauty"]
	$scc/vboxc/cammode.button_pressed = Global.settings["cammode"]
	$scc/vboxc/shakescreen.button_pressed = Global.settings["shakescreen"]
	$scc/vboxc/light.button_pressed = Global.settings["light"]
	$scc/vboxc/betterai.button_pressed = Global.settings["betterai"]
	$scc/vboxc/sizemode.selected = Global.settings["sizemode"]

func updatesettings():
	Global.settings["soundvolume"] = $scc/vboxc/soundslider.value
	Global.settings["musicvolume"] = $scc/vboxc/musicslider.value
	Global.settings["effects"] = $scc/vboxc/effects.button_pressed
	Global.settings["cabels"] = $scc/vboxc/cabels.button_pressed
	Global.settings["winterevent"] = $scc/vboxc/winterevent.button_pressed
	Global.settings["windowmode"] = $scc/vboxc/windowmode.selected
	Global.settings["tubes"] = $scc/vboxc/tubes.button_pressed
	Global.settings["beauty"] = $scc/vboxc/beauty.button_pressed
	Global.settings["cammode"] = $scc/vboxc/cammode.button_pressed
	Global.settings["shakescreen"] = $scc/vboxc/shakescreen.button_pressed
	Global.settings["light"] = $scc/vboxc/light.button_pressed
	Global.settings["betterai"] = $scc/vboxc/betterai.button_pressed
	Global.settings["sizemode"] = $scc/vboxc/sizemode.selected
	
	
	Global.updatesoundandmusic.emit()
	Global.updatewindowmode()
	Global.updatesizemode()
	
	SavingManager.save("settings", Global.settings)

func btnexitpressed():
	updatesettings()
