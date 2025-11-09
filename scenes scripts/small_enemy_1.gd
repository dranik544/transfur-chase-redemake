extends CharacterBody3D

@export var speed = 2.5


func _ready():
	add_to_group("small enemy")
	velocity = Vector3.FORWARD * speed

func _physics_process(delta):
	move_and_slide()
	
	if get_slide_collision_count() > 0:
		speed = randf_range(1.0, 4.0)
		velocity = Vector3(randf_range(-1, 1), 0, randf_range(-1, 1)).normalized() * speed
