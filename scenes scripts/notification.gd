extends CanvasLayer

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
	
	$notification/MarginContainer/VBoxContainer/Label.text = notification[0]
	$notification/MarginContainer/VBoxContainer/Label2.text = notification[1]
	if notification[2]:
		$notification/MarginContainer2/TextureRect.texture = notification[2]
	
	$notification.size = Vector2.ZERO
	
	$notification.position = Vector2(-$notification.size.x - 10, 10)
	var tween = create_tween()
	tween.tween_property($notification, "position:x", 10, 0.5)
	await tween.finished
	
	await get_tree().create_timer(notification[3]).timeout
	
	tween = create_tween()
	tween.tween_property($notification, "position:x", -$notification.size.x - 10, 0.5)
	await tween.finished
	
	visible = false
	isshowing = false
	
	shownext()
