extends StaticBody3D

var items = [
	{"name": "heal", "price": 50, "scene": preload("res://scenes scripts/item_2.tscn")}
]
var playerin: bool = false


func _ready() -> void:
	$Area3D.body_entered.connect(bodyentered)
	$Area3D.body_exited.connect(bodyexited)
	$CanvasLayer/NinePatchRect/exit.pressed.connect(exit)
	
	$CanvasLayer/NinePatchRect.modulate.a = 0.0

func bodyentered(body):
	if body.is_in_group("player"):
		playerin = true
		Engine.time_scale = 0.05
		var tween = create_tween()
		tween.set_ignore_time_scale(true)
		tween.tween_property($CanvasLayer/NinePatchRect, "modulate:a", 1.0, 0.25)

func bodyexited(body):
	if body.is_in_group("player"):
		exit()

func exit():
	playerin = false
	Engine.time_scale = 1.0
	var tween = create_tween()
	tween.set_ignore_time_scale(true)
	tween.tween_property($CanvasLayer/NinePatchRect, "modulate:a", 0.0, 0.25)
