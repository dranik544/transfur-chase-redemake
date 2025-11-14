extends StaticBody3D

var time: float = 0.0
var n: float = 0.5
@export var canBeEnemy: bool = true
@export var enemyScene: PackedScene = preload("res://scenes scripts/enemy_1.tscn")


func _process(delta):
	time += delta
	n = lerp(n, 2.0, 1 * delta)
	$Sprite3D.scale = Vector3(4.0, 0, 4.0) + Vector3(
		sin(time * n) * 0.5,
		1,
		sin(time * n / 2) * 0.5
	)

func touched():
	Global.touchedslimes -= 1
	n += randf_range(10.0, 12.5)
	$Timer.start(randf_range(2.0, 3.0))
	
	$touched.play()

func _on_timer_timeout() -> void:
	if canBeEnemy:
		var tween = create_tween()
		var enemy = enemyScene.instantiate()
		get_parent().add_child(enemy)
		enemy.exitfromvent()
		enemy.global_position = global_position + Vector3(0, 0.8, 0)
		tween.tween_property($Sprite3D, "scale", Vector3(0.0, 0.0, 0.0), randf_range(0.5, 2.0))
		await tween.finished
		queue_free()
