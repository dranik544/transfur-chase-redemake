extends Node

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
	get_tree().change_scene_to_file(scenepath)
	
	await get_tree().create_timer(0.05).timeout
	canvas.queue_free()
