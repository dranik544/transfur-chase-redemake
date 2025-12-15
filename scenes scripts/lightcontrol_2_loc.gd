extends Node


var onoff: bool = false #false = off, true = on

var enemies
var worldlight
var lights
var music

func _ready() -> void:
	if !get_tree(): return
	worldlight = get_tree().get_first_node_in_group("worldlight")
	music = get_tree().get_first_node_in_group("music")
	enemies = get_tree().get_nodes_in_group("enemy")
	lights = get_tree().get_nodes_in_group("light")
	
	$Timer.timeout.connect(timeout)

func timeout():
	if !get_tree(): return
	onoff = not onoff
	
	lights = get_tree().get_nodes_in_group("light")
	enemies = get_tree().get_nodes_in_group("enemy")
	if !worldlight:
		worldlight = get_tree().get_first_node_in_group("worldlight")
	if !music:
		music = get_tree().get_first_node_in_group("music")
	
	if lights.size() > 0:
		for i in lights:
			i.visible = onoff
	if enemies.size() > 0:
		for i in enemies:
			if i.curtype == i.TYPE.blackenemy: i.enablearea(not onoff)
	if worldlight: worldlight.visible = onoff
	if music:
		if onoff: music.volume_db -= 3.5
		if !onoff: music.volume_db += 3.5
	
	if onoff: $AudioStreamPlayer.pitch_scale = 1.0
	if !onoff: $AudioStreamPlayer.pitch_scale = 0.7
	$AudioStreamPlayer.play()
