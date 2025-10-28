extends StaticBody3D

var isopen = false
@export var enemyScene: PackedScene = preload("res://scenes scripts/enemy_1.tscn")
@export var item1Scene: PackedScene = preload("res://scenes scripts/item_1.tscn")


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		if !isopen:
			$AnimationPlayer.play("open")
			
			var randomitem = randi_range(1, 2)
			match randomitem:
				1:
					var enemy: CharacterBody3D = enemyScene.instantiate()
					get_parent().add_child(enemy)
					enemy.set_physics_process(false)
					var tween = create_tween()
					enemy.global_position = global_position
					tween.tween_property(enemy, "global_position:y", 0.8, 1.0)
					await tween.finished
					enemy.set_physics_process(true)
					#enemy.global_position = global_position + Vector3(0, 0.8, 0)
				2:
					var item: RigidBody3D = item1Scene.instantiate()
					get_parent().add_child(item)
					var tween = create_tween()
					item.global_position = global_position
					tween.tween_property(item, "global_position:y", 0.4, 1.0)
					#item.global_position = global_position + Vector3(0, 0.4, 0)
			
			isopen = true
