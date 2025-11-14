extends StaticBody3D

var isopen = false
@export var enemyScene: PackedScene = preload("res://scenes scripts/enemy_1.tscn")
@export var item2Scene: PackedScene = preload("res://scenes scripts/item_2.tscn")
@export var smallEnemyScene: PackedScene = preload("res://scenes scripts/small_enemy_1.tscn")


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		if !isopen:
			$AnimationPlayer.play("open")
			$open.play()
			if $CollisionShape3D:
				$CollisionShape3D.queue_free()
			
			var randomitem = randi_range(1, 3)
			match randomitem:
				1:
					var obj: CharacterBody3D = enemyScene.instantiate()
					get_parent().add_child(obj)
					obj.set_physics_process(false)
					var tween = create_tween()
					obj.global_position = global_position
					tween.tween_property(obj, "global_position:y", 0.8, 1.0)
					await tween.finished
					obj.set_physics_process(true)
					obj.exitfromvent()
					#enemy.global_position = global_position + Vector3(0, 0.8, 0)
				2:
					var obj: RigidBody3D = item2Scene.instantiate()
					get_parent().add_child(obj)
					var tween = create_tween()
					obj.global_position = global_position
					tween.tween_property(obj, "global_position:y", 0.4, 1.0)
					#item.global_position = global_position + Vector3(0, 0.4, 0)
				3:
					var obj: CharacterBody3D = smallEnemyScene.instantiate()
					get_parent().add_child(obj)
					obj.set_physics_process(false)
					var tween = create_tween()
					obj.global_position = global_position - Vector3(0, 1.0, 0)
					tween.tween_property(obj, "global_position:y", 0.1, 1.0)
					await tween.finished
					obj.set_physics_process(true)
					#enemy.global_position = global_position + Vector3(0, 0.8, 0)
			
			isopen = true
