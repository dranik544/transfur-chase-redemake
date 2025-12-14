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
	
	match Global.colinskin: #localization: skins.csv
		"colin":
			colin.sprite_frames = load("res://skins/player_sprite.tres")
			$Label.text = tr("COLIN_DEFAULT_NAME")
			$Label2.text = tr("COLIN_DEFAULT_DESC")
			$Label3.text = tr("COLIN_DEFAULT_AUTHOR")
		"V1":
			colin.sprite_frames = load("res://skins/v1_player_skin.tres")
			$Label.text = tr("V1_NAME")
			$Label2.text = tr("V1_DESC")
			$Label3.text = tr("V1_AUTHOR")
		"nightmare colin":
			colin.sprite_frames = load("res://skins/nightmare_player_skin.tres")
			$Label.text = tr("COLIN_NIGHTMARE_NAME")
			$Label2.text = tr("COLIN_NIGHTMARE_DESC")
			$Label3.text = tr("COLIN_NIGHTMARE_AUTHOR")
		"new year colin":
			colin.sprite_frames = load("res://skins/new_year_colin_skin.tres")
			$Label.text = tr("COLIN_NEWYEAR_NAME")
			$Label2.text = tr("COLIN_NEWYEAR_DESC")
			$Label3.text = tr("COLIN_NEWYEAR_AUTHOR")
		#"gold colin":
			#colin.sprite_frames = load("res://skins/player_sprite.tres")
			#$Label.text = "ЗОЛОТОЙ КОЛИН"
			#$Label2.text = "чувак ты где его нашёл?!
			#(даётся за полное закрытие всех достижений)"
			#$Label3.text = "автор: TheNamelessDeity"
		"hank":
			colin.sprite_frames = load("res://skins/hank_player_skin.tres")
			$Label.text = tr("HANK_NAME")
			$Label2.text = tr("HANK_DESC")
			$Label3.text = tr("HANK_AUTHOR")
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
