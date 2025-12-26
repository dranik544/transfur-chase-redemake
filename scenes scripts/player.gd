extends CharacterBody3D


@export var speed = 6.25
const JUMP_VELOCITY = 4.5
@export var sens: float = 0.002
var freecam: bool = true
var hit: bool = false
var taunt: bool = false
@export var health: float = 6.0
var guie = false
var slimebasepos = Vector2.ZERO
var slimetimepos = 0.0
var isslide: bool = false
var slidevelocity = Vector3.ZERO
@export var MaxSlideSpeed: float = 11.5
@export var slidespeed: float = 11.5
@export var slidespeedminus: float = 10.0
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
var itempointstime: int = 0
var itempointstimemax: int = 0
@export var centercam: Node3D
@export var cam: Camera3D
var camfollow: bool = false
var camfollowpos: Vector3 = Vector3.ZERO
var camfollowpluspos: float = 0.0
var camscalewheel = 0.0
@export var latexpunchsound1: AudioStream = preload("res://sounds music/latexpunch2.mp3")
@export var latexpunchsound2: AudioStream = preload("res://sounds music/latexpunch3.mp3")
@export var halatpunchsound1: AudioStream = preload("res://sounds music/halatpunch1.mp3")
var defposspr: Vector3 = Vector3.ZERO
var isthereenemy: bool = false
@export var shakeIfThereEnemy: float = 20
var oneshot: bool = true
var noslide: bool = true
@export var damage: float = 1.0
var itemdata = {}

var camshake: float = 0.0
var camshakedur: float = 0.0
var campos: Vector3
var camrot: Vector3
var iscamshaking: bool = false
var camposoffset: Vector3 = Vector3.ZERO
var camrotoffset: Vector3 = Vector3.ZERO

func startshake(intensity: float, dur: float):
	camshake = intensity
	camshakedur = dur
	iscamshaking = true

func _ready():
	add_to_group("player")
	slimebasepos = $gui/slime.position
	centercam = get_node("center camera")
	cam = centercam.get_node("cam")
	defposspr = $Sprite3D.position
	
	updateskin()
	
	campos = cam.position
	camrot = cam.rotation

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
	camscalewheel = clampf(camscalewheel, -2.5, 9.0)
	
	if event.is_action_pressed("F"):
		Global.punchpl.emit(damage)
		Global.hitdoor.emit(damage)
	if event.is_action_pressed("E"):
		Global.pickupitem.emit(self, true)

func camfollowupdate(canfollow: bool, camposx = 0.0, camposz = 0.0):
	camfollow = canfollow
	if !canfollow:
		camfollowpos = Vector3(camposx, centercam.global_position.y, camposz)
		#camfollowpos = centercam.global_position
		#camfollowpos.x = centercam.global_position.x - camposx
	else:
		camfollowpluspos = 0.0

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("RCM") or Input.is_action_pressed("CCM"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		freecam = false
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		freecam = true
	if Input.is_action_pressed("DOSKA"): get_tree().change_scene_to_file("res://doskapochteniya.tscn") #res://doskapochteniya.tscn", Color.SLATE_GRAY, 0.2)
	
	if camfollow:
		centercam.global_position = lerp(centercam.global_position, global_position, 6 * delta)
	else:
		centercam.global_position = lerp(centercam.global_position, camfollowpos, 6 * delta)
	
	cam.rotation.z += driftcam
	driftcam = lerp(driftcam, 0.0, 8 * delta)
	cam.rotation.z = lerp(cam.rotation.z, 0.0, 8 * delta)
	
	$gui/colinbg.position = $"center camera/cam".unproject_position($Sprite3D.global_position)
	$gui/colinbg.scale = Vector2(1 / $"center camera/cam".size * 38, 1 / $"center camera/cam".size * 38)
	if $"center camera/cam/RayCast3D".is_colliding():
		$gui/colinbg.modulate = Color(1, 1, 1, lerp($gui/colinbg.modulate.a, 0.25, 5 * delta))
	else:
		$gui/colinbg.modulate = Color(1, 1, 1, lerp($gui/colinbg.modulate.a, 0.0, 5 * delta))
	
	if Global.settings["shakescreen"]:
		campos = cam.position
		camrot = cam.rotation
		if iscamshaking and camshakedur > 0:
			camposoffset = Vector3(
				randf_range(-camshake, camshake) * 0.002,
				randf_range(-camshake, camshake) * 0.002,
				randf_range(-camshake, camshake) * 0.001
			)
			camrotoffset = Vector3(
				randf_range(-camshake, camshake) * 0.0003,
				randf_range(-camshake, camshake) * 0.0003,
				randf_range(-camshake, camshake) * 0.0002
			)
			
			cam.position = campos + camposoffset
			cam.rotation = camrot + camrotoffset
			
			camshakedur -= delta
			camshake = lerp(camshake, 0.0, delta * 3.0)
			
			if camshakedur <= 0:
				iscamshaking = false
				camshake = 0.0
		else:
			cam.position = lerp(cam.position, campos, 10 * delta)
			cam.rotation = lerp(cam.rotation, camrot, 10 * delta)
	
	var enemies = get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		if enemy:
			var disttoenemy = global_position.distance_to(enemy.global_position)
			if disttoenemy <= 3:
				$Sprite3D.position = defposspr + Vector3(
					randf_range(-shakeIfThereEnemy / 1000, shakeIfThereEnemy / 1000),
					randf_range(-shakeIfThereEnemy / 1000, shakeIfThereEnemy / 1000),
					randf_range(-shakeIfThereEnemy / 1000, shakeIfThereEnemy / 1000)
				)
				$sh.emitting = true
				
				break
			else:
				$Sprite3D.position = defposspr
				$sh.emitting = false
		else:
			$Sprite3D.position = defposspr
			$sh.emitting = false
	
	if Input.is_action_pressed("CTRL"):
		if itemdata.has("kg"):
			itemkg = itemdata["kg"]
		
		if !isslide:
			$CollisionShape3D2.disabled = false
			await get_tree().physics_frame
			$CollisionShape3D.disabled = true
		speed = lerp(speed, 2.5 - itemkg, 5 * delta)
		taunt = true
	else:
		if itemdata.has("kg"):
			itemkg = itemdata["kg"]
		
		if !$RayCast3D.is_colliding():
			if !isslide:
				$CollisionShape3D.disabled = false
				await get_tree().physics_frame
				$CollisionShape3D2.disabled = true
			speed = lerp(speed, 6.0 - itemkg, 3 * delta)
			taunt = false
	
	#hit = Input.is_action_pressed("F")
	#pick = Input.is_action_pressed("E")
	
	#var camitem = get_viewport().get_camera_3d()
	#var directionitem = -camitem.global_transform.basis.z
	#var throwpos = (camitem.global_transform.basis.z / 0.75)
	
	if isinv:
		if itemdata["sprite"] and itemdata["type"]:
			$gui/gui/invtexture.texture = itemdata["sprite"]
			var ittype = tr(itemdata["type"])
			$gui/gui/Label.text = ittype + " (" + str(itemdata["pointstime"] + 1) + "/" + str(itemdata["pointstimemax"] + 1) + ")"
		if Input.is_action_just_pressed("LCM") and !Engine.time_scale < 1.0:
			useitem()
	
	if health < 3.0:
		$gui/slime.position = slimebasepos + Vector2(
			sin(slimetimepos) * 10, #randf_range(-1, 1),
			sin(slimetimepos / 2) * 10 #randf_range(-1, 1)
		)
		$gui/slime.modulate.a = 0.75 + sin(slimetimepos) * 0.2
		$gui/slime.rotation = sin(slimetimepos * 2.0) * 0.02
		slimetimepos += delta
		$gui/slime.scale = lerp($gui/slime.scale, Vector2(1.1, 1.1), 5 * delta)
		#$gui.offset = guibasepos + Vector2(randf_range(-2, 2), randf_range(-2, 2))
	else:
		$gui/slime.scale = lerp($gui/slime.scale, Vector2(2.5, 2.5), 2 * delta)
	if health <= 0.0:
		$Sprite3D.animation = "transfur"
		var tween = create_tween()
		tween.tween_property($"center camera/cam", "size", 0, 4)
		$"center camera/cam".look_at($Sprite3D.global_position)
		await $Sprite3D.animation_finished
		if not is_queued_for_deletion() and get_tree():
			ScreenTransition.changescene("res://scenes scripts/newdeathscreen.tscn", Color.WHITE, 0.5) #get_tree().change_scene_to_file("res://scenes scripts/newdeathscreen.tscn")
	
	
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
		$gui/gui/slidebar/slidetimer.start()
		var tweenslidebar = create_tween()
		$gui/gui/slidebar.value = 0.0
		tweenslidebar.tween_property($gui/gui/slidebar, "value", 100.0, $gui/gui/slidebar/slidetimer.wait_time)
		$gui/gui/slidebar/slidebar.visible = true
		isslide = true
		slidedir = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
		startshake(5, $gui/gui/slidebar/slidetimer.wait_time)
		
		noslide = false
	
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
		
		set_collision_mask_value(2, false)
		set_collision_mask_value(4, false)
		$Area3D.set_collision_mask_value(2, false)
		$Area3D.set_collision_mask_value(4, false)
		if !$slide.playing:
			$slide.play()
	else:
		if !taunt and !$RayCast3D.is_colliding():
			$CollisionShape3D.disabled = false
			if not is_queued_for_deletion() and get_tree():
				await get_tree().physics_frame
			$CollisionShape3D2.disabled = true
			
			set_collision_mask_value(2, true)
			set_collision_mask_value(4, true)
			$Area3D.set_collision_mask_value(2, true)
			$Area3D.set_collision_mask_value(4, true)
		isslide = false
		$slide.stop()
	
	cam.size = lerp(cam.size, camscale + camscalewheel, 5 * delta)
	$gui/slimecolor.color = lerp($gui/slimecolor.color, Color(1.0, 1.0, 1.0, 0.0), 1 * delta)
	
	if !isslide:
		if direction:
			if !taunt:
				$Sprite3D.play("run")
				camscale = lerp(camscale, 11.0, 10 * delta)
				if !$steps.playing:
					$steps.play()
			else:
				$Sprite3D.play("taunt run")
				camscale = lerp(camscale, 11.0, 11 * delta)
			velocity.x = lerp(velocity.x, direction.x * speed, 9 * delta)
			velocity.z = lerp(velocity.z, direction.z * speed, 9 * delta)
		else:
			if !taunt:
				$steps.stop()
				$Sprite3D.play("idle")
				camscale = lerp(camscale, 9.0, 10 * delta)
			else:
				$Sprite3D.play("taunt")
				camscale = lerp(camscale, 8.5, 10 * delta)
			velocity.x = lerp(velocity.x, move_toward(velocity.x, 0, speed), 15 * delta)
			velocity.z = lerp(velocity.z, move_toward(velocity.z, 0, speed), 15 * delta)
	
	if Input.is_action_just_pressed("A"):
		$Sprite3D.flip_h = true
		$gui/colinbg.flip_h = true
		if Global.colinskin == "muha":
			$Sprite3D.flip_h = not $Sprite3D.flip_h
			$gui/colinbg.flip_h = not $gui/colinbg.flip_h
	elif Input.is_action_just_pressed("D"):
		$Sprite3D.flip_h = false
		$gui/colinbg.flip_h = false
		if Global.colinskin == "muha":
			$Sprite3D.flip_h = not $Sprite3D.flip_h
			$gui/colinbg.flip_h = not $gui/colinbg.flip_h
	
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
	if body.is_in_group("slime") and !isslide:
		var color = detectenemycolor(body)
		minushealth(0.5, color)
		speed -= randf_range(4.0, 5.0)
		body.touched()
		
		oneshot = false
		
		startshake(20, 0.05)
	if body.is_in_group("enemy"):
		if itemdata.has("shieldenable"):
			camscale += randf_range(-10.0, -7.5)
			$latexpunch.stream = halatpunchsound1
			$latexpunch.play()
			speed += randf_range(1.0, 2.0)
			
			useitem()
		else:
			var color = detectenemycolor(body)
			minushealth(1.0, color)
			Global.hitsfromenemies -= 1
			speed += randf_range(0.5, 1.0)
			
			var random = randi_range(1, 2)
			match random:
				1: $latexpunch.stream = latexpunchsound1
				2: $latexpunch.stream = latexpunchsound2
			$latexpunch.play()
			
			oneshot = false
			
			startshake(20, 0.1)
	if body.is_in_group("small enemy"):
		if body.curtype == 1:
			body.robotbroke()
			minushealth(0.75, Color.BLACK)
			speed -= randf_range(5.0, 6.0)
		else:
			minushealth(0.25)
		Global.hitsfromenemies -= 1
		
		var random = randi_range(1, 2)
		match random:
			1: $latexpunch.stream = latexpunchsound1
			2: $latexpunch.stream = latexpunchsound2
		$latexpunch.play()
		
		oneshot = false
		
		startshake(20, 0.1)
	if body.is_in_group("broke") and isslide:
		Global.brokenboxes += 1
		
		body.broke()
		slidespeedminus -= randf_range(1.5, 2.5)
		
		startshake(30, 0.2)

func minushealth(num, color: Color = Color.WHITE):
	health -= num
	$gui/slime.scale = Vector2(1.5, 1.5)
	camscale += randf_range(-10.0, -7.5)
	
	var finalcolor = color
	finalcolor.a = randf_range(0.5, 0.8)
	$gui/slimecolor.color = finalcolor
	$gui/slime.modulate = finalcolor
	
	var slimeenum = randi_range(3, 8)
	for i in slimeenum:
		var slimee = TextureRect.new()
		var randomslimee = randi_range(1, 5)
		var spriteslimee: Texture = load("res://sprites/slimee" + str(randomslimee) + ".png")
		slimee.texture = spriteslimee
		slimee.custom_minimum_size = Vector2(
			randf_range(50, 200),
			randf_range(50, 200)
		)
		slimee.position = Vector2(
			randf_range(0, 640),
			randf_range(0, 480)
		)
		slimee.rotation = randf_range(-90, 90)
		
		slimee.pivot_offset = Vector2(slimee.size.x / 2, slimee.size.y / 2)
		slimee.modulate.a = randf_range(0.2, 1.0)
		slimee.modulate = finalcolor
		
		$gui.add_child(slimee)
		
		var tween = create_tween()
		var tweentime = randf_range(20, 50)
		
		tween.set_parallel(true)
		tween.tween_property(slimee, "modulate:a", 0.0, tweentime)
		tween.tween_property(slimee, "scale", Vector2(0.1, 0.1), tweentime)
		
		tween.finished.connect(func():
			slimee.queue_free()
		)

func _on_timer_timeout() -> void:
	isslide = false
	await get_tree().physics_frame
	var enemy: CharacterBody3D = get_tree().get_first_node_in_group("enemy")
	set_collision_mask_value(2, true)
	$Area3D.set_collision_mask_value(2, true)
	Global.navibake.emit()

func _on_slidetimer_timeout() -> void:
	canslide = true
	$gui/gui/slidebar/slidebar.visible = false

func useitem():
	var item = itemdata["scene"].instantiate()
	get_parent().add_child(item)
	item.global_position = global_position
	
	item.use()
	
	if itemdata["pointstime"] <= 0:
		if itemdata["scene"]:
			item.queue_free()
			#if item.ischangehp:
				#health += item.changehp
				#item.queue_free()
			
			itemdata.clear()
			$gui/gui/invtexture.texture = load("res://sprites/nullinv1.png")
			$gui/gui/Label.text = "DEFAULT_TYPE_ITEM"
			isinv = false
	elif itemdata["pointstime"] > 0:
		item.queue_free()
		itemdata["pointstime"] -= 1

func detectenemycolor(enemy):
	var typeenemy = enemy.curtype
	var colorhit: Color
	match typeenemy:
		0: colorhit = Color.WHITE_SMOKE
		1: colorhit = Color.BLACK
	
	return colorhit

func updateskin():
	match Global.colinskin:
		"colin":
			$gui/colinbg.texture = load("res://sprites/colin bg1.png")
			$Sprite3D.sprite_frames = load("res://skins/player_sprite.tres")
		"V1":
			$gui/colinbg.texture = load("res://sprites/V1 colin skin/colin bg1.png")
			$Sprite3D.sprite_frames = load("res://skins/v1_player_skin.tres")
		"hank":
			$gui/colinbg.texture = load("res://sprites/hank colin skin/colin bg1.png")
			$Sprite3D.sprite_frames = load("res://skins/hank_player_skin.tres")
		"nightmare colin":
			$gui/colinbg.texture = load("res://sprites/nightmare colin/colin bg1.png")
			$Sprite3D.sprite_frames = load("res://skins/nightmare_player_skin.tres")
		"new year colin":
			$gui/colinbg.texture = load("res://sprites/new year colin skin/colin bg1.png")
			$Sprite3D.sprite_frames = load("res://skins/new_year_colin_skin.tres")
		"necoarc":
			$gui/colinbg.texture = load("res://sprites/neco arc skin/colin bg 1.png")
			$Sprite3D.sprite_frames = load("res://skins/necoarc_player_skin.tres")
		"muha":
			$gui/colinbg.texture = load("res://sprites/muha skin/colin bg 1.png")
			$Sprite3D.sprite_frames = load("res://skins/muha_player_skin.tres")
		"solider":
			$gui/colinbg.texture = load("res://sprites/solider skin/colin bg 1.png")
			$Sprite3D.sprite_frames = load("res://skins/solider_colin_skin.tres")
		"yay basket ^w^":
			$gui/colinbg.texture = load("res://sprites/colin basket skin/colin bg1.png")
			$Sprite3D.sprite_frames = load("res://skins/basket_colin_skin.tres")
		"paladin":
			$gui/colinbg.texture = load("res://sprites/paladin skin/colin bg1.png")
			$Sprite3D.sprite_frames = load("res://skins/paladin_skin.tres")
		null:
			$gui/colinbg.texture = load("res://sprites/colin bg1.png")
			$Sprite3D.sprite_frames = load("res://skins/player_sprite.tres")
	
	$Sprite3D.play("idle")
