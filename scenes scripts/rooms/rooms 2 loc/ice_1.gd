extends StaticBody3D


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		if !body.isslide:
			body.speedlerp = 1.0
			body.velocitylerp = 1.5

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		if !body.isslide:
			body.speedlerp = 5.0
			body.velocitylerp = 9.0
