extends RigidBody3D

@export var beffecttexture: Texture = preload("res://sprites/boxeffect1.png")
@export var bscaletexture: Vector2 = Vector2(0.25, 0.25)
@export var bamounttexture: int = 8
@export var bcoloreffect: Color = Color(0.698, 0.486, 0.275)
@export var effectscene: PackedScene = preload("res://scenes scripts/effect_1.tscn")


func broke():
	var effect: Node3D = effectscene.instantiate()
	get_parent().add_child(effect)
	effect.global_position = global_position
	
	#effect.effecttexture = beffecttexture
	#effect.scaletexture = bscaletexture
	#effect.amounttexture = bamounttexture
	#effect.coloreffect = bcoloreffect
	effect.seteffect(beffecttexture, bscaletexture, bamounttexture, bcoloreffect)
	
	effect.play()
	
	queue_free()
