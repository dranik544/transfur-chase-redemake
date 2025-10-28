extends RigidBody3D

@export var selfsprite: CompressedTexture2D
@export var selfscene: PackedScene = preload("res://scenes scripts/item_1.tscn")
@export var ispuddle: bool = true
@export var puddlescene: PackedScene = preload("res://scenes scripts/slime_1.tscn")
@export var selfkg: float = 0.75
var isthrow: bool = false
var canbroke: bool = false
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

func _on_area_3d_2_body_entered(body: Node3D) -> void:
	if !is_in_group("player") and isthrow:
		if ispuddle:
			if canbroke:
				var puddle = puddlescene.instantiate()
				get_parent().add_child(puddle)
				puddle.global_position = global_position
				puddle.global_position.y = 0.1
				queue_free()

func _on_timer_timeout() -> void:
	if isthrow == true:
		canbroke = true

func timer():
	$Timer.start()
