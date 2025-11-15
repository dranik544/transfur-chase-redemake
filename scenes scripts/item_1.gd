extends RigidBody3D

@export_category("default")
@export var selfsprite: CompressedTexture2D
@export var selfscene: PackedScene
@export var selfkg: float = 0.75
@export var type: String

@export_category("changing health")
@export var ischangehp: bool = true
@export var changehp: int = 1

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

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		if $hint:
			$hint.visible = true
		if body.pick and !body.isinv:
			pick(body)

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		if $hint:
			$hint.visible = false

func pick(player):
	player.isinv = true
	player.itemsprite = selfsprite
	player.itemscene = selfscene
	player.itemtype = type
	player.itemkg = selfkg
	
	queue_free()

func use(player = get_tree().get_first_node_in_group("player")):
	if ischangehp:
		player.health += changehp
	
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
