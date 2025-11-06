extends Node2D

@export var listskins = [
	"colin",
	"V1",
	"nightmare colin",
	"new year colin",
	"gold colin",
	"hank"
]
var curskin = 0
var curskinset


func _ready() -> void:
	$arrow1/Button.pressed.connect(btnleftpressed)
	$arrow2/Button.pressed.connect(btnrightpressed)

func btnleftpressed():
	curskin -= 1
	if curskin < 0:
		curskin = listskins.size() - 1
	updateskin(false, true)

func btnrightpressed():
	curskin += 1
	if curskin >= listskins.size():
		curskin = 0
	updateskin(false, true)


func updateskin(save: bool, enablecurskin: bool):
	if enablecurskin: Global.colinskin = listskins[curskin]
	
	match Global.colinskin:
		"colin":
			$"../../room1 1/room1/Sprite3D2".sprite_frames = load("res://sprites materials/player_sprite.tres")
			$Label.text = "обычный Колин"
			$Label2.text = "ну что про него можно вообще написать?"
		"V1":
			$"../../room1 1/room1/Sprite3D2".sprite_frames = load("res://sprites materials/v1_player_skin.tres")
			$Label.text = "V1"
			$Label2.text = "выбрался из глубин ада чтобы надавать лещей латексным!
			(отсылка на UltraKill)
			(даётся за прохождении 1-ой локации)"
		"nightmare colin":
			$"../../room1 1/room1/Sprite3D2".sprite_frames = load("res://sprites materials/player_sprite.tres")
			$Label.text = "жуткий Колин"
			$Label2.text = "сладость или трансфурмация!
			(даётся на событие Хеллоуин)"
		"new year colin":
			$"../../room1 1/room1/Sprite3D2".sprite_frames = load("res://sprites materials/player_sprite.tres")
			$Label.text = "праздничный Колин"
			$Label2.text = "а ты уже нарядил свою ёлку?
			(даётся на событие Новый год)"
		"gold colin":
			$"../../room1 1/room1/Sprite3D2".sprite_frames = load("res://sprites materials/player_sprite.tres")
			$Label.text = "ЗОЛОТОЙ КОЛИН"
			$Label2.text = "чувак ты где его нашёл?!
			(даётся за полное закрытие всех достижений)"
		"hank":
			$"../../room1 1/room1/Sprite3D2".sprite_frames = load("res://sprites materials/hank_player_skin.tres")
			$Label.text = "Хэнк"
			$Label2.text = "псих Невады, который может насадить тебя 1000 и 1 способом.
			(отсылка на Madness Combat)
			(даётся за прохождение 2-ой локации)"
	
	if save: SavingManager.save("skins", Global.colinskin)
	
	$"../../room1 1/room1/Sprite3D2".play("idle")
