extends StaticBody3D

var time: float = 0.0
var n: float = 0.5
@export var speed: float = 2.0
@export var canBeEnemy: bool = true
@export var enemyScene: PackedScene = preload("res://scenes scripts/enemy_1.tscn")
@export var slimesprites = {
	1: preload("res://sprites/slime5.png"),
	2: preload("res://sprites/slime6.png"),
	3: preload("res://sprites/slime7.png")
}


func _ready() -> void:
	$Sprite3D.texture = slimesprites[randi_range(1, 3)]
	speed = randf_range(1.75, 3.5)
	add_to_group("slime")

func _process(delta):
	time += delta
	n = lerp(n, speed, 1 * delta)
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


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		if !body.isslide:
			body.minushealth(0.5)
			body.speed -= randf_range(5, 6)
			touched()
			
			body.oneshot = false
			
			body.startshake(20, 0.05)
