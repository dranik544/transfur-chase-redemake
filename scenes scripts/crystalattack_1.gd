extends Node3D


func _ready() -> void:
	rotation.y = randf_range(-180, 180)
	$AnimationPlayer.play(str(randi_range(1, 5)) + "attack")
