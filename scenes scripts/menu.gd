extends Node3D

var centercam
var cam
var freecam: bool = false
var sens: float = 0.01
var driftcam: float = 0.0
var camscalewheel: float = 10.0


func _ready():
	centercam = get_node("center camera")
	cam = centercam.get_node("cam")

func _input(event):
	if event is InputEventMouseMotion and !freecam:
		rotate_y(-event.relative.x * sens)
		centercam.rotate_x(-event.relative.y * sens)
		centercam.rotation.x = clamp(centercam.rotation.x, -deg_to_rad(45), deg_to_rad(45))
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
	if Input.is_action_pressed("RCM") or Input.is_action_pressed("CCM"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		freecam = false
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		freecam = true
	
	cam.rotation.z += driftcam
	driftcam = lerp(driftcam, 0.0, 8 * delta)
	cam.rotation.z = lerp(cam.rotation.z, 0.0, 8 * delta)
