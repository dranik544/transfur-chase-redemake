extends RigidBody3D

var player: CharacterBody3D
@export var beffecttexture: Texture = preload("res://sprites/boxeffect1.png")
@export var bscaletexture: Vector2 = Vector2(0.25, 0.25)
@export var bamounttexture: int = 8
@export var bcoloreffect: Color = Color(0.698, 0.486, 0.275)
@export var effectscene: PackedScene = preload("res://scenes scripts/effect_1.tscn")
enum TYPE {box, colb, crystal, greencrystal}
@export var curtype: TYPE = TYPE.box
var slimescene: PackedScene = preload("res://scenes scripts/slime_1.tscn")
@export var crystalsprites = [
	preload("res://sprites/bcrystal1.png"),
	preload("res://sprites/bcrystal2.png"),
	preload("res://sprites/bcrystal3.png"),
	preload("res://sprites/bcrystal4.png"),
	preload("res://sprites/cristal2.png")
]
@export var greencrystalsprites = [
	preload("res://sprites/greenbcrystal1.png"),
	preload("res://sprites/greenbcrystal2.png"),
	preload("res://sprites/greenbcrystal3.png"),
]


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	
	if curtype == TYPE.crystal:
		var random = randi_range(0, crystalsprites.size() - 1)
		$Sprite3D.texture = crystalsprites[random]
		$Sprite3D2.texture = crystalsprites[random]
	elif curtype == TYPE.greencrystal:
		var random = randi_range(0, greencrystalsprites.size() - 1)
		$Sprite3D.texture = greencrystalsprites[random]
		$Sprite3D2.texture = greencrystalsprites[random]

#func _process(delta: float) -> void:
	#if !player:
		#player = get_tree().get_first_node_in_group("player")
	#
	#if player:
		#if global_position.distance_to(player.global_position) > 20:
			#set_physics_process(false)
		#else:
			#set_physics_process(true)

func broke():
	var effect: Node3D = effectscene.instantiate()
	get_parent().add_child(effect)
	effect.global_position = global_position
	
	#effect.effecttexture = beffecttexture
	#effect.scaletexture = bscaletexture
	#effect.amounttexture = bamounttexture
	#effect.coloreffect = bcoloreffect
	effect.seteffect(beffecttexture, bscaletexture, bamounttexture, bcoloreffect)
	
	if curtype == TYPE.colb:
		var slime = slimescene.instantiate()
		slime.curtype = slime.TYPE.blackenemy
		get_parent().add_child(slime)
		slime.global_position = Vector3(global_position.x, 0, global_position.z)
	
	effect.play()
	
	queue_free()
