extends Area3D

var time: float = 0.0
@export var randomSpawn: bool = true
@export var chanceSpawn: int = 5
@export var biggerHitbox: bool = false
var t: float = 4
@export var enableMoreMandarins: bool = true
@export var chanceMoreMandarins: int = 35
@export var numMoreMandarins: int = 12
var ismore: bool = false


func _ready() -> void:
	if randomSpawn:
		var random = randi() % chanceSpawn
		if random != 0:
			queue_free()
			return
	
	if enableMoreMandarins:
		var random = randi() % chanceMoreMandarins
		if random == 0:
			$Sprite3D.texture = load("res://sprites/mandarin2.png")
			ismore = true
	
	if biggerHitbox:
		$CollisionShape3D.shape.radius = 1.25
	
	t = randf_range(3, 6)
	
	body_entered.connect(bodyentered)

func _process(delta: float) -> void:
	time += delta
	if $Sprite3D:
		$Sprite3D.position.y = 0.0 + sin(time * t) * 0.1

func bodyentered(body):
	if body.is_in_group("player"):
		if ismore:
			Global.money += randi_range(numMoreMandarins - 3, numMoreMandarins + 3)
		else:
			Global.money += randi_range(1, 2)
		$AudioStreamPlayer3D.play()
		create_tween().tween_property($Sprite3D, "scale", Vector3.ZERO, 0.25)
		await get_tree().create_timer(0.65).timeout
		queue_free()
