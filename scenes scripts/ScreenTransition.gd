extends Node

@export var cleanup_enabled: bool = true
@export var groups_to_cleanup: Array[String] = ["enemy", "unsleep enemy", "rooms", "broke", "door", "navi", "world", "world"]


func changescene(scenepath: String, fadecolor: Color = Color.BLACK, time: float = 0.5):
	var canvas = CanvasLayer.new()
	canvas.layer = 99
	canvas.follow_viewport_enabled = true
	
	var rect = ColorRect.new()
	rect.color = fadecolor
	rect.color.a = 0.0
	
	rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	
	canvas.add_child(rect)
	get_tree().root.add_child(canvas)
	
	await get_tree().process_frame
	
	var tween = create_tween()
	tween.tween_property(rect, "color:a", 1.0, time)
	await tween.finished
	get_tree().paused = false
	
	var newscene = load(scenepath).instantiate()
	
	if get_tree():
		if get_tree().current_scene:
			get_tree().current_scene.queue_free()
		
		get_tree().root.add_child(newscene)
		get_tree().current_scene = newscene
	
	canvas.queue_free()

func cleanup():
	for group in groups_to_cleanup:
		var nodes = get_tree().get_nodes_in_group(group)
		for node in nodes:
			if is_instance_valid(node):
				node.queue_free()
	
	var players = get_tree().get_nodes_in_group("player")
	for player in players:
		if is_instance_valid(player):
			player.queue_free()
			player.remove_from_group("player")
	
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
