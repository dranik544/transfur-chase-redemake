extends Node3D

var rooms1 = {
	1: preload("res://scenes scripts/room_1_1.tscn"),
}
var rooms2 = {
	1: preload("res://scenes scripts/room_1_1.tscn"),
}

@export var room1size = Vector3(10, 0, 0)
@export var room2size = Vector3(15, 0, 0)
@export var loadrooms: int = 10


func _ready():
	var o: int = 0
	await get_tree().physics_frame
	$enemy1.set_physics_process(false)
	$player.set_physics_process(false)
	$CanvasLayer.visible = true
	for i in loadrooms:
		await get_tree().physics_frame
		spawnroom()
		o += 1
		$CanvasLayer/Label.text = "Load rooms.. (" + str(o) + "/" + str(loadrooms) + ")"
	#$navi.bake_navigation_mesh()
	$CanvasLayer.queue_free()
	$enemy1.set_physics_process(true)
	$player.set_physics_process(true)
	#$Timer.start()

#func _process(delta):
	#get_tree().call_group("enemy", "targetpos", $player.global_transform.origin)

func _on_timer_timeout() -> void:
	spawnroom()
	#$navi.bake_navigation_mesh()

#func _on_detectspawnroom_body_entered(body: Node3D) -> void:
	#if body.is_in_group("player"):
		#$navi.bake_navigation_mesh()

func spawnroom():
	var numroom: int = randi_range(1, 1)
	var typeroom: int = randi_range(1, 1)
	var sceneroom: PackedScene
	var typeroompos
	
	match typeroom:
		1:
			sceneroom = rooms1.get(numroom)
			typeroompos = room1size
		2:
			sceneroom = rooms2.get(numroom)
			typeroompos = room2size
	
	if sceneroom:
		var nextroom: Node3D = sceneroom.instantiate()
		nextroom.position = $spawnnextroom.position
		add_child(nextroom)
		nextroom.bakenavi()
	
	$spawnnextroom.position -= typeroompos
	$detectspawnroom.position -= typeroompos
