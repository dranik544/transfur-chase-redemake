extends CharacterBody3D


@export var speed = 6.0
const JUMP_VELOCITY = 4.5
@export var sens: float = 0.002
var freecam: bool = true
var hit: bool = false
var taunt: bool = false
var health: int = 5
var guie = false
var slimebasepos = Vector2.ZERO
var slimetimepos = 0.0
var isslide: bool = false
var slidevelocity = Vector3.ZERO
@export var MaxSlideSpeed: float = 10.0
var slidespeed: float = 10.0
var slidespeedminus: float = 10.0
var slidedir = Vector3.ZERO
var canslide: bool = true
@export var BakeAfterSlide: bool = false
var driftcam: float = 0
var camscale = 13.0
var pick: bool = false
var isinv: bool = false
var itemscene: PackedScene
var itemsprite: CompressedTexture2D
var itemtype: String = "Тип предмета"
var itemkg: float = 0.0
@export var centercam: Node3D
@export var cam: Camera3D
var camfollow: bool = false
var camfollowpos: Vector3 = Vector3.ZERO
var camfollowpluspos: float = 0.0
var camscalewheel = 0.0


func _ready():
	add_to_group("player")
	slimebasepos = $gui/slime.position
	centercam = get_node("center camera")
	cam = centercam.get_node("cam")
	print(cam, centercam)

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

func camfollowupdate(canfollow: bool, camposx = 0.0):
	camfollow = canfollow
	if !canfollow:
		camfollowpos = centercam.global_position
		camfollowpos.x = centercam.global_position.x - camposx
	else:
		camfollowpluspos = 0.0

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("RCM") or Input.is_action_pressed("CCM"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		freecam = false
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		freecam = true
	
	if camfollow:
		centercam.global_position = lerp(centercam.global_position, global_position, 5 * delta)
	else:
		centercam.global_position = lerp(centercam.global_position, camfollowpos, 5 * delta)
	
	cam.rotation.z += driftcam
	driftcam = lerp(driftcam, 0.0, 8 * delta)
	cam.rotation.z = lerp(cam.rotation.z, 0.0, 8 * delta)
	
	$gui/colinbg.position = $"center camera/cam".unproject_position($Sprite3D.global_position)
	$gui/colinbg.scale = Vector2(1 / $"center camera/cam".size * 38, 1 / $"center camera/cam".size * 38)
	if $"center camera/cam/RayCast3D".is_colliding():
		$gui/colinbg.modulate = Color(1, 1, 1, lerp($gui/colinbg.modulate.a, 0.25, 5 * delta))
	else:
		$gui/colinbg.modulate = Color(1, 1, 1, lerp($gui/colinbg.modulate.a, 0.0, 5 * delta))
	
	if Input.is_action_pressed("CTRL"):
		if !isslide:
			$CollisionShape3D2.disabled = false
			await get_tree().physics_frame
			$CollisionShape3D.disabled = true
		speed = lerp(speed, 2.5 - itemkg, 5 * delta)
		taunt = true
	else:
		if !$RayCast3D.is_colliding():
			if !isslide:
				$CollisionShape3D.disabled = false
				await get_tree().physics_frame
				$CollisionShape3D2.disabled = true
			speed = lerp(speed, 6.0 - itemkg, 5 * delta)
			taunt = false
	
	hit = Input.is_action_pressed("F")
	pick = Input.is_action_pressed("E")
	
	var camitem = get_viewport().get_camera_3d()
	var directionitem = camitem.global_transform.basis.y
	var throwpos = (camitem.global_transform.basis.z / 0.75)
	
	if isinv:
		if itemsprite:
			$gui/invtexture.texture = itemsprite
			$gui/Label.text = itemtype
			#$gui/invtexture.scale = Vector2(2.0, 2.0)
			#$gui/invtexture.scale = lerp($gui/invtexture.scale, Vector2(1.0, 1.0), 5 * delta)
		if Input.is_action_just_pressed("LCM"):
			if itemscene:
				itemsprite = null
				$gui/invtexture.texture = load("res://sprites materials/nullinv1.png")
				var item = itemscene.instantiate()
				itemscene = null
				get_parent().add_child(item)
				item.global_position = global_position + throwpos
				item.apply_impulse(directionitem * 8 - Vector3(itemkg, itemkg, itemkg), Vector3.ZERO)
				item.isthrow = true
				itemkg = 0.0
				item.timer()
				itemtype = "Тип предмета"
				$gui/Label.text = itemtype
				isinv = false
	
	if health < 3:
		$gui/slime.position = slimebasepos + Vector2(
			sin(slimetimepos) * 10, #randf_range(-1, 1),
			sin(slimetimepos / 2) * 10 #randf_range(-1, 1)
		)
		$gui/slime.modulate = Color(1.0, 1.0, 1.0, 0.75 + sin(slimetimepos) * 0.2)
		$gui/slime.rotation = sin(slimetimepos * 2.0) * 0.02
		slimetimepos += delta
		$gui/slime.scale = lerp($gui/slime.scale, Vector2(1.1, 1.1), 5 * delta)
		#$gui.offset = guibasepos + Vector2(randf_range(-2, 2), randf_range(-2, 2))
	else:
		$gui/slime.scale = lerp($gui/slime.scale, Vector2(2.5, 2.5), 2 * delta)
	if health <= 0:
		get_tree().change_scene_to_file("res://scenes scripts/newdeathscreen.tscn")
	
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	#if Input.is_action_just_pressed("SPACE") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
	
	var input_dir := Input.get_vector("A", "D", "W", "S")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if Input.is_action_just_pressed("SPACE") and !isslide and canslide:
		canslide = false
		slidespeed = MaxSlideSpeed
		slidespeedminus = MaxSlideSpeed
		$Timer.start()
		$gui/slidebar/slidetimer.start()
		var tweenslidebar = create_tween()
		$gui/slidebar.value = 0.0
		tweenslidebar.tween_property($gui/slidebar, "value", 100.0, $gui/slidebar/slidetimer.wait_time)
		$gui/slidebar/slidebar.visible = true
		isslide = true
		slidedir = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if isslide:
		if !taunt:
			$CollisionShape3D2.disabled = false
			if not is_queued_for_deletion() and get_tree():
				await get_tree().physics_frame
			$CollisionShape3D.disabled = true
		$Sprite3D.play("slide")
		slidevelocity = slidedir * slidespeed
		velocity.x = slidevelocity.x
		velocity.z = slidevelocity.z
		slidespeed = lerp(slidespeed, slidespeedminus, 10 * delta)
		var enemy: CharacterBody3D = get_tree().get_first_node_in_group("enemy")
		enemy.collision_layer = false
	else:
		if !taunt:
			$CollisionShape3D.disabled = false
			if not is_queued_for_deletion() and get_tree():
				await get_tree().physics_frame
			$CollisionShape3D2.disabled = true
		isslide = false
	
	cam.size = lerp(cam.size, camscale + camscalewheel, 5 * delta)
	$gui/slimecolor.color = lerp($gui/slimecolor.color, Color(1.0, 1.0, 1.0, 0.0), 1 * delta)
	
	if !isslide:
		if direction:
			if !taunt:
				$Sprite3D.play("run")
				camscale = lerp(camscale, 11.0, 10 * delta)
			else:
				$Sprite3D.play("crawl run")
				camscale = lerp(camscale, 11.0, 11 * delta)
			velocity.x = lerp(velocity.x, direction.x * speed, 9 * delta)
			velocity.z = lerp(velocity.z, direction.z * speed, 9 * delta)
		else:
			if !taunt:
				$Sprite3D.play("idle")
				camscale = lerp(camscale, 9.0, 10 * delta)
			else:
				$Sprite3D.play("crawl run")
				camscale = lerp(camscale, 8.5, 10 * delta)
			velocity.x = lerp(velocity.x, move_toward(velocity.x, 0, speed), 15 * delta)
			velocity.z = lerp(velocity.z, move_toward(velocity.z, 0, speed), 15 * delta)
	if Input.is_action_just_pressed("A"):
		$Sprite3D.flip_h = true
		$gui/colinbg.flip_h = true
	elif Input.is_action_just_pressed("D"):
		$Sprite3D.flip_h = false
		$gui/colinbg.flip_h = false
	
	#if $"center camera/Camera3D/RayCast3D".is_colliding():
		#var collider = $"center camera/Camera3D/RayCast3D".get_collider()
		#if collider.is_in_group("wall"):
			#print("wall")
			#var coll: CSGBox3D = collider
			#coll.material.blend_mode = BaseMaterial3D.BLEND_MODE_MUL
			#if !$"center camera/Camera3D/RayCast3D".is_colliding():
				#coll.material.blend_mode = BaseMaterial3D.BLEND_MODE_MIX
		
	move_and_slide()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy"):
		minushealth()
	if body.is_in_group("broke") and isslide:
		Global.brokenboxes += 1
		body.queue_free()
		slidespeedminus -= randf_range(1.0, 2.5)
	if body.is_in_group("slime") and !isslide:
		minushealth()
		speed -= randf_range(4.0, 5.0)
		body.touched()

func minushealth():
	health -= 1
	$gui/slime.scale = Vector2(1.5, 1.5)
	camscale += randf_range(-10.0, -7.5)
	$gui/slimecolor.color = Color(1.0, 1.0, 1.0, randf_range(0.5, 0.8))
	
	var slimeenum = randi_range(1, 3)
	for i in slimeenum:
		var slimee = TextureRect.new()
		var randomslimee = randi_range(1, 4)
		var spriteslimee: Texture = load("res://sprites materials/slimee" + str(randomslimee) + ".png")
		slimee.texture = spriteslimee
		slimee.custom_minimum_size = Vector2(
			randf_range(25, 100),
			randf_range(25, 100)
		)
		slimee.modulate = Color(1.0, 1.0, 1.0, randf_range(0.2, 1.0))
		slimee.position = Vector2(
			randf_range(0, 640),
			randf_range(0, 480)
		)
		$gui.add_child(slimee)

func _on_timer_timeout() -> void:
	isslide = false
	await get_tree().physics_frame
	var enemy: CharacterBody3D = get_tree().get_first_node_in_group("enemy")
	enemy.collision_layer = true
	Global.navibakereq

func _on_slidetimer_timeout() -> void:
	canslide = true
	$gui/slidebar/slidebar.visible = false
