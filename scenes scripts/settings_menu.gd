extends Control


func _ready() -> void:
	$btnexit.pressed.connect(btnexitpressed)
	$scc/vboxc/countenemy.value_changed.connect(countenemieschanged)
	$scc/vboxc/holdtimemobile.value_changed.connect(holdtimemobilechanged)
	
	$scc/vboxc/holdtimemobiletext.visible = Global.ismobile
	$scc/vboxc/holdtimemobile.visible = Global.ismobile
	
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
	$scc/vboxc/camsens.value = Global.settings["camsens"]
	$scc/vboxc/forcemobile.button_pressed = Global.settings["forcemobile"]
	$scc/vboxc/countenemy.value = Global.settings["enemycount"]
	$scc/vboxc/countenemytext.text = tr("SETTINGS_ENEMY_COUNT").format({"count": int($scc/vboxc/countenemy.value)})
	$scc/vboxc/holdtimemobile.value = Global.settings["holdtimemobile"]
	$scc/vboxc/holdtimemobiletext.text = tr("SETTINGS_MOBILE_HOLDTIME_CAM").format({"count": float($scc/vboxc/holdtimemobile.value)})
	$scc/vboxc/crtshader.button_pressed = Global.settings["crtshader"]
	$scc/vboxc/displayhints.button_pressed = Global.settings["displayhints"]
	$scc/vboxc/pixelizescreen.button_pressed = Global.settings["pixelizescreen"]

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
	Global.settings["camsens"] = $scc/vboxc/camsens.value
	Global.settings["forcemobile"] = $scc/vboxc/forcemobile.button_pressed
	Global.settings["enemycount"] = $scc/vboxc/countenemy.value
	Global.settings["holdtimemobile"] = $scc/vboxc/holdtimemobile.value
	Global.settings["crtshader"] = $scc/vboxc/crtshader.button_pressed
	Global.settings["displayhints"] = $scc/vboxc/displayhints.button_pressed
	Global.settings["pixelizescreen"] = $scc/vboxc/pixelizescreen.button_pressed
	
	Global.updatesoundandmusic.emit()
	Global.updatewindowmode()
	Global.updatesizemode()
	ProjectSettings.save()
	
	SavingManager.save("settings", Global.settings)

func countenemieschanged(value: float):
	$scc/vboxc/countenemytext.text = tr("SETTINGS_ENEMY_COUNT").format({"count": int(value)})
func holdtimemobilechanged(value: float):
	$scc/vboxc/holdtimemobiletext.text = tr("SETTINGS_MOBILE_HOLDTIME_CAM").format({"count": float(value)})

func btnexitpressed():
	updatesettings()
