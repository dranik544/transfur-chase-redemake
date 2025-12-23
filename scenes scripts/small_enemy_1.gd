extends CharacterBody3D

@export var speed = 2.5
enum TYPE {smalllatex, robotpilesos}
@export var curtype: TYPE = TYPE.smalllatex
@export var canmove: bool = true
var robotdirections = [
	Vector3.FORWARD,
	Vector3.FORWARD + Vector3.RIGHT,
	Vector3.RIGHT,
	Vector3.BACK + Vector3.RIGHT,
	Vector3.BACK,
	Vector3.BACK + Vector3.LEFT,
	Vector3.LEFT,
	Vector3.FORWARD + Vector3.LEFT
]

func _ready():
	add_to_group("small enemy")
	if canmove:
		if curtype == TYPE.robotpilesos:
			velocity = robotdirections[randi() % robotdirections.size()].normalized() * speed
		else:
			velocity = Vector3.FORWARD * speed

func _physics_process(delta):
	if canmove:
		move_and_slide()
		
		if get_slide_collision_count() > 0:
			match curtype:
				TYPE.smalllatex:
					speed = randf_range(1.5, 5.0)
					velocity = Vector3(randf_range(-1, 1), 0, randf_range(-1, 1)).normalized() * speed
				
				TYPE.robotpilesos:
					velocity = Vector3.ZERO
					#create_tween().tween_property($mesh1, "rotation:y", $mesh1.rotation.y + randf_range(-90, 90), 0.5)
					await get_tree().create_timer(randf_range(0.5, 1.0)).timeout
					speed = randf_range(0.75, 1.0)
					var randomdirection = robotdirections[randi() % robotdirections.size()]
					velocity = randomdirection.normalized() * speed

func robotbroke():
	$effect1.play()
	canmove = false
	$CollisionShape3D.disabled = true
