extends Node3D

var centercam
var cam
var freecam: bool = false
var sens: float = 0.01
var driftcam: float = 0
var camscalewheel: float = 10.0


func _ready():
	centercam = get_node("center camera")
	cam = centercam.get_node("cam")
	
	$CanvasLayer/start/btnstart.mouse_entered.connect(btnstartmouseentered)
	$CanvasLayer/start/btnstart.mouse_exited.connect(btnstartmouseexited)
	$CanvasLayer/exit/btnexit.mouse_entered.connect(btnexitmouseentered)
	$CanvasLayer/exit/btnexit.mouse_exited.connect(btnexitmouseexited)
	$CanvasLayer/settings/btnsettings.mouse_entered.connect(btnsettingsmouseentered)
	$CanvasLayer/settings/btnsettings.mouse_exited.connect(btnsettingsmouseexited)
	$CanvasLayer/tutorial/btntutorial.mouse_entered.connect(btntutorialmouseentered)
	$CanvasLayer/tutorial/btntutorial.mouse_exited.connect(btntutorialmouseexited)
	$CanvasLayer/stats/btnstats.mouse_entered.connect(btnstatsmouseentered)
	$CanvasLayer/stats/btnstats.mouse_exited.connect(btnstatsmouseexited)

func _input(event):
	if event is InputEventMouseMotion and !freecam:
		$"room1 1".rotate_y(event.relative.x * sens)
		#centercam.rotate_y(-event.relative.x * sens)
		centercam.rotate_x(-event.relative.y * sens)
		#centercam.rotation.x = clamp(centercam.rotation.x, -deg_to_rad(45), deg_to_rad(45))
		driftcam += event.relative.x / 1000
		driftcam = clamp(driftcam, -0.05, 0.05)
	if Input.is_action_just_pressed("F1"):
		rotate_y(-deg_to_rad(45))
	elif Input.is_action_just_pressed("F2"):
		rotate_y(-deg_to_rad(45/2))

func _unhandled_input(event):
	if event.is_action_pressed("CCM DOWN"):
		camscalewheel += 0.75
	if event.is_action_pressed("CCM UP"):
		camscalewheel -= 0.75
	camscalewheel = clampf(camscalewheel, -2.5, 7.5)

func _physics_process(delta: float) -> void:
	var mp = get_viewport().get_mouse_position()
	var tr = 900
	var sz = 1600
	dinamicbtn(delta, $CanvasLayer/start, $"room1 1/room1/door", 25, tr, sz, mp)
	dinamicbtn(delta, $CanvasLayer/exit, $"room1 1/room1/MeshInstance3D", 25, tr, sz, mp)
	dinamicbtn(delta, $CanvasLayer/settings, $"room1 1/room1/MeshInstance3D2", 25, tr, sz, mp)
	dinamicbtn(delta, $CanvasLayer/tutorial, $"room1 1/room1/mesh1", 25, tr, sz, mp)
	dinamicbtn(delta, $CanvasLayer/stats, $"room1 1/room1/Sprite3D", 25, tr, sz, mp)
	
	if Input.is_action_pressed("RCM") or Input.is_action_pressed("CCM"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		freecam = false
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		freecam = true
	
	cam.rotation.z += driftcam
	driftcam = lerp(driftcam, 0.0, 8 * delta)
	cam.rotation.z = lerp(cam.rotation.z, 0.0, 8 * delta)

#btn = button, unprpos = unproject position, tr = transparent, sz = size
func dinamicbtn(curdelta: float, btn, unprpos, speed: int, tr: int, sz: int, mousepos):
	btn.global_position = lerp(btn.global_position, cam.unproject_position(unprpos.global_position), speed * curdelta)
	btn.modulate = Color(1, 1, 1, 1.0 - mousepos.distance_to(btn.global_position) / tr)
	btn.scale = Vector2(
		1.0 - mousepos.distance_to(btn.global_position) / sz,
		1.0 - mousepos.distance_to(btn.global_position) / sz
	)

func btnstartmouseentered():	$CanvasLayer/text/Label.text = "приготовьте свои мандарины!"
func btnstartmouseexited():	$CanvasLayer/text/Label.text = ". . ."
func btnexitmouseentered():	$CanvasLayer/text/Label.text = "если надоело - это для вас."
func btnexitmouseexited():	$CanvasLayer/text/Label.text = ". . ."
func btnsettingsmouseentered():	$CanvasLayer/text/Label.text = "настройте игру как душа пожелает!"
func btnsettingsmouseexited():	$CanvasLayer/text/Label.text = ". . ."
func btntutorialmouseentered():	$CanvasLayer/text/Label.text = "освежите память!"
func btntutorialmouseexited():	$CanvasLayer/text/Label.text = ". . ."
func btnstatsmouseentered():	$CanvasLayer/text/Label.text = "узнайте свою статистику и новое об противниках!"
func btnstatsmouseexited():	$CanvasLayer/text/Label.text = ". . ."
