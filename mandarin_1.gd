extends Area3D

var time: float = 0.0
@export var randomSpawn: bool = true
@export var chanceSpawn: int = 5


func _ready() -> void:
	if randomSpawn:
		var random = randi() % chanceSpawn
		if random != 0:
			queue_free()
	
	body_entered.connect(bodyentered)

func _process(delta: float) -> void:
	time += delta
	$Sprite3D.position.y = 0.0 + sin(time * 4) * randf_range(0.05, 0.1)

func bodyentered(body):
	Global.money += randi_range(1, 2)
	$AudioStreamPlayer3D.play()
	create_tween().tween_property($Sprite3D, "scale", Vector3.ZERO, 0.25)
	await get_tree().create_timer(0.65).timeout
	queue_free()
