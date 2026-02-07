extends Control

var defposbg
var defposlabel
var time: float = 0.0
var esc: bool = false
var r: bool = false
var q: bool = false
var enablesin: bool = true
var tween: Tween


func _ready() -> void:
	tween = create_tween()
	defposbg = $"pause menu".position
	defposlabel = $labels.position
	
	$"../mobilecontrols/escbtn".pressed.connect(escmobile)
	
	if !Global.ismobile:
		$esc.visible = false
		$esc.disabled = false
		$r.visible = false
		$r.disabled = false
		$q.visible = false
		$q.disabled = false
	
	$esc.pressed.connect(escmobile)
	$r.pressed.connect(rmobile)
	$q.pressed.connect(qmobile)
	
	visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ESC") or esc:
		esc = false
		get_tree().paused = not get_tree().paused
		visible = not visible
		$"../gui".visible = not visible
		
		$"pause menu".modulate.a = 0.0
		$labels.position.y = 0.0 - 240.0
		enablesin = false
		
		if tween.is_running(): tween.kill()
		tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_BACK)
		tween.set_parallel(true)
		tween.set_ignore_time_scale(true)
		tween.tween_property($"pause menu", "modulate:a", 0.5, 0.8)
		tween.tween_property($labels, "position:y", defposlabel.y, 0.8)
		await tween.finished
		enablesin = true
	
	if get_tree().paused:
		if event.is_action_pressed("R") or r:
			Global.money = 0
			Global.rerollmarketprice = 10
			
			r = false
			get_tree().paused = false
			get_tree().reload_current_scene()
			
			ScreenTransition.cleanup()
		if event.is_action_pressed("Q") or q:
			Global.money = 0
			Global.rerollmarketprice = 15
			
			q = false
			get_tree().paused = false
			get_tree().change_scene_to_file("res://scenes scripts/menu.tscn")
			
			ScreenTransition.cleanup()

func _process(delta: float) -> void:
	if get_tree().paused and enablesin:
		time += delta
		$"pause menu".position.y = defposbg.y + sin(time) * 15
		$labels.position.y = defposlabel.y - sin(time) * 7.5

func escmobile(): esc = true
func rmobile(): r = true
func qmobile(): q = true
