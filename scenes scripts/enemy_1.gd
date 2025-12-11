extends CharacterBody3D

@export var speed = 4.75
@export var nerf = 3.0
@export var randomspawn = 0
@export var ismimic = false
enum TYPE {whiteenemy, blackenemy}
@export var curtype: TYPE = TYPE.whiteenemy

var canpunch = true
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
var playerinarea = false

@export var health: float = 5.0
var curhealth: float = 5.0

enum STATE {SLEEP, ACTIVE, PUNCH, STUNNED}
var curstate: STATE = STATE.SLEEP

func _ready():
	add_to_group("enemy")
	$Area3D.body_entered.connect(areaplayerentered)
	$Area3D.body_exited.connect(areaplayerexited)
	Global.punchpl.connect(punching)
	$Timer.timeout.connect(timertimeout)
	
	if randomspawn != 0 and randi_range(0, randomspawn) != randomspawn:
		queue_free()
	
	if curtype == TYPE.blackenemy:
		isfemale = randi_range(1, 2) == 2
		if isfemale:
			$Sprite3D.sprite_frames = load("res://skins/enemy_female__2_loc_sprite.tres")
	
	if Global.iswinter and !ismimic:
		runanim = "run newyear"
		sleepanim = "sleep newyear"
	
	if $Timer: $Timer.wait_time = 4.0
	curhealth = health
	
	curstate = STATE.SLEEP
	if $Sprite3D.sprite_frames.has_animation(sleepanim):
		$Sprite3D.play(sleepanim)
	velocity = Vector3.ZERO

func _physics_process(delta):
	if !get_tree(): return
	var player = get_tree().get_first_node_in_group("player")
	if !player:
		return
	
	match curstate:
		STATE.SLEEP:
			velocity = Vector3.ZERO
			if $Sprite3D.sprite_frames.has_animation(sleepanim):
				$Sprite3D.play(sleepanim)
			
			if playerinarea and player.velocity.length() > 2.1:
				curstate = STATE.ACTIVE
				$AnimationPlayer.play("its colin!")
				await $AnimationPlayer.animation_finished
				add_to_group("unsleep enemy")
				Global.unsleepenemies += 1
				checkenemies()
				canpunch = true
		
		STATE.ACTIVE:
			var playerdist = global_position.distance_to(player.global_position)
			
			speeddist = clampf(0.0 + playerdist / nerf, 0.0, 25.0)
			if playerdist / nerf > 32.5:
				queue_free()
			
			var nextloc = $NavigationAgent3D.get_next_path_position()
			var curloc = global_transform.origin
			var newvelocity = (nextloc - curloc).normalized() * curspeed
			
			velocity = velocity.move_toward(newvelocity, 0.5)
			
			if velocity.length() > 0:
				$Sprite3D.flip_h = velocity.x < 0
				$Sprite3D.speed_scale = velocity.length() / 5
			else:
				$Sprite3D.speed_scale = 1.0
			
			if $Sprite3D.sprite_frames.has_animation(runanim):
				$Sprite3D.play(runanim)
			
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
					curstate = STATE.SLEEP
					remove_from_group("unsleep enemy")
					playerinarea = false
					if $Sprite3D.sprite_frames.has_animation(sleepanim):
						$Sprite3D.play(sleepanim)
					velocity = Vector3.ZERO
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
			
			curspeed = lerp(curspeed, speed + speeddist, 3 * delta)
			
			targetpos(player.global_transform.origin)
		
		STATE.PUNCH:
			velocity = velocity.lerp(Vector3.ZERO, 0.1 * delta * 60)
			$wha.visible = true
			
			if velocity.length() < 0.5:
				curstate = STATE.ACTIVE
				$wha.visible = false
				if ismimic:
					set_collision_layer_value(4, true)
				else:
					set_collision_layer_value(2, true)
					set_collision_mask_value(2, true)
				
				$Timer.start()
		
		STATE.STUNNED:
			velocity = Vector3.ZERO
	
	if curstate != STATE.STUNNED:
		if global_position.y != 0.9:
			global_position.y = 0.9
	
	move_and_slide()

func punching(damage: float):
	if !get_tree() or !canpunch or curstate == STATE.STUNNED or curstate == STATE.SLEEP:
		return
	
	var player = get_tree().get_first_node_in_group("player")
	if !player or global_position.distance_to(player.global_position) > 2.5:
		return
	
	curstate = STATE.PUNCH
	canpunch = false
	
	set_collision_layer_value(2, false)
	set_collision_layer_value(4, false)
	set_collision_mask_value(2, false)
	set_collision_mask_value(4, false)
	
	var direction = (global_position - player.global_position).normalized()
	velocity = direction * 8.5
	
	$wha.visible = true
	if $punch:
		$punch.play()
	if $effect1:
		$effect1.play()
	
	if player:
		player.startshake(15, 0.2)
	
	curhealth -= damage
	
	if curhealth <= 0:
		stunn()
	
	var timer = 0.0
	while timer < 0.3:
		velocity = velocity.lerp(Vector3.ZERO, 0.05)
		move_and_slide()
		if get_tree():
			await get_tree().create_timer(0.01).timeout
		timer += 0.01
	
	if curhealth > 0:
		curstate = STATE.ACTIVE
		targetpos(player.global_transform.origin)

func stunn():
	if not ismimic:
		set_collision_layer_value(2, false)
		set_collision_mask_value(2, false)
	
	curstate = STATE.STUNNED
	remove_from_group("unsleep enemy")
	$Sprite3D.billboard = BaseMaterial3D.BILLBOARD_DISABLED
	$Sprite3D.rotation.x = deg_to_rad(-90.0)
	$Sprite3D.rotation.y = deg_to_rad(randf_range(-180, 180))
	$Sprite3D.stop()
	$Sprite3D.position.y = randf_range(-0.6, -0.7)

func areaplayerentered(body):
	if body.is_in_group("player"):
		playerinarea = true

func areaplayerexited(body):
	if body.is_in_group("player"):
		playerinarea = false
		if curstate == STATE.SLEEP:
			pass
		elif curstate == STATE.ACTIVE:
			var player = get_tree().get_first_node_in_group("player")
			if player and global_position.distance_to(player.global_position) > 10.0:
				curstate = STATE.SLEEP
				remove_from_group("unsleep enemy")
				if $Sprite3D.sprite_frames.has_animation(sleepanim):
					$Sprite3D.play(sleepanim)
				velocity = Vector3.ZERO

func targetpos(target):
	$NavigationAgent3D.set_target_position(target)

func exitfromvent():
	curstate = STATE.ACTIVE
	add_to_group("unsleep enemy")
	canpunch = true
	$AnimationPlayer.play("RESET")
	checkenemies()

func checkenemies():
	var enemies = get_tree().get_nodes_in_group("unsleep enemy")
	if enemies.size() > 10:
		if Global.unlockachievement(7):
			var ach = get_tree().current_scene.get_node("notification")
			ach.display(Global.achievements[7]["name"], Global.achievements[7]["desc"], load("res://sprites/icon12.png"))
		
		for i in range(enemies.size() - 10):
			if i < enemies.size():
				enemies[i].queue_free()

func timertimeout():
	canpunch = true
