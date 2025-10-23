extends RigidBody3D

@export var hp: float = 0
@export var HitColor: Color


func _ready():
	freeze = true
	if hp == 0:
		hp = randf_range(0, 2)
	add_to_group("door")

func _process(delta):
	$Sprite3D.scale = lerp($Sprite3D.scale, Vector3(6.0, 6.0, 6.0), 10 * delta)
	$Sprite3D.modulate = lerp($Sprite3D.modulate, Color(1.0, 1.0, 1.0, 1.0), 10 * delta)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		if $hint:
			$hint.visible = true
		if body.hit:
			hit(1)

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		if $hint:
			$hint.visible = false

func hit(damage: float):
	if damage == null:
		damage = 1
	hp -= damage
	$Sprite3D.scale = Vector3(randf_range(6.5, 7.5), randf_range(6.5, 7.5), randf_range(6.5, 7.5))
	$Sprite3D.modulate = HitColor
	if hp <= 0:
		Global.brokendoors += 1
		freeze = false
		collision_layer = 2
		$hint.queue_free()
		$Area3D.queue_free()
		apply_impulse(Vector3(-7.5, 10, 0), Vector3.ZERO)
