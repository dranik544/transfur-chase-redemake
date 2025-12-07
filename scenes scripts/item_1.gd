extends RigidBody3D

@export_category("default")
@export var selfsprite: CompressedTexture2D
@export var selfscene: PackedScene
@export var selfkg: float = 0.75
@export var type: String

@export_category("types")
enum TYPE {CHANGEHP, CHANGEDAMAGE}
@export var curtype: TYPE
@export var changehp: int = 1
@export var changedamage: float = 1.0

@export_category("only for one time")
@export var istimed: bool = false
@export var pointstime: int = 3

@export_category("effects")
@export var effectscene: PackedScene = preload("res://scenes scripts/effect_1.tscn")
@export var ieffecttexture: Texture = preload("res://sprites/icon8.png")
@export var iscaletexture: Vector2 = Vector2(0.25, 0.25)
@export var iamounttexture: int = 12
@export var icoloreffect: Color = Color(1.0, 1.0, 1.0)


func _ready():
	if selfscene == null:
		var selfscenepath = get_scene_file_path()
		selfscene = load(selfscenepath)
	
	Global.pickupitem.connect(pick)
	
	if !istimed:
		pointstime = 0

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		if $hint:
			$hint.visible = true
		#if body.pick and !body.isinv:
			#pick(body)

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		if $hint:
			$hint.visible = false

func pick(player = get_tree().get_first_node_in_group("player")):
	if global_position.distance_to(player.global_position) < 1.5:
		player.isinv = true
		player.itemsprite = selfsprite
		player.itemscene = selfscene
		player.itemtype = type
		player.itemkg = selfkg
		player.itempointstime = pointstime
		player.itempointstimemax = pointstime
		
		queue_free()

func use(player = get_tree().get_first_node_in_group("player")):
	if !player: return
	
	match curtype:
		TYPE.CHANGEHP:
			player.health += changehp
		TYPE.CHANGEDAMAGE:
			player.damage += changedamage
			Global.hitdoor.emit(player.damage)
			Global.punchpl.emit(player.damage)
			player.damage -= changedamage
	
	Global.useditems += 1
	
	var effect = effectscene.instantiate()
	get_parent().add_child(effect)
	effect.global_position = global_position
	
	#effect.amounttexture = iamounttexture
	#effect.effecttexture = ieffecttexture
	#effect.scaletexture = iscaletexture
	
	effect.seteffect(ieffecttexture, iscaletexture, iamounttexture, icoloreffect)
	effect.play()
	
	queue_free()
