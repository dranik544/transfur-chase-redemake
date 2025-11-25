extends CharacterBody3D

@export var speed = 4.75
var canmove: bool = false
var curspeed = 3.5
var speeddist = 0.0
var hasentered = false
var framess: float = 0.0
var framessl: float = 0.0
var ultratuffpower: float = 3.0
var timess: float = 55.0
var timessl: float = 475.0
var canpunch: bool = true

@export var nerf: float = 3.0
@export var randomspawn: int = 0


func _ready():
	add_to_group("enemy")
	$Area3D.body_entered.connect(areaplayerentered)
	Global.punchpl.connect(punching)
	
	if randomspawn != 0:
		var random: int = randi_range(0, randomspawn)
		if randomspawn != random:
			queue_free()
	
	checkenemies()
	
	sleep()
	
	if Global.iswinter:
		$Sprite3D.sprite_frames = load("res://skins/newyear_enemy_sprite.tres")

func _physics_process(delta):
	var nextloc = $NavigationAgent3D.get_next_path_position()
	var curloc = global_transform.origin
	var newvelocity = (nextloc - curloc).normalized() * curspeed
	var player: CharacterBody3D = get_tree().get_first_node_in_group("player")
	var playerdist = global_position.distance_to(player.global_position)
	
	if player and canmove:
		speeddist = 0.0 + playerdist / nerf
		if playerdist / nerf > 32.5:
			queue_free()
	speeddist = clampf(speeddist, 0.0, 25.0)
	
	if velocity.length() > 0:
		$Sprite3D.play("run")
		if velocity.x > 0:
			$Sprite3D.flip_h = false
		elif velocity.x < 0:
			$Sprite3D.flip_h = true
	
	if velocity.length() < 0.7 and canmove:
		if playerdist > 1.5:
			framess += 1
			framessl += 1
			
			$wha.visible = true
			$NavigationAgent3D.simplify_path = true
			
			curspeed += 1.0
			var direction = (global_position - player.global_position).normalized()
			
			if framess > timess:
				velocity += direction * ultratuffpower
				framess = 0
				ultratuffpower += 0.75
				timess -= 2
				timess = clamp(timess, 20, 80)
			
			if framessl > timessl:
				$NavigationAgent3D.avoidance_enabled = false
				velocity += direction * ultratuffpower * 2
				transform.basis += direction * ultratuffpower
				
				await get_tree().create_timer(2.5).timeout
				framessl = 0
				framess = 0
				timess = 55
				sleep()
	else:
		$NavigationAgent3D.avoidance_enabled = true
		$NavigationAgent3D.simplify_path = false
		framessl = 0
		framess = 0
		timess = 55
		ultratuffpower = 3.0
		$wha.visible = false
	
	#if $RayCast3D.is_colliding():
		#speed = 1.5
	#else:
		#speed = 3.5
	
	if global_position.y != 0.9:
		global_position.y = 0.9
	curspeed = lerp(curspeed, speed + speeddist, 3 * delta)
	if canmove:
		velocity = velocity.move_toward(newvelocity, 0.5)
		move_and_slide()
	
	if player and canmove:
		targetpos(player.global_transform.origin)

func exitfromvent():
	add_to_group("unsleep enemy")
	canmove = true
	hasentered = true
	$AnimationPlayer.play("RESET")

func sleep():
	remove_from_group("unsleep enemy")
	canmove = false
	hasentered = false
	velocity = Vector3(0.0, 0.0, 0.0)
	$AnimationPlayer.play("sleep")

func areaplayerentered(body):
	if body.is_in_group("player") and !hasentered:
		hasentered = true
		$AnimationPlayer.play("its colin!")
		await $AnimationPlayer.animation_finished
		canmove = true
		add_to_group("unsleep enemy")
		Global.unsleepenemies += 1
		checkenemies()
		
		#$AudioStreamPlayer3D2.play()
		#$Sprite3D.scale.y -= 3.0
		#sleep()

func targetpos(target):
	#$NavigationAgent3D.target_position = target
	await get_tree().create_timer(0.15).timeout
	$NavigationAgent3D.set_target_position(target)

func checkenemies():
	var enemies = get_tree().get_nodes_in_group("unsleep enemy")
	if enemies.size() > 10:
		if Global.unlockachievement(7):
			var ach = get_tree().current_scene.get_node("notification")
			ach.display(Global.achievements[7]["name"],
			Global.achievements[7]["desc"],
			load("res://sprites/icon12.png"))
		
		for i in range(enemies.size() - 10):
			enemies[i].queue_free()

func punching():
	var player: CharacterBody3D = get_tree().get_first_node_in_group("player")
	var direction = (global_position - player.global_position).normalized()
	
	if canpunch:
		if global_position.distance_to(player.global_position) < 2.5:
			canpunch = false
			collision_layer = false
			canmove = false
			velocity = direction * 7.5
			move_and_slide()
			$wha.visible = true
			
			var timer = 0.0
			while timer < 0.3:
				velocity = velocity.lerp(Vector3.ZERO, 0.05)
				move_and_slide()
				await get_tree().create_timer(0.01).timeout
				timer += 0.01
			
			$wha.visible = false
			collision_layer = true
			canmove = true
			$Timer.start()

func _on_timer_timeout() -> void:
	canpunch = true
