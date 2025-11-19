extends MarginContainer

var tween = create_tween()
var typingtime: float = 1.0


func settext(dtext: String):
	if tween:
		tween.kill()
	
	$MarginContainer/Label.text = dtext
	
	$MarginContainer/Label.visible_ratio = 0.0
	size = Vector2(0.0, 0.0)
	#global_position.x -= size.x / 2
	#global_position.y -= size.y + 24
	
	typingtime = dtext.length() / 20
	
	tween = create_tween()
	tween.tween_property($MarginContainer/Label, "visible_ratio", 1.0, typingtime)
