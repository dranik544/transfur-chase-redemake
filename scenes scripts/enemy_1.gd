extends CharacterBody3D

@export var speed = 3.5


func _ready():
	add_to_group("enemy")

func _physics_process(delta):
	var nextloc = $NavigationAgent3D.get_next_path_position()
	var curloc = global_transform.origin
	var newvelocity = (nextloc - curloc).normalized() * speed
	
	if velocity.length() > 0:
		$Sprite3D.play("run")
		if velocity.x > 0:
			$Sprite3D.flip_h = false
		elif velocity.x < 0:
			$Sprite3D.flip_h = true
	
	targetpos(get_tree().get_first_node_in_group("player").global_transform.origin)
	
	velocity = velocity.move_toward(newvelocity, 0.5)
	move_and_slide()

func targetpos(target):
	$NavigationAgent3D.target_position = target
