extends RigidBody3D

@export_category("default")
@export var selfsprite: CompressedTexture2D
@export var selfscene: PackedScene
@export var selfkg: float = 0.75
@export var type: String

@export_category("types")
enum TYPE {CHANGEHP, CHANGEDAMAGE, SHIELD, CHANGESPEED, CHANGETIMESCALE}
@export var curtype: TYPE
@export var changehp: int = 1
@export var changedamage: float = 1.0
@export var changespeed: float = 1.75
@export var changetimescale: float = 0.75

@export_category("only for one time")
@export var istimed: bool = false
@export var pointstime: int = 3

@export_category("effects")
@export var effectscene: PackedScene = preload("res://scenes scripts/effect_1.tscn")
@export var ieffecttexture: Texture = preload("res://sprites/icon8.png")
@export var iscaletexture: Vector2 = Vector2(0.25, 0.25)
@export var iamounttexture: int = 12
@export var icoloreffect: Color = Color(1.0, 1.0, 1.0)

var itemdata = {}


func _ready():
	if selfscene == null:
		var selfscenepath = get_scene_file_path()
		selfscene = load(selfscenepath)
	
	Global.pickupitem.connect(pick)
	
	if !istimed:
		pointstime = 0
	
	itemdata["sprite"] = selfsprite
	itemdata["scene"] = selfscene
	itemdata["type"] = type
	itemdata["kg"] = selfkg
	itemdata["pointstime"] = pointstime
	itemdata["pointstimemax"] = pointstime
	if curtype == TYPE.SHIELD:
		itemdata["shieldenable"] = true

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.labelhints["pickupitem"]["enable"] = true
		
		if $hint:
			$hint.visible = true
		#if body.pick and !body.isinv:
			#pick(body)

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.labelhints["pickupitem"]["enable"] = false
		
		if $hint:
			$hint.visible = false

func pick(player = get_tree().get_first_node_in_group("player"), checkdist: bool = true):
	if !checkdist:
		player.isinv = true
		player.itemdata = itemdata
		queue_free()
	else:
		if global_position.distance_to(player.global_position) < 1.5:
			player.isinv = true
			player.itemdata = itemdata
			queue_free()

func use(player: CharacterBody3D = get_tree().get_first_node_in_group("player")):
	if !player: return
	
	Global.useditems += 1
	
	var effect = effectscene.instantiate()
	get_parent().add_child(effect)
	effect.global_position = global_position
	
	#effect.amounttexture = iamounttexture
	#effect.effecttexture = ieffecttexture
	#effect.scaletexture = iscaletexture
	
	effect.seteffect(ieffecttexture, iscaletexture, iamounttexture, icoloreffect)
	effect.play()
	
	match curtype:
		TYPE.CHANGEHP:
			player.health += changehp
			
			queue_free()
		TYPE.CHANGEDAMAGE:
			player.damage += changedamage
			Global.hitdoor.emit(player.damage)
			Global.punchpl.emit(player.damage)
			player.damage -= changedamage
			
			queue_free()
		TYPE.SHIELD:
			
			
			queue_free()
		TYPE.CHANGESPEED:
			hide()
			
			player.speedlerp = 0.05
			player.speed += changespeed
			player.startshake(200, 50)
			var pldamage = player.damage
			player.damage *= changespeed
			Engine.time_scale = 1.0 + changespeed / 10
			
			var flash: CanvasLayer = load("res://scenes scripts/flash.tscn").instantiate()
			get_parent().add_child(flash)
			flash.flash(Color.ANTIQUE_WHITE, 1.5)
			create_tween().tween_property(player.get_node("gui/crt").material, "shader_parameter/colorOffsetIntensity", 1.5, 0.01)
			create_tween().tween_property(player.get_node("gui/crt").material, "shader_parameter/colorOffsetIntensity", 0.1, 3.5)
			create_tween().tween_property(player.get_node("gui/crt").material, "shader_parameter/NoiseIntensity", 0.05, 0.01)
			create_tween().tween_property(player.get_node("gui/crt").material, "shader_parameter/noiseIntensity", 0.0, 5.0)
			
			await get_tree().create_timer(5.5, false, false, true).timeout
			
			Engine.time_scale = 1.0
			player.speedlerp = 5.0
			player.damage = pldamage
			
			queue_free()
		TYPE.CHANGETIMESCALE:
			hide()
			
			var origspeed = player.speed
			var origslidespeed = player.slidespeed
			var origspeedlerp = player.speedlerp
			var origvelocitylerp = player.velocitylerp
			
			Engine.time_scale = changetimescale
			
			player.speed *= 1.0 / changetimescale
			player.slidespeed *= 1.0 / changetimescale
			#player.speedlerp *= 1.0 / changetimescale
			player.speedlerp = 0.05
			player.velocitylerp *= 1.0 / changetimescale
			
			player.startshake(20, 1)
			var flash: CanvasLayer = load("res://scenes scripts/flash.tscn").instantiate()
			get_parent().add_child(flash)
			flash.flash(Color.WHITE, 2)
			
			await get_tree().create_timer(10.0, false, false, true).timeout
			
			Engine.time_scale = 1.0
			
			player.speed = origspeed
			player.slidespeed = origslidespeed
			#player.speedlerp = origspeedlerp
			player.velocitylerp = origvelocitylerp
			
			queue_free()
