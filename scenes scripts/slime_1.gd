extends StaticBody3D

var time: float = 0.0
var n: float = 0.5
@export var speed: float = 2.0

enum TYPE {whiteenemy, blackenemy}
@export var curtype: TYPE = TYPE.whiteenemy

@export var canBeEnemy: bool = true
@export var WhiteEnemyScene: PackedScene = preload("res://scenes scripts/enemy_1.tscn")
@export var blackEnemyScene: PackedScene = preload("res://scenes scripts/enemy_3.tscn")
var enemyScene
@export var slimesprites = {
	1: preload("res://sprites/slime5.png"),
	2: preload("res://sprites/slime6.png"),
	3: preload("res://sprites/slime7.png")
}


func _ready() -> void:
	spawnanim()
	$Sprite3D.texture = slimesprites[randi_range(1, 3)]
	speed = randf_range(1.75, 3.5)
	add_to_group("slime")
	
	match curtype:
		0:
			enemyScene = WhiteEnemyScene
			$Sprite3D.modulate = Color(1.0, 1.0, 1.0)
		1:
			enemyScene = blackEnemyScene
			$Sprite3D.modulate = Color(0.100, 0.100, 0.100)

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

func spawnanim():
	var basescale: Vector3 = $Sprite3D.scale
	$Sprite3D.scale = Vector3.ZERO
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property($Sprite3D, "scale", basescale, 0.8)

func _on_timer_timeout() -> void:
	if canBeEnemy:
		var tween = create_tween()
		var enemy = enemyScene.instantiate()
		get_parent().add_child(enemy)
		enemy.exitfromvent()
		enemy.global_position = global_position + Vector3(0, 0.8, 0)
		tween.set_ease(Tween.EASE_IN)
		tween.set_trans(Tween.TRANS_ELASTIC)
		tween.tween_property($Sprite3D, "scale", Vector3.ZERO, randf_range(1.5, 2.5))
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
