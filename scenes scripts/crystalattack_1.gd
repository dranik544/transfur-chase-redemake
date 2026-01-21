extends Node3D


func _ready() -> void:
	rotation.y = randf_range(-90, 90)
	$AnimationPlayer.play(str(randi_range(1, 1)) + "attack")
