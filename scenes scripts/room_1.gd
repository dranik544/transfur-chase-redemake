extends Node3D

var autodelete = false
@export var RandomBox: bool = true
@export var Cabels: bool = true
@export var RandomNumBoxes: bool = true
@export var NumBoxes1: int = 3
@export var NumBoxes2: int = 1
@export var NumBoxes3: int = 1
@export var NumBoxes4: int = 2
@export var NumBasket1: int = 2
@export var NumSlime1: int = 2
@export var NumCabels1: int = 10
@export var SceneBox1: PackedScene = preload("res://scenes scripts/box_1.tscn")
@export var SceneBox2: PackedScene = preload("res://scenes scripts/box_2.tscn")
@export var SceneBox3: PackedScene = preload("res://scenes scripts/box_3.tscn")
@export var SceneBox4: PackedScene = preload("res://scenes scripts/box_4.tscn")
@export var SceneBasket1: PackedScene = preload("res://scenes scripts/basket_1.tscn")
@export var SceneSlime1: PackedScene = preload("res://scenes scripts/slime_1.tscn")
@export var SceneCabels1: PackedScene = preload("res://scenes scripts/cabels_1.tscn")
var isplayerbeeninroom: bool = false
@export var boxposy: float = 1
var canbake: bool = false
var camposx: float = 0.0

@export_category("Not Added")
@export var MinNumBoxes: int = 6
@export var MaxNumBoxes: int = 14


func _ready():
	if RandomBox:
		if RandomNumBoxes:
			NumBoxes1 += randi_range(-1, 1)
			NumBoxes2 += randi_range(-1, 1)
			NumBoxes3 += randi_range(-1, 1)
			NumBoxes4 += randi_range(-1, 1)
			NumBasket1 += randi_range(-1, 1)
			NumSlime1 += randi_range(-1, 1)
		spawnbox(SceneBox1, NumBoxes1, boxposy)
		spawnbox(SceneBox2, NumBoxes2, boxposy)
		spawnbox(SceneBox3, NumBoxes3, boxposy)
		spawnbox(SceneBox4, NumBoxes4, boxposy)
		spawnbox(SceneBasket1, NumBasket1, boxposy)
		spawnbox(SceneSlime1, NumSlime1, 0.0)
	if Cabels:
		spawnbox(SceneCabels1, NumCabels1, 3.0)
	
	var areacam = Area3D.new()
	var collcam = CollisionShape3D.new()
	add_child(areacam)
	areacam.add_child(collcam)
	collcam.shape = load("res://BoxShapes/collcam1.tres")
	areacam.position.x = 1.0
	
	if areacam:
		areacam.body_entered.connect(camzoneentered)
		areacam.body_exited.connect(camzoneexited)
	camposx = $NavigationRegion3D/room1.size.x / 2.0

func spawnbox(typebox: PackedScene, count: int, posy: float):
	for i in count:
		var box = typebox.instantiate()
		add_child(box)
		var posboxz = ($NavigationRegion3D/room1.size.z / 2.0) * 0.8
		var posboxx = ($NavigationRegion3D/room1.size.x / 2.0) * 0.8
		box.position = Vector3(
			randf_range(-posboxx, posboxx) - $NavigationRegion3D/room1.size.x / 2.0,
			posy,
			randf_range(-posboxz, posboxz)
		)
		box.rotation = Vector3(0, randf_range(-90, 90), 0)

func _on_timer_timeout() -> void:
	if autodelete:
		queue_free()
	if canbake:
		bakenavi()

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		#$Timer.start()
		#autodelete = true
		#queue_free()
		canbake = false
		Global.navibakereq.connect(bakenavi)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		#$Timer.stop()
		#autodelete = false
		#isplayerbeeninroom = true
		canbake = true
		Global.navibakereq.disconnect(bakenavi)

func bakenavi():
	await get_tree().physics_frame
	$NavigationRegion3D.bake_navigation_mesh()

func camzoneentered(body):
	if body.is_in_group("player"):
		var curcamposx = $NavigationRegion3D/room1.size.x / 2.0
		body.camfollowupdate(true, curcamposx)

func camzoneexited(body):
	if body.is_in_group("player"):
		var curcamposx = $NavigationRegion3D/room1.size.x / 2.0
		body.camfollowupdate(false, curcamposx)
