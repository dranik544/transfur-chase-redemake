extends Node3D


@export var rooms = {
	1: preload("res://scenes scripts/rooms/sroom_1_1.tscn"),
	2: preload("res://scenes scripts/rooms/sroom_1_2.tscn"),
	3: preload("res://scenes scripts/rooms/sroom_1_3.tscn"),
	4: preload("res://scenes scripts/rooms/sroom_2_1.tscn"),
	5: preload("res://scenes scripts/rooms/sroom_2_2.tscn"),
	6: preload("res://scenes scripts/rooms/sroom_1_4.tscn"),
	7: preload("res://scenes scripts/rooms/sroom_2_3.tscn"),
	8: preload("res://scenes scripts/rooms/sroom_2_4.tscn"),
	9: preload("res://scenes scripts/rooms/sroom_1_5.tscn"),
	10: preload("res://scenes scripts/rooms/sroom_2_5.tscn"),
	11: preload("res://scenes scripts/rooms/sroom_2_6.tscn"),
}
@export var loadrooms: int = 45
var lastroom: int = 1
@export var lastroomscene: PackedScene = preload("res://scenes scripts/rooms/endroom_1.tscn")
var grooms = []


#func _ready():
	#var o: int = 0
	#await get_tree().physics_frame
	#
	#grooms.push_back(get_node("startroom1"))
	#grooms.push_back(get_node("startroom4"))
	#
	#var player
	#if get_tree(): player = get_tree().get_first_node_in_group("player")
	#
	#if $enemy1 and $enemy2:
		#$enemy1.set_physics_process(false)
		#$enemy2.set_physics_process(false)
	#if player: player.set_physics_process(false)
	#$CanvasLayer.visible = true
	#for i in loadrooms:
		#await get_tree().physics_frame
		#spawnroom(true, null)
		#await get_tree().process_frame
		#o += 1
		#$CanvasLayer/Label.text = "Load rooms.. (" + str(o) + "/" + str(loadrooms) + ")"
	##$navi.bake_navigation_mesh()
	#await get_tree().physics_frame
	#
	#spawnroom(false, lastroomscene)
	#
	#o = 0
	#for i in grooms:
		#if i != null:
			#if i.has_node("NavigationRegion3D") and i.get_node("NavigationRegion3D") is NavigationRegion3D:
				#var navi: NavigationRegion3D = i.get_node("NavigationRegion3D")
				#navi.navigation_mesh = preload("res://navimesh/navimesh1.tres").duplicate()
				#navi.bake_navigation_mesh()
				#await navi.bake_finished
			#o += 1
			#$CanvasLayer/Label.text = "Generate Nav Meshes.. (" + str(o) + "/" + str(len(grooms)-1) + ")"
	#
	#$CanvasLayer/Label.text = "Please, wait one more second."
	#await get_tree().create_timer(1.0).timeout
	#
	#$CanvasLayer/Label.text = "Press Enter to continue"
	#await get_tree().create_timer(0.05).timeout
	#await enter()
	#
	#$CanvasLayer.queue_free()
	#if player: player.set_physics_process(true)
	#if $enemy1 and $enemy2:
		#$enemy1.set_physics_process(true)
		#$enemy2.set_physics_process(true)
	#$music.play()
	#
	#$notification.display(
		#tr("NOW_PLAYING").format({"track": "Run!"}),
		#tr("SOUNDTRACK_AUTHOR").format({"author": "WaterFlame"}),
		#load("res://sprites/icon2.png"), 4)
	#
	#add_to_group("world")

func enter() -> void:
	while true:
		await get_tree().process_frame
		if Global.ismobile:
			if Input.is_action_just_pressed("LCM"):
				return
		if Input.is_action_just_pressed("ENTER"):
			return

func spawnroom(randomroom: bool = true, scenesroom: PackedScene = null):
	var numroom: int = randi_range(1, rooms.size())
	var sceneroom: PackedScene
	var roompos: Vector3 = Vector3.ZERO
	var doorpos
	
	while numroom == lastroom:
		numroom = randi_range(1, rooms.size())
	
	lastroom = numroom
	sceneroom = rooms.get(numroom)
	
	if randomroom:
		var nextroom: Node3D = sceneroom.instantiate()
		nextroom.position = $spawnnextroom.position
		add_child(nextroom)
		
		grooms.push_back(nextroom)
		
		roompos = nextroom.getsize()
	elif !randomroom and scenesroom:
		var sroom: Node3D = scenesroom.instantiate()
		sroom.position = $spawnnextroom.position
		add_child(sroom)
		
		grooms.push_back(sroom)
		roompos = sroom.getsize()
	
	$spawnnextroom.position -= roompos
