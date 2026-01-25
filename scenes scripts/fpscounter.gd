extends Control

var maxfps: int = 0


func _ready() -> void:
	visible = Global.settings["fpscounter"]

func _process(delta: float) -> void:
	var fps: int = int(Engine.get_frames_per_second())
	var fpscolor
	if maxfps < fps:
		maxfps = fps
	 
	if fps > maxfps - 10: fpscolor = "#9fff8a"
	elif fps > maxfps / 2: fpscolor = "#ffffff"
	elif fps < maxfps / 2: fpscolor = "#ffed8a"
	elif fps < maxfps / 4: fpscolor = "#ff8787"
	
	$label.text = "\n     Current FPS: " + "[color=" + str(fpscolor) + "]" + str(fps)
