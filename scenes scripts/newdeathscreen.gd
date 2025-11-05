extends Node2D

var time: float = 0.0


func _ready():
	$label.text = "бр бр патапим
	
	сломано коробок: " + str(Global.brokenboxes) + "
	выломано дверей: " + str(Global.brokendoors) + "
	тронуто луж: " + str(Global.touchedslimes) + "
	
	итого: " + str(Global.brokendoors + Global.brokendoors + Global.touchedslimes)

func _process(delta):
	time += delta
	
	
	if Input.is_action_just_pressed("SPACE") or Input.is_action_just_pressed("R"):
		get_tree().change_scene_to_file("res://scenes scripts/world.tscn")
	if Input.is_action_just_pressed("ESC") or Input.is_action_just_pressed("Q"):
		get_tree().change_scene_to_file("res://scenes scripts/menu.tscn")
	
	
	$slime.position = Vector2(0.0, 0.0) + Vector2(
		sin(time) * 10, #randf_range(-1, 1),
		sin(time / 2) * 10 #randf_range(-1, 1)
	)
	$slime.modulate = Color(1.0, 1.0, 1.0, 0.75 + sin(time) * 0.2)
	$slime.rotation = sin(time * 2.0) * 0.02
	$slime.scale = lerp($slime.scale, Vector2(1.1, 1.1), 5 * delta)
	
	$bg2.modulate = lerp($bg2.modulate, Color(1.0, 1.0, 1.0, 0.0), 0.5 * delta)
	
	$colin.position = Vector2(-155.0, 7.0) + Vector2(
		sin(time * 4) * 4,
		sin(time * 2) * 4
	)
	$label.position = Vector2(320.0, 0.0) + Vector2(
		sin(time * 4) * 4/2,
		sin(time * 2) * 4/2
	)
	
	$colin.scale = Vector2(1.0, 1.0) + Vector2(
		0.0,
		sin(time) * 0.025
	)
	$ColorRect.scale = Vector2(1.0, 0.9) + Vector2(
		0.0,
		sin(time) * 0.1
	)
	
	$colin.rotation = 0.0 + sin(time) * 0.025
	$label.rotation = 0.0 + sin(time) * 0.025/2
