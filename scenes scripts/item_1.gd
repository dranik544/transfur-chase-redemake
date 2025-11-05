extends RigidBody3D

@export var selfsprite: CompressedTexture2D
@export var selfscene: PackedScene = preload("res://scenes scripts/item_1.tscn")
@export var ischangehp: bool = true
@export var changehp: int = 1
@export var selfkg: float = 0.75
@export var type: String


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
