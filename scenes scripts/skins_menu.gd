extends Node2D

var curskin = 0
var curskinset
@onready var colin = $"../../room1 1/Sprite3D2"


func _ready() -> void:
	$arrow1/Button.pressed.connect(btnleftpressed)
	$arrow2/Button.pressed.connect(btnrightpressed)

func btnleftpressed():
	curskin -= 1
	if curskin < 0:
		curskin = Global.listskins.size() - 1
	updateskin(false, true)

func btnrightpressed():
	curskin += 1
	if curskin >= Global.listskins.size():
		curskin = 0
	updateskin(false, true)


func updateskin(save: bool, enablecurskin: bool, loadcurskin: bool = false):
	if loadcurskin:
		curskin = SavingManager.load("curskin")
		if !Global.listskins[curskin]["unlocked"]:
			curskin = 0
	if enablecurskin: Global.colinskin = Global.listskins[curskin]["name"]; $"../../room1 1/Sprite3D2/effect1".play()
	
	match Global.colinskin:
		"colin":
			colin.sprite_frames = load("res://skins/player_sprite.tres")
			$Label.text = "обычный Колин"
			$Label2.text = "ну что про него можно вообще написать?"
			$Label3.text = "автор: TEAM_WITH_DRANIKS (Dranik544 / Drimer544)"
		"V1":
			colin.sprite_frames = load("res://skins/v1_player_skin.tres")
			$Label.text = "V1"
			$Label2.text = "выбрался из глубин ада чтобы надавать лещей латексным!
			(отсылка на UltraKill)
			(даётся за прохождении 1-ой локации)"
			$Label3.text = "автор: TheNamelessDeity"
		"nightmare colin":
			colin.sprite_frames = load("res://skins/nightmare_player_skin.tres")
			$Label.text = "жуткий Колин"
			$Label2.text = "сладость или трансфурмация!
			(даётся на событие Хеллоуин)"
			$Label3.text = "автор: TheNamelessDeity"
		"new year colin":
			colin.sprite_frames = load("res://skins/new_year_colin_skin.tres")
			$Label.text = "праздничный Колин"
			$Label2.text = "а ты уже нарядил свою ёлку?
			(даётся на событие Новый год)"
			$Label3.text = "автор: TheNamelessDeity"
		"gold colin":
			colin.sprite_frames = load("res://skins/player_sprite.tres")
			$Label.text = "ЗОЛОТОЙ КОЛИН"
			$Label2.text = "чувак ты где его нашёл?!
			(даётся за полное закрытие всех достижений)"
			$Label3.text = "автор: TheNamelessDeity"
		"hank":
			colin.sprite_frames = load("res://skins/hank_player_skin.tres")
			$Label.text = "Хэнк"
			$Label2.text = "псих Невады, который может насадить тебя 1000 и 1 способом.
			(отсылка на Madness Combat)
			(даётся за прохождение 2-ой локации)"
			$Label3.text = "автор: TheNamelessDeity"
		"necoarc":
			colin.sprite_frames = load("res://skins/necoarc_player_skin.tres")
			$Label.text = "Неко Арк"
			$Label2.text = "безумная кошка способная пускать лазеры из глаз!
			(отсылка на Melty Blood)
			(даётся за H1`da_=sklv12_5_bmt1аывпр.//)"
			$Label3.text = "автор: TEAM_WITH_DRANIKS (Dranik544 / Drimer544)"
		"muha":
			colin.sprite_frames = load("res://skins/muha_player_skin.tres")
			$Label.text = "Муха Груша"
			$Label2.text = "мяу"
			$Label3.text = "автор: Paper_Shaverma (Захар М.)"
		"solider":
			colin.sprite_frames = load("res://skins/solider_colin_skin.tres")
			$Label.text = "Солдат"
			$Label2.text = "пережил многое."
			$Label3.text = "автор: TheNamelessDeity"
		"yay basket ^w^":
			colin.sprite_frames = load("res://skins/basket_colin_skin.tres")
			$Label.text = "Колин с мусорной корзиной"
			$Label2.text = "- ВОУ ЧУВАК ЭТО РЕАЛЬНО КРУТОЙ БАГ ХАХАХА"
			$Label3.text = "автор: TheNamelessDeity
			придумал: Tapoksila"
		"paladin":
			colin.sprite_frames = load("res://skins/paladin_skin.tres")
			$Label.text = "паладин"
			$Label2.text = "могучий рыцарь, охранявший лабораторию."
			$Label3.text = "автор: TheNamelessDeity"
	
	$lock.visible = !Global.listskins[curskin]["unlocked"]
	$btnexit.disabled = !Global.listskins[curskin]["unlocked"]
	
	if save: SavingManager.save("skins", Global.colinskin); colin.playanim();
	#if save: SavingManager.save("skinlist", Global.listskins)
	SavingManager.save("curskin", curskin)
	
	colin.play("idle")
