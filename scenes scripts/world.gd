extends Node3D


@export var rooms = {
	1: preload("res://scenes scripts/rooms/sroom_1_1.tscn"),
	2: preload("res://scenes scripts/rooms/sroom_1_2.tscn"),
	3: preload("res://scenes scripts/rooms/sroom_1_3.tscn"),
	4: preload("res://scenes scripts/rooms/sroom_2_1.tscn"),
	5: preload("res://scenes scripts/rooms/sroom_2_2.tscn"),
	6: preload("res://scenes scripts/rooms/sroom_1_4.tscn"),
	7: preload("res://scenes scripts/rooms/sroom_2_3.tscn")
}
@export var loadrooms: int = 40
var lastroom: int = 1


func _ready():
	var o: int = 0
	await get_tree().physics_frame
	$enemy1.set_physics_process(false)
	$enemy2.set_physics_process(false)
	$player.set_physics_process(false)
	$CanvasLayer.visible = true
	for i in loadrooms:
		await get_tree().physics_frame
		spawnroom(true, null)
		await get_tree().process_frame
		o += 1
		$CanvasLayer/Label.text = "Load rooms.. (" + str(o) + "/" + str(loadrooms) + ")"
	#$navi.bake_navigation_mesh()
	await get_tree().physics_frame
	spawnroom(false, load("res://scenes scripts/rooms/endroom_1.tscn"))
	$CanvasLayer.queue_free()
	$player.set_physics_process(true)
	$enemy1.set_physics_process(true)
	$enemy2.set_physics_process(true)
	$music.play()
	
	$notification.display("Сейчас играет - Run!", "автор музыки:
	WatewrFlame", load("res://sprites/icon2.png"), 3)

func spawnroom(randomroom: bool = true, scenesroom: PackedScene = null):
	var numroom: int = randi_range(1, rooms.size())
	var sceneroom: PackedScene
	var roompos
	var doorpos
	
	while numroom == lastroom:
		numroom = randi_range(1, rooms.size())
	
	lastroom = numroom
	sceneroom = rooms.get(numroom)
	
	if randomroom:
		var nextroom: Node3D = sceneroom.instantiate()
		nextroom.position = $spawnnextroom.position
		add_child(nextroom)
		
		roompos = nextroom.getsize()
		
		nextroom.bakenavi()
	elif !randomroom and scenesroom:
		var sroom: Node3D = scenesroom.instantiate()
		sroom.position = $spawnnextroom.position
		add_child(sroom)
		
		roompos = sroom.getsize()
	
	$spawnnextroom.position -= roompos
