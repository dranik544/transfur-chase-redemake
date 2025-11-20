extends MarginContainer

var tween = create_tween()
@export var typingspeed: int = 25
var typingtime: float = 0.2


func settext(dtext: String):
	if tween:
		tween.kill()
	
	$MarginContainer/Label.text = dtext
	
	size = Vector2(0.0, 0.0)
	$MarginContainer/Label.visible_ratio = 0.0
	#global_position.x -= size.x / 2
	#global_position.y -= size.y + 24
	
	typingtime = 0.2 + dtext.length() / typingspeed
	
	tween = create_tween()
	tween.tween_property($MarginContainer/Label, "visible_ratio", 1.0, typingtime)

func _process(delta: float) -> void:
	$NinePatchRect/TextureRect.global_position.x = clampf($NinePatchRect/TextureRect.global_position.x, 
		global_position.x + size.x / 2,
		global_position.x + size.x / 2,
	)
