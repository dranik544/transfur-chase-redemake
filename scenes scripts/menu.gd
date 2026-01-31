extends Node3D

var centercam
var cam
var freecam: bool = false
var sens: float = 0.002
var driftcam: float = 0
var camsize: float = 15.0


func _ready():
	centercam = get_node("center camera")
	cam = centercam.get_node("cam")
	
	sens = Global.settings["camsens"]
	
	#$CanvasLayer/logo.visible = true
	$"CanvasLayer/stats menu".visible = false
	$"CanvasLayer/skins menu".visible = false
	$"CanvasLayer/settings menu".visible = false
	$"CanvasLayer/tutorial menu".visible = false
	
	$CanvasLayer/buttons/start/btnstart.mouse_entered.connect(btnstartmouseentered)
	$CanvasLayer/buttons/start/btnstart.mouse_exited.connect(btnstartmouseexited)
	$CanvasLayer/buttons/exit/btnexit.mouse_entered.connect(btnexitmouseentered)
	$CanvasLayer/buttons/exit/btnexit.mouse_exited.connect(btnexitmouseexited)
	$CanvasLayer/buttons/settings/btnsettings.mouse_entered.connect(btnsettingsmouseentered)
	$CanvasLayer/buttons/settings/btnsettings.mouse_exited.connect(btnsettingsmouseexited)
	$CanvasLayer/buttons/tutorial/btntutorial.mouse_entered.connect(btntutorialmouseentered)
	$CanvasLayer/buttons/tutorial/btntutorial.mouse_exited.connect(btntutorialmouseexited)
	$CanvasLayer/buttons/stats/btnstats.mouse_entered.connect(btnstatsmouseentered)
	$CanvasLayer/buttons/stats/btnstats.mouse_exited.connect(btnstatsmouseexited)
	$CanvasLayer/buttons/skins/btnskins.mouse_entered.connect(btnskinsmouseentered)
	$CanvasLayer/buttons/skins/btnskins.mouse_exited.connect(btnskinsmouseexited)
	
	$CanvasLayer/buttons/stats/btnstats.pressed.connect(btnstatspressed)
	$"CanvasLayer/stats menu/control/hbox/btnexit".pressed.connect(btnstatsexitpressed)
	$CanvasLayer/buttons/settings/btnsettings.pressed.connect(btnsettingspressed)
	$"CanvasLayer/settings menu/btnexit".pressed.connect(btnsettingsexitpressed)
	$CanvasLayer/buttons/skins/btnskins.pressed.connect(btnskinspressed)
	$"CanvasLayer/skins menu/vbox/btnexit".pressed.connect(btnskinsexitpressed)
	$CanvasLayer/buttons/waaa/btnwaaa.pressed.connect(btnwaaapressed)
	$"CanvasLayer/buttons/muha gift/btnmuha".pressed.connect(btnmuhapressed)
	$CanvasLayer/buttons/tutorial/btntutorial.pressed.connect(btntutorialpressed)
	$"CanvasLayer/tutorial menu/btnexit".pressed.connect(btntutorialexitpressed)
	$"CanvasLayer/start menu/btnexit".pressed.connect(btnstartexitpressed)
	
	$CanvasLayer/buttons/start/btnstart.pressed.connect(btnstartpressed)
	$CanvasLayer/buttons/exit/btnexit.pressed.connect(btnexitpressed)
	
	if Global.listskins[7]["unlocked"]:
		$"room1 1/elka/gift".visible = false
	
	$"CanvasLayer/skins menu".updateskin(false, true, true)
	
	await get_tree().create_timer(0.5).timeout
	$notification.display(
		tr("NOW_PLAYING").format({"track": "Unknown,
		hostile environment"}),
		tr("SOUNDTRACK_AUTHOR").format({"author": "TheNamelessDeity"}),
		load("res://sprites/icon3.png"), 4)
	
	if Global.iswinter:
		if Global.unlockachievement(4):
			$notification.display(Global.achievements[4]["name"],
			Global.achievements[4]["desc"],
			load("res://sprites/icon12.png"))
		
		$notification.display(tr("NOTIFICATION_NEWYEAR_NAME"),
		tr("NOTIFICATION_NEWYEAR_DESC"),
		load("res://sprites/new year colin skin/colin1idle.png"), 8)
		
		#var o = 0
		#for i in range(85):
			#if o == 5:
				#$notification.display(tr("у вас проблемы
				#с производительность!"), tr("понизьте настройки графики
				#в настройках, играть с таким
				#FPS будет трудно..."), load("res://sprites/icon3.png"), 6)
				#
				#break
			#
			#var curfps = Engine.get_frames_per_second()
			#if curfps < 25:
				#o += 1
			#await get_tree().create_timer(0.1).timeout
	
	Global.retranslateachievements()

func _input(event):
	if event is InputEventScreenDrag and Global.ismobile:
		$"room1 1".rotate_y(event.relative.x * sens)
		#centercam.rotate_y(-event.relative.x * sens)
		centercam.rotate_x(-event.relative.y * sens)
		centercam.rotation.x = clamp(centercam.rotation.x, -deg_to_rad(45), deg_to_rad(45))
		driftcam += event.relative.x / 1000
		driftcam = clamp(driftcam, -0.05, 0.05)
	
	if event is InputEventMouseMotion and !freecam:
		$"room1 1".rotate_y(event.relative.x * sens)
		#centercam.rotate_y(-event.relative.x * sens)
		centercam.rotate_x(-event.relative.y * sens)
		centercam.rotation.x = clamp(centercam.rotation.x, -deg_to_rad(45), deg_to_rad(45))
		driftcam += event.relative.x / 1000
		driftcam = clamp(driftcam, -0.05, 0.05)
	if Input.is_action_just_pressed("F1"):
		rotate_y(-deg_to_rad(45))
	elif Input.is_action_just_pressed("F2"):
		rotate_y(-deg_to_rad(45/2))

func _physics_process(delta: float) -> void:
	var mp = get_viewport().get_mouse_position()
	var tr = 900
	var sz = 1600
	dinamicbtn(delta, $CanvasLayer/buttons/start, $"room1 1/door", 25, tr, sz, mp)
	dinamicbtn(delta, $CanvasLayer/buttons/exit, $"room1 1/MeshInstance3D", 25, tr, sz, mp)
	dinamicbtn(delta, $CanvasLayer/buttons/settings, $"room1 1/MeshInstance3D2", 25, tr, sz, mp)
	dinamicbtn(delta, $CanvasLayer/buttons/tutorial, $"room1 1/mesh1", 25, tr, sz, mp)
	dinamicbtn(delta, $CanvasLayer/buttons/stats, $"room1 1/Sprite3D", 25, tr, sz, mp)
	dinamicbtn(delta, $CanvasLayer/buttons/skins, $"room1 1/Sprite3D2", 25, tr, sz, mp)
	dinamicbtn(delta, $CanvasLayer/buttons/waaa, $"room1 1/Sprite3D3", 25, tr / 8, sz / 8, mp)
	if $"room1 1/elka/gift".visible:
		dinamicbtn(delta, $"CanvasLayer/buttons/muha gift", $"room1 1/elka/gift", 25, tr / 8, sz / 8, mp)
	else:
		$"CanvasLayer/buttons/muha gift".visible = false
	
	if Global.ismobile and Input.is_action_pressed("LCM"):
		freecam = false
	
	if Input.is_action_pressed("RCM") or Input.is_action_pressed("CCM"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		freecam = false
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		freecam = true
	
	cam.rotation.z += driftcam
	driftcam = lerp(driftcam, 0.0, 8 * delta)
	cam.rotation.z = lerp(cam.rotation.z, 0.0, 8 * delta)
	
	cam.size = lerp(cam.size, camsize, 10 * delta)

#btn = button, unprpos = unproject position, tr = transparent, sz = size
func dinamicbtn(curdelta: float, btn, unprpos, speed: int, tr: int, sz: int, mousepos):
	btn.global_position = lerp(btn.global_position, cam.unproject_position(unprpos.global_position), speed * curdelta)
	btn.modulate = Color(1, 1, 1, 1.0 - mousepos.distance_to(btn.global_position) / tr)
	btn.scale = Vector2(
		1.0 - mousepos.distance_to(btn.global_position) / sz,
		1.0 - mousepos.distance_to(btn.global_position) / sz
	)

func btnstartmouseentered(): $CanvasLayer/text/Label.text = tr("HINT_START_BUTTON")
func btnstartmouseexited(): $CanvasLayer/text/Label.text = tr("HINT_DEFAULT")
func btnexitmouseentered(): $CanvasLayer/text/Label.text = tr("HINT_EXIT_BUTTON")
func btnexitmouseexited(): $CanvasLayer/text/Label.text = tr("HINT_DEFAULT")
func btnsettingsmouseentered(): $CanvasLayer/text/Label.text = tr("HINT_SETTINGS_BUTTON")
func btnsettingsmouseexited(): $CanvasLayer/text/Label.text = tr("HINT_DEFAULT")
func btntutorialmouseentered(): $CanvasLayer/text/Label.text = tr("HINT_TUTORIAL_BUTTON")
func btntutorialmouseexited(): $CanvasLayer/text/Label.text = tr("HINT_DEFAULT")
func btnstatsmouseentered(): $CanvasLayer/text/Label.text = tr("HINT_STATS_BUTTON")
func btnstatsmouseexited(): $CanvasLayer/text/Label.text = tr("HINT_DEFAULT")
func btnskinsmouseentered(): $CanvasLayer/text/Label.text = tr("HINT_SKINS_BUTTON")
func btnskinsmouseexited(): $CanvasLayer/text/Label.text = tr("HINT_DEFAULT")

func btnstatspressed(): $"CanvasLayer/stats menu".visible = true; $CanvasLayer/buttons.visible = false
func btnstatsexitpressed():$"CanvasLayer/stats menu".visible = false; $CanvasLayer/buttons.visible = true
func btnwaaapressed():
	var random = randi_range(1, 5)
	match random:
		1: $"room1 1/Sprite3D3/AudioStreamPlayer3D".stream = load("res://sounds music/MeowFat3.wav")
		2: $"room1 1/Sprite3D3/AudioStreamPlayer3D".stream = load("res://sounds music/MeowPup3.wav")
		3: $"room1 1/Sprite3D3/AudioStreamPlayer3D".stream = load("res://sounds music/MeowPup5.wav")
		4: $"room1 1/Sprite3D3/AudioStreamPlayer3D".stream = load("res://sounds music/MeowPupShort1.wav")
		5: $"room1 1/Sprite3D3/AudioStreamPlayer3D".stream = load("res://sounds music/MeowPupShort3.wav")
	$"room1 1/Sprite3D3/AudioStreamPlayer3D".play()
	
	if Global.unlockachievement(1):
		$notification.display(Global.achievements[1]["name"],
		Global.achievements[1]["desc"],
		load("res://sprites/icon12.png"))

func btnmuhapressed():
	Global.listskins[7]["unlocked"] = true
	SavingManager.save("skinlist", Global.listskins)
	if $"room1 1/elka/gift".visible:
		$"room1 1/elka/gift".visible = false
	
	$notification.display(tr("NOTIFICATION_NEW_SKIN_NAME"),
	tr("NOTIFICATION_NEW_SKIN_PEAR_MUHA_DESC"),
	load("res://sprites/icon7.png"))

func btnskinspressed():
	$"CanvasLayer/skins menu".visible = true
	$CanvasLayer/buttons.visible = false
	$CanvasLayer/text.visible = false
	camsize = 6
func btnskinsexitpressed():
	$"CanvasLayer/skins menu".visible = false
	$CanvasLayer/buttons.visible = true
	$CanvasLayer/text.visible = true
	$"CanvasLayer/skins menu".updateskin(true, false)
	camsize = 15
func btnsettingspressed(): $"CanvasLayer/settings menu".visible = true; $CanvasLayer/buttons.visible = false
func btnsettingsexitpressed(): $"CanvasLayer/settings menu".visible = false; $CanvasLayer/buttons.visible = true
func btntutorialpressed(): $"CanvasLayer/tutorial menu".visible = true; $CanvasLayer/buttons.visible = false
func btntutorialexitpressed(): $"CanvasLayer/tutorial menu".visible = false; $CanvasLayer/buttons.visible = true

func btnstartpressed():$"CanvasLayer/start menu".visible = true
func btnstartexitpressed():$"CanvasLayer/start menu".visible = false
func btnexitpressed():get_tree().quit()
