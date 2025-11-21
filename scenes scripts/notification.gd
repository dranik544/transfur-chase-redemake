extends MarginContainer

var queue = []
var isshowing = false


func _ready() -> void:
	visible = false

func display(title: String, desc: String, image: Texture = null, timeshowing: float = 5):
	queue.append([title, desc, image, timeshowing])
	
	if isshowing:
		return
	
	shownext()

func shownext():
	if queue.size() == 0:
		return
	
	var notification = queue[0]
	queue.remove_at(0)
	
	isshowing = true
	visible = true
	
	size = Vector2.ZERO
	
	$MarginContainer/VBoxContainer/Label.text = notification[0]
	$MarginContainer/VBoxContainer/Label2.text = notification[1]
	if notification[2]:
		$MarginContainer2/TextureRect.texture = notification[2]
	
	position = Vector2(-size.x - 10, 10)
	var tween = create_tween()
	tween.tween_property(self, "position:x", 10, 0.5)
	await tween.finished
	
	await get_tree().create_timer(notification[3]).timeout
	
	tween = create_tween()
	tween.tween_property(self, "position:x", -size.x - 10, 0.5)
	await tween.finished
	
	visible = false
	isshowing = false
	
	shownext()
