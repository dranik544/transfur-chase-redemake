extends StaticBody3D

var isopen = false
@export var enemyscene: PackedScene = preload("res://scenes scripts/enemy_1.tscn")


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		if !isopen:
			$AnimationPlayer.play("open")
			
			#var enemy: CharacterBody3D = enemyscene.instantiate()
			#add_child(enemy)
			#enemy.global_position = Vector3(
				#global_position.x,
				#1.5,
				#global_position.y
			#)
			
			isopen = true
