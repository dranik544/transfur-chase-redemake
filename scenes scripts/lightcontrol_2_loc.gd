extends Node


var onoff: bool = false #false = off, true = on

var enemies
var worldlight
var lights
var music

func _ready() -> void:
	if !get_tree(): return
	updategroups()
	
	$Timer.timeout.connect(beforetimeout)

func updategroups():
	if !get_tree(): return
	lights = get_tree().get_nodes_in_group("light")
	enemies = get_tree().get_nodes_in_group("enemy")
	if !worldlight:
		worldlight = get_tree().get_first_node_in_group("worldlight")
	if !music:
		music = get_tree().get_first_node_in_group("music")

func timeout():
	if !get_tree(): return
	onoff = not onoff
	
	updategroups()
	
	if lights.size() > 0:
		for i in lights:
			i.visible = onoff
	if enemies.size() > 0:
		for i in enemies:
			if i.curtype == i.TYPE.blackenemy: i.enablearea(not onoff)
	if worldlight: worldlight.visible = onoff
	if music:
		if onoff: music.volume_db -= 6.5
		if !onoff: music.volume_db = Global.settings["musicvolume"] / 10
	
	if onoff: $AudioStreamPlayer.pitch_scale = 1.0
	if !onoff: $AudioStreamPlayer.pitch_scale = 0.7
	$AudioStreamPlayer.play()

func beforetimeout():
	if !get_tree(): return
	updategroups()
	
	for i in randi_range(25, 30):
		if lights and worldlight:
			for l in lights: l.visible = not l.visible
			worldlight.visible = not worldlight.visible
			
			await get_tree().create_timer(randi_range(0.1, 0.2)).timeout
	
	$Timer.wait_time = randf_range(2, 6)
	timeout()
