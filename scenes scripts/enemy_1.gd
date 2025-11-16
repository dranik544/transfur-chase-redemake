extends CharacterBody3D

@export var speed = 3.5
var canmove: bool = false
var curspeed = 3.5
var speeddist = 0.0
var hasentered = false


func _ready():
	add_to_group("enemy")
	$Area3D.body_entered.connect(areaplayerentered)
	
	if Global.iswinter:
		$Sprite3D.sprite_frames = load("res://skins/newyear_enemy_sprite.tres")

func _physics_process(delta):
	var nextloc = $NavigationAgent3D.get_next_path_position()
	var curloc = global_transform.origin
	var newvelocity = (nextloc - curloc).normalized() * curspeed
	var player: CharacterBody3D = get_tree().get_first_node_in_group("player")
	
	targetpos(player.global_transform.origin)
	
	speeddist = 0.0 + global_position.distance_to(player.global_position) / 50
	speeddist = clampf(speeddist, 0.0, 10.0)
	
	if velocity.length() > 0:
		$Sprite3D.play("run")
		if velocity.x > 0:
			$Sprite3D.flip_h = false
		elif velocity.x < 0:
			$Sprite3D.flip_h = true
	
	#if $RayCast3D.is_colliding():
		#speed = 1.5
	#else:
		#speed = 3.5
	
	if global_position.y != 0.9:
		global_position.y = 0.9
	curspeed = lerp(curspeed, speed + speeddist, 2 * delta)
	if canmove:
		velocity = velocity.move_toward(newvelocity, 0.5)
	move_and_slide()

func exitfromvent():
	canmove = true
	hasentered = true

func areaplayerentered(body):
	if body.is_in_group("player") and !hasentered:
		hasentered = true
		$AnimationPlayer.play("its colin!")
		await $AnimationPlayer.animation_finished
		canmove = true

func targetpos(target):
	#$NavigationAgent3D.target_position = target
	$NavigationAgent3D.set_target_position(target)
