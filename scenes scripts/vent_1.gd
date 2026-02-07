extends StaticBody3D

var isopen = false

@export var dropitems = [
	preload("res://scenes scripts/enemy_1.tscn"),
	preload("res://scenes scripts/item_2.tscn"),
	preload("res://scenes scripts/item_3.tscn"),
	preload("res://scenes scripts/item_4.tscn"),
	preload("res://scenes scripts/small_enemy_1.tscn"),
]
#@export var enemyScene: PackedScene = preload("res://scenes scripts/enemy_1.tscn")
#@export var item2Scene: PackedScene = preload("res://scenes scripts/item_2.tscn")
#@export var item3Scene: PackedScene = preload("res://scenes scripts/item_3.tscn")
#@export var item4Scene: PackedScene = preload("res://scenes scripts/item_4.tscn")
#@export var smallEnemyScene: PackedScene = preload("res://scenes scripts/small_enemy_1.tscn")


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		if !isopen:
			$AnimationPlayer.play("open")
			$open.play()
			if $CollisionShape3D:
				$CollisionShape3D.queue_free()
			
			var random = randi_range(1, 3)
			
			match random:
				1: enemy()
				2: item()
				3: smallenemy()
					#enemy.global_position = global_position + Vector3(0, 0.8, 0)
			
			Global.openvents += 1
			isopen = true

func enemy():
	
	
	var obj: CharacterBody3D = dropitems[0].instantiate()
	
	
	get_parent().add_child(obj)
	obj.set_physics_process(false)
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SPRING)
	obj.global_position = global_position
	tween.tween_property(obj, "global_position:y", 0.8, 1.0)
	await tween.finished
	obj.set_physics_process(true)
	obj.exitfromvent()

func smallenemy():
	
	
	var obj: CharacterBody3D = dropitems[4].instantiate()
	
	
	get_parent().add_child(obj)
	obj.set_physics_process(false)
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SPRING)
	obj.global_position = global_position - Vector3(0, 1.0, 0)
	tween.tween_property(obj, "global_position:y", 0.1, 1.0)
	await tween.finished
	obj.set_physics_process(true)

func item():
	
	
	var obj: RigidBody3D = dropitems[randi_range(1, 3)].instantiate()
	
	
	get_parent().add_child(obj)
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SPRING)
	obj.global_position = global_position
	tween.tween_property(obj, "global_position:y", 0.4, 1.0)
	#item.global_position = global_position + Vector3(0, 0.4, 0)
