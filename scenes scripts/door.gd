extends StaticBody3D

@export var hp: float = 0
@export var HitColor: Color
var canhit: bool = true

@export var neffecttexture: Texture
@export var nscaletexture: Vector2 = Vector2(0.25, 0.25)
@export var namounttexture: int = 16
@export var ncoloreffect: Color = Color(1.0, 1.0, 1.0)


func _ready():
	$door1.freeze = true
	$door2.freeze = true
	
	Global.hitdoor.connect(hit)
	
	$Timer.timeout.connect(time_for_DIEEE_MUHAHAHAHAHAHAHA)
	
	if hp == 0:
		hp = randi_range(1, 4)
	add_to_group("door")

func _process(delta):
	$door1/Sprite3D.scale = lerp($door1/Sprite3D.scale, Vector3(6.0, 6.0, 6.0), 10 * delta)
	$door2/Sprite3D.scale = lerp($door2/Sprite3D.scale, Vector3(6.0, 6.0, 6.0), 10 * delta)
	$door1/Sprite3D.modulate = lerp($door1/Sprite3D.modulate, Color(1.0, 1.0, 1.0, 1.0), 10 * delta)
	$door2/Sprite3D.modulate = lerp($door2/Sprite3D.modulate, Color(1.0, 1.0, 1.0, 1.0), 10 * delta)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		if $hint:
			$hint.visible = true
		#if body.hit:
			#hit(1)
		if body.isslide:
			hit(99)

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		if $hint:
			$hint.visible = false

func hit(damage: float):
	if damage == null:
		damage = 1
	
	var player = get_tree().get_first_node_in_group("player")
	if canhit:
		if global_position.distance_to(player.global_position) < 1.5:
			canhit = false
			hp -= damage
			$door1/Sprite3D.scale = Vector3(randf_range(6.5, 7.5), randf_range(6.5, 7.5), randf_range(6.5, 7.5))
			$door2/Sprite3D.scale = Vector3(randf_range(6.5, 7.5), randf_range(6.5, 7.5), randf_range(6.5, 7.5))
			$door1/Sprite3D.modulate = HitColor
			$door2/Sprite3D.modulate = HitColor
			
			$AudioStreamPlayer3D.play()
			
			player.startshake(randf_range(5, 15), 0.1)
			if hp <= 0:
				$effect1.seteffect(neffecttexture, nscaletexture, namounttexture, ncoloreffect)
				
				Global.brokendoors += 1
				$door1.freeze = false
				$door2.freeze = false
				
				$door1.collision_layer = false
				$door2.collision_layer = false
				
				if $hint:
					$hint.queue_free()
				if $Area3D:
					$Area3D.queue_free()
				
				var impulsevec1 = Vector3(-3, 0.5, -1)
				var impulsevec2 = Vector3(-3, 0.5, 1)
				$door1.apply_impulse(impulsevec1, Vector3.ZERO)
				$door2.apply_impulse(impulsevec2, Vector3.ZERO)
				$Timer.start()
				
				player.startshake(35, 0.35)
				
				$effect1.play()
			
			$Timer2.start()

func time_for_DIEEE_MUHAHAHAHAHAHAHA():
	queue_free()

func _on_timer_2_timeout() -> void:
	if hp > 0:
		canhit = true
