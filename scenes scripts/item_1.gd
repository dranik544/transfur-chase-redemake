extends RigidBody3D

@export_category("default")
@export var selfsprite: CompressedTexture2D
@export var selfscene: PackedScene = preload("res://scenes scripts/item_1.tscn")
@export var selfkg: float = 0.75
@export var type: String

@export_category("changing health")
@export var ischangehp: bool = true
@export var changehp: int = 1

@export_category("effects")
@export var effectscene: PackedScene = preload("res://scenes scripts/effect_1.tscn")
@export var ieffecttexture: Texture = preload("res://sprites materials/icon8.png")
@export var iscaletexture: Vector2 = Vector2(0.25, 0.25)
@export var iamounttexture: int = 12


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

func pick(body):
	body.isinv = true
	body.itemsprite = selfsprite
	body.itemscene = selfscene
	body.itemtype = type
	body.itemkg = selfkg
	
	queue_free()

func use(player):
	if ischangehp:
		player.health += changehp
	
	var effect = effectscene.instantiate()
	get_parent().add_child(effect)
	effect.global_position = global_position
	effect.amounttexture = iamounttexture
	effect.effecttexture = ieffecttexture
	effect.scaletexture = iscaletexture
	effect.play()
	
	queue_free()
