extends Node2D

var time: float = 0.0


func _ready():
	var points: int = Global.brokenboxes + Global.brokendoors + Global.touchedslimes + Global.hitsfromenemies + Global.openvents + Global.useditems + Global.unsleepenemies
	
	Global.generalstats[0] += Global.brokenboxes
	Global.generalstats[1] += Global.brokendoors
	Global.generalstats[2] += Global.touchedslimes
	Global.generalstats[3] += Global.hitsfromenemies
	Global.generalstats[4] += Global.openvents
	Global.generalstats[5] += Global.useditems
	Global.generalstats[6] += Global.unsleepenemies
	SavingManager.save("generalstats", Global.generalstats)
	
	if points > Global.recordpoints:
		Global.recordpoints = points
		
		$notification.display("новый рекорд!", "поздравляю, вы побили свой
		прошлый рекорд! он будет
		записан во вкладке Статистики.", load("res://sprites/icon11.png"), 7)
	
	$label.text = "ты сдулся!
	
	сломано коробок: " + str(Global.brokenboxes) + "
	выломано дверей: " + str(Global.brokendoors) + "
	тронуто луж: " + str(Global.touchedslimes) + "
	получил лещей: " + str(Global.hitsfromenemies) + "
	открыто люков: " + str(Global.openvents) + "
	использовано предметов: " + str(Global.useditems) + "
	пробуждено врагов: " + str(Global.unsleepenemies) + "
	
	итого: " + str(points) + "
	лучший рекорд: " + str(SavingManager.load("recordpoints"))
	
	SavingManager.save("recordpoints", Global.recordpoints)

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
