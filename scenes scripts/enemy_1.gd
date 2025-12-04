extends CharacterBody3D

@export var speed = 4.75
@export var nerf = 3.0
@export var randomspawn = 0
@export var ismimic = false
@export var isblackenemy = false

var canmove = false
var canpunch = true
var canunsleep = false
var curspeed = 3.5
var speeddist = 0.0
var framess = 0.0
var framessl = 0.0
var ultratuffpower = 6.0
var timess = 55.0
var timessl = 475.0
var runanim = "run"
var sleepanim = "sleep"
var isfemale = false
var isactive = false

func _ready():
	add_to_group("enemy")
	$Area3D.body_entered.connect(areaplayerentered)
	$Area3D.body_exited.connect(areaplayerexited)
	Global.punchpl.connect(punching)
	
	if randomspawn != 0 and randi_range(0, randomspawn) != randomspawn:
		queue_free()
	
	if isblackenemy:
		isfemale = randi_range(1, 2) == 2
		if isfemale:
			$Sprite3D.sprite_frames = load("res://skins/enemy_female__2_loc_sprite.tres")
	
	if Global.iswinter and !ismimic:
		runanim = "run newyear"
	
	sleep()

func _physics_process(delta):
	var player = get_tree().get_first_node_in_group("player")
	if !player:
		return
	var playerdist = global_position.distance_to(player.global_position)
	
	if canmove:
		speeddist = clampf(0.0 + playerdist / nerf, 0.0, 25.0)
		if playerdist / nerf > 32.5:
			queue_free()
	
	if player.velocity.length() > 2.1 and canunsleep and !isactive:
		unsleep()
	
	if canmove:
		var nextloc = $NavigationAgent3D.get_next_path_position()
		var curloc = global_transform.origin
		var newvelocity = (nextloc - curloc).normalized() * curspeed
		
		velocity = velocity.move_toward(newvelocity, 0.5)
		move_and_slide()
		
		if velocity.length() > 0:
			$Sprite3D.play(runanim)
			$Sprite3D.flip_h = velocity.x < 0
			$Sprite3D.speed_scale = velocity.length() / 5
		
		if velocity.length() < 0.7 and playerdist > 1.5:
			framess += 1
			framessl += 1
			$wha.visible = true
			$NavigationAgent3D.simplify_path = true
			
			if not ismimic:
				set_collision_layer_value(2, false)
				set_collision_mask_value(2, false)
			
			if playerdist > 5:
				set_collision_mask_value(1, false)
			
			curspeed += 1.0
			var direction = (global_position - player.global_position).normalized()
			
			if framess > timess:
				velocity += direction * ultratuffpower
				framess = 0
				ultratuffpower += 0.75
				timess = clamp(timess - 2, 20, 80)
			
			if framessl > timessl:
				velocity += direction * ultratuffpower * 2
				set_collision_mask_value(1, false)
				await get_tree().create_timer(2.5).timeout
				framessl = 0
				framess = 0
				timess = 55
				sleep()
		elif velocity.length() > 0.7:
			$NavigationAgent3D.simplify_path = false
			if ismimic:
				set_collision_layer_value(4, true)
			else:
				set_collision_layer_value(2, true)
				set_collision_mask_value(2, true)
				set_collision_mask_value(1, true)
			
			framessl = 0
			framess = 0
			timess = 55
			ultratuffpower = 6.0
			$wha.visible = false
	
	if global_position.y != 0.9:
		global_position.y = 0.9
	
	curspeed = lerp(curspeed, speed + speeddist, 3 * delta)
	
	if player and canmove:
		targetpos(player.global_transform.origin)

func punching():
	var player = get_tree().get_first_node_in_group("player")
	if !player or !canpunch or global_position.distance_to(player.global_position) > 2.5:
		return
	
	canpunch = false
	set_collision_layer_value(2, false)
	set_collision_layer_value(4, false)
	set_collision_mask_value(2, false)
	set_collision_mask_value(4, false)
	
	canmove = false
	var direction = (global_position - player.global_position).normalized()
	velocity = direction * 8.5
	move_and_slide()
	$wha.visible = true
	
	var timer = 0.0
	while timer < 0.3:
		velocity = velocity.lerp(Vector3.ZERO, 0.05)
		move_and_slide()
		await get_tree().create_timer(0.01).timeout
		timer += 0.01
	
	$wha.visible = false
	if ismimic:
		set_collision_layer_value(4, true)
	else:
		set_collision_layer_value(2, true)
		set_collision_mask_value(2, true)
	
	canmove = true
	$Timer.start()
	targetpos(get_tree().get_first_node_in_group("player").global_transform.origin)

func exitfromvent():
	isactive = true
	add_to_group("unsleep enemy")
	canmove = true
	canunsleep = false
	Global.unsleepenemies += 1
	$AnimationPlayer.play("RESET")
	checkenemies()

func sleep():
	if isactive:
		isactive = false
		remove_from_group("unsleep enemy")
	
	canmove = false
	canunsleep = false
	velocity = Vector3.ZERO
	$AnimationPlayer.play("sleep")

func unsleep():
	if isactive:
		return
	
	isactive = true
	canunsleep = false
	$AnimationPlayer.play("its colin!")
	await $AnimationPlayer.animation_finished
	canmove = true
	add_to_group("unsleep enemy")
	Global.unsleepenemies += 1
	checkenemies()

func areaplayerentered(body):
	if body.is_in_group("player") and !isactive:
		canunsleep = true

func areaplayerexited(body):
	if body.is_in_group("player") and !isactive:
		sleep()
		canunsleep = false

func targetpos(target):
	await get_tree().create_timer(0.15).timeout
	$NavigationAgent3D.set_target_position(target)

func checkenemies():
	var enemies = get_tree().get_nodes_in_group("unsleep enemy")
	if enemies.size() > 10:
		if Global.unlockachievement(7):
			var ach = get_tree().current_scene.get_node("notification")
			ach.display(Global.achievements[7]["name"], Global.achievements[7]["desc"], load("res://sprites/icon12.png"))
		
		for i in range(enemies.size() - 10):
			if i < enemies.size():
				enemies[i].queue_free()

func _on_timer_timeout():
	canpunch = true
