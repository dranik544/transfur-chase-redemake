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
	$CanvasLayer/start.global_position = lerp($CanvasLayer/start.global_position, cam.unproject_position($"room1 1/room1/door".global_position), 25 * delta)
	$CanvasLayer/exit.global_position = lerp($CanvasLayer/exit.global_position, cam.unproject_position($"room1 1/room1/MeshInstance3D".global_position), 25 * delta)
	$CanvasLayer/settings.global_position = lerp($CanvasLayer/settings.global_position, cam.unproject_position($"room1 1/room1/MeshInstance3D2".global_position), 25 * delta)
	$CanvasLayer/tutorial.global_position = lerp($CanvasLayer/tutorial.global_position, cam.unproject_position($"room1 1/room1/mesh1".global_position), 25 * delta)
	
	var mousepos = get_viewport().get_mouse_position()
	var tr = 600
	var sz = 1600
	$CanvasLayer/start.modulate = Color(1, 1, 1, 1.0 - mousepos.distance_to($CanvasLayer/start.global_position) / tr)
	$CanvasLayer/exit.modulate = Color(1, 1, 1, 1.0 - mousepos.distance_to($CanvasLayer/exit.global_position) / tr)
	$CanvasLayer/settings.modulate = Color(1, 1, 1, 1.0 - mousepos.distance_to($CanvasLayer/settings.global_position) / tr)
	$CanvasLayer/tutorial.modulate = Color(1, 1, 1, 1.0 - mousepos.distance_to($CanvasLayer/tutorial.global_position) / tr)
	
	$CanvasLayer/start.scale = Vector2(
		1.0 - mousepos.distance_to($CanvasLayer/start.global_position) / sz,
		1.0 - mousepos.distance_to($CanvasLayer/start.global_position) / sz
	)
	$CanvasLayer/exit.scale = Vector2(
		1.0 - mousepos.distance_to($CanvasLayer/exit.global_position) / sz,
		1.0 - mousepos.distance_to($CanvasLayer/exit.global_position) / sz
	)
	$CanvasLayer/settings.scale = Vector2(
		1.0 - mousepos.distance_to($CanvasLayer/settings.global_position) / sz,
		1.0 - mousepos.distance_to($CanvasLayer/settings.global_position) / sz
	)
	$CanvasLayer/tutorial.scale = Vector2(
		1.0 - mousepos.distance_to($CanvasLayer/tutorial.global_position) / sz,
		1.0 - mousepos.distance_to($CanvasLayer/tutorial.global_position) / sz
	)
	
	if Input.is_action_pressed("RCM") or Input.is_action_pressed("CCM"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		freecam = false
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		freecam = true
	
	cam.rotation.z += driftcam
	driftcam = lerp(driftcam, 0.0, 8 * delta)
	cam.rotation.z = lerp(cam.rotation.z, 0.0, 8 * delta)

func btnstartmouseentered():	$CanvasLayer/text/Label.text = "приготовьте свои мандарины"
func btnstartmouseexited():	$CanvasLayer/text/Label.text = ". . ."
func btnexitmouseentered():	$CanvasLayer/text/Label.text = "если надоело - это для вас"
func btnexitmouseexited():	$CanvasLayer/text/Label.text = ". . ."
func btnsettingsmouseentered():	$CanvasLayer/text/Label.text = "настройте игру как душа пожелает"
func btnsettingsmouseexited():	$CanvasLayer/text/Label.text = ". . ."
