extends Control

var maxfps: int = 30


func _ready() -> void:

func _process(delta: float) -> void:
	var fps: int = int(Engine.get_frames_per_second())
	var fpscolor
	if maxfps < fps:
		maxfps = fps
	
	if fps > maxfps - 10: fpscolor = "#d1ffd1"
	elif fps > maxfps / 2: fpscolor = "#ffffff"
	elif fps < maxfps / 2: fpscolor = "#fff5cc"
	elif fps < maxfps / 4: fpscolor = "#ffa6a6"
	
	$label.text = "\n     Current FPS: " + "[wave]" + "[color=" + str(fpscolor) + "]" + str(fps)
