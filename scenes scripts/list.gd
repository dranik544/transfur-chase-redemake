extends RigidBody3D


func _ready():
	var randomtexture = load("res://sprites materials/list1" + str(randi_range(1, 5)) + ".png")
	$Sprite3D.texture = randomtexture
