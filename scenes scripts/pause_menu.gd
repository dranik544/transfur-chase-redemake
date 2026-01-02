extends Control

var defposbg
var defposlabel
var time: float = 0.0


func _ready() -> void:
	defposbg = $"pause menu".position
	defposlabel = $labels.position
	visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ESC"):
		get_tree().paused = not get_tree().paused
		visible = not visible
		$"../gui".visible = not visible
	
	if get_tree().paused:
		if event.is_action_pressed("R"):
			get_tree().paused = false
			get_tree().reload_current_scene()
			
			ScreenTransition.cleanup()
		if event.is_action_pressed("Q"):
			get_tree().paused = false
			get_tree().change_scene_to_file("res://scenes scripts/menu.tscn")
			
			ScreenTransition.cleanup()

func _process(delta: float) -> void:
	if get_tree().paused:
		time += delta
		$"pause menu".position.y = defposbg.y + sin(time) * 15
		$labels.position.y = defposlabel.y - sin(time) * 7.5
