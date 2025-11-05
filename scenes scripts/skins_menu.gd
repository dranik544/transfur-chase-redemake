extends Node2D


func _ready() -> void:
	$"default colin/Button".pressed.connect(btncolinpressed)
	$v1/Button.pressed.connect(btnv1pressed)

func btncolinpressed():
	Global.colinskin = "colin"
	SavingManager.save(Global.colinskin)
	updateskin()


func btnv1pressed():
	Global.colinskin = "V1"
	SavingManager.save(Global.colinskin)
	updateskin()

func updateskin():
	match Global.colinskin:
		"colin":
			$"../../room1 1/room1/Sprite3D2".sprite_frames = load("res://sprites materials/player_sprite.tres")
		"V1":
			$"../../room1 1/room1/Sprite3D2".sprite_frames = load("res://sprites materials/v1_player_skin.tres")
	
	$"../../room1 1/room1/Sprite3D2".play("idle")
