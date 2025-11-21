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
@export var NumVents1: int = 1
@export var SceneBox1: PackedScene = preload("res://scenes scripts/box_1.tscn")
@export var SceneBox2: PackedScene = preload("res://scenes scripts/box_2.tscn")
@export var SceneBox3: PackedScene = preload("res://scenes scripts/box_3.tscn")
@export var SceneBox4: PackedScene = preload("res://scenes scripts/box_4.tscn")
@export var SceneBasket1: PackedScene = preload("res://scenes scripts/basket_1.tscn")
@export var SceneSlime1: PackedScene = preload("res://scenes scripts/slime_1.tscn")
@export var SceneCabels1: PackedScene = preload("res://scenes scripts/cabels_1.tscn")
@export var SceneVent1: PackedScene = preload("res://scenes scripts/vent_1.tscn")
var isplayerbeeninroom: bool = false
@export var boxposy: float = 1
var canbake: bool = false
@export var navibridgeScene: PackedScene = preload("res://scenes scripts/navibridge.tscn")

@export_category("End Rooms")
@export var isendroom1: bool = false
@export var neededenvironment: Environment = preload("res://materials/endroom1.tres")
@export var colorlight: Color = Color(0.991, 0.857, 0.842)

@export_category("Size Room")
@export var autoSize: bool = true
@export var manualSize: Vector3

@export_category("Not Added")
@export var MinNumBoxes: int = 6
@export var MaxNumBoxes: int = 14


func _ready():
	if autoSize:
		manualSize.x = $NavigationRegion3D/StaticBody3D/bottom.mesh.size.x
	
	if RandomBox:
		if RandomNumBoxes:
			NumBoxes1 += randi_range(-1, 1)
			NumBoxes2 += randi_range(-1, 1)
			NumBoxes3 += randi_range(-1, 1)
			NumBoxes4 += randi_range(-1, 1)
			NumBasket1 += randi_range(-1, 1)
			NumSlime1 += randi_range(-1, 1)
			NumVents1 += randi_range(-1, 0)
		spawnbox(SceneBox1, NumBoxes1, boxposy)
		spawnbox(SceneBox2, NumBoxes2, boxposy)
		spawnbox(SceneBox3, NumBoxes3, boxposy)
		spawnbox(SceneBox4, NumBoxes4, boxposy)
		spawnbox(SceneBasket1, NumBasket1, boxposy)
		spawnbox(SceneSlime1, NumSlime1, 0.0)
		spawnbox(SceneVent1, NumVents1, 0.0, false)
	if Cabels:
		spawnbox(SceneCabels1, NumCabels1, 3.0, false)
	
	#next room cam zone
	var areacamn = Area3D.new()
	var collcamn = CollisionShape3D.new()
	add_child(areacamn)
	areacamn.add_child(collcamn)
	collcamn.shape = load("res://BoxShapes/collcam1.tres")
	areacamn.position.x = -0.5
	
	if areacamn:
		areacamn.body_entered.connect(camzoneNentered)
		areacamn.body_exited.connect(camzoneNexited)
	
	#back room cam zone
	var areacamb = Area3D.new()
	var collcamb = CollisionShape3D.new()
	add_child(areacamb)
	areacamb.add_child(collcamb)
	collcamb.shape = load("res://BoxShapes/collcam1.tres")
	areacamb.position.x = -$NavigationRegion3D/StaticBody3D/bottom.mesh.size.x + 0.5
	
	if areacamb:
		areacamb.body_entered.connect(camzoneBentered)
		areacamb.body_exited.connect(camzoneBexited)
	
	var navibridge: StaticBody3D = navibridgeScene.instantiate()
	$NavigationRegion3D/StaticBody3D.add_child(navibridge)
	navibridge.position = Vector3(-$NavigationRegion3D/StaticBody3D/bottom.mesh.size.x, 0, 0)
	
	$Area3D/CollisionShape3D.shape.size = Vector3(
		$NavigationRegion3D/StaticBody3D/bottom.mesh.size.x,
		3.0,
		$NavigationRegion3D/StaticBody3D/bottom.mesh.size.y
	)
	
	bakenavi()

func getsize():
	return manualSize

func spawnbox(typebox: PackedScene, count: int, posy: float, enablerotation: bool = true):
	for i in count:
		var box = typebox.instantiate()
		$NavigationRegion3D.add_child(box)
		var posboxz = ($NavigationRegion3D/StaticBody3D/bottom.mesh.size.y / 2.0) * 0.8
		var posboxx = ($NavigationRegion3D/StaticBody3D/bottom.mesh.size.x / 2.0) * 0.8
		box.position = Vector3(
			randf_range(-posboxx, posboxx) - $NavigationRegion3D/StaticBody3D/bottom.mesh.size.x / 2.0,
			posy,
			randf_range(-posboxz, posboxz)
		)
		if enablerotation:
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
		bakenavi()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		#$Timer.stop()
		#autodelete = false
		#isplayerbeeninroom = true
		canbake = true
		bakenavi()
		Global.navibakereq.disconnect(bakenavi)
		if isendroom1:
			var env: WorldEnvironment = get_parent().get_node("WorldEnvironment")
			var tufflightbro: DirectionalLight3D = get_parent().get_node("DirectionalLight3D")
			
			var sceneflash: PackedScene = load("res://scenes scripts/flash.tscn")
			var flash: CanvasLayer = sceneflash.instantiate()
			get_parent().add_child(flash)
			flash.flash()
			
			env.environment = neededenvironment
			tufflightbro.light_color = colorlight
			
			var enemies = get_tree().get_nodes_in_group("enemy")
			for enemy in enemies: enemy.queue_free()
			
			get_parent().get_node("music").stop()
			
			if Global.unlockachievement(0):
				var ach = get_tree().current_scene.get_node("notification")
				ach.display(Global.achievements[0]["name"],
				Global.achievements[0]["desc"],
				load("res://sprites/icon12.png"))
				
			var player = get_tree().get_first_node_in_group("player")
			if player.health < 2:
				if Global.unlockachievement(5):
					var ach = get_tree().current_scene.get_node("notification")
					ach.display(Global.achievements[5]["name"],
					Global.achievements[5]["desc"],
					load("res://sprites/icon12.png"))
			
			$CanvasLayer.start()
			$Area3D.queue_free()


func bakenavi():
	await get_tree().physics_frame
	if !isendroom1:
		$NavigationRegion3D.bake_navigation_mesh()

func camzoneNentered(body):
	if body.is_in_group("player"):
		var curcamposx = $NavigationRegion3D/StaticBody3D/bottom.mesh.size.x / 2.0
		var curcamposy = $NavigationRegion3D/StaticBody3D/bottom.mesh.size.y / 2.0
		#body.camfollowupdate(true, global_position.x - curcamposx)

func camzoneNexited(body):
	if body.is_in_group("player"):
		var curcamposx = $NavigationRegion3D/StaticBody3D/bottom.mesh.size.x / 2.0
		var curcamposy = $NavigationRegion3D/StaticBody3D/bottom.mesh.size.y / 2.0
		body.camfollowupdate(false, global_position.x - curcamposx, global_position.y - curcamposy)

func camzoneBentered(body):
	if body.is_in_group("player"):
		var curcamposx = $NavigationRegion3D/StaticBody3D/bottom.mesh.size.x / 2.0
		var curcamposy = $NavigationRegion3D/StaticBody3D/bottom.mesh.size.y / 2.0
		#body.camfollowupdate(true, global_position.x + -curcamposx)

func camzoneBexited(body):
	if body.is_in_group("player"):
		var curcamposx = $NavigationRegion3D/StaticBody3D/bottom.mesh.size.x / 2.0
		var curcamposy = $NavigationRegion3D/StaticBody3D/bottom.mesh.size.y / 2.0
		body.camfollowupdate(false, global_position.x + -curcamposx, global_position.y + -curcamposy)
