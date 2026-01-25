extends Node3D


func _ready() -> void:
	rotation.y = randf_range(-180, 180)
	scale = Vector3(1, 1, 1) + Vector3(
		randf_range(-0.25, 1.5),
		randf_range(-0.25, 1.5),
		randf_range(-0.25, 1.5)
	)
	$AnimationPlayer.play(str(randi_range(1, 5)) + "attack")
