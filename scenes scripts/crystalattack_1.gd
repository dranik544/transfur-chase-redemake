extends Node3D

var canplayerpos: bool = true


func _ready() -> void:
	$disableplayerpos.timeout.connect(func(): canplayerpos = false)
	
	rotation.y = randf_range(-180, 180)
	var randscale = randf_range(-0.25, 0.5)
	scale = Vector3(1, 1, 1) + Vector3(
		randscale,
		randscale,
		randscale
	)
	$AnimationPlayer.play(str(randi_range(1, 5)) + "attack")

func _process(delta: float) -> void:
	if !get_tree(): return
	
	if canplayerpos: global_position = Vector3(
		get_tree().get_first_node_in_group("player").global_position.x,
		0,
		get_tree().get_first_node_in_group("player").global_position.z
	)
