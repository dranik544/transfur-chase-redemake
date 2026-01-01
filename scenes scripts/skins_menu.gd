extends Control

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
			$vbox/Label2.text = tr("COLIN_DEFAULT_DESC")
			$Label3.text = tr("COLIN_DEFAULT_AUTHOR")
		"V1":
			colin.sprite_frames = load("res://skins/v1_player_skin.tres")
			$Label.text = tr("V1_NAME")
			$vbox/Label2.text = tr("V1_DESC")
			$Label3.text = tr("V1_AUTHOR")
		"nightmare colin":
			colin.sprite_frames = load("res://skins/nightmare_player_skin.tres")
			$Label.text = tr("COLIN_NIGHTMARE_NAME")
			$vbox/Label2.text = tr("COLIN_NIGHTMARE_DESC")
			$Label3.text = tr("COLIN_NIGHTMARE_AUTHOR")
		"new year colin":
			colin.sprite_frames = load("res://skins/new_year_colin_skin.tres")
			$Label.text = tr("COLIN_NEWYEAR_NAME")
			$vbox/Label2.text = tr("COLIN_NEWYEAR_DESC")
			$Label3.text = tr("COLIN_NEWYEAR_AUTHOR")
		#"gold colin":
			#colin.sprite_frames = load("res://skins/player_sprite.tres")
			#$Label.text = "ЗОЛОТОЙ КОЛИН"
			#$vbox/Label2.text = "чувак ты где его нашёл?!
			#(даётся за полное закрытие всех достижений)"
			#$Label3.text = "автор: TheNamelessDeity"
		"hank":
			colin.sprite_frames = load("res://skins/hank_player_skin.tres")
			$Label.text = tr("HANK_NAME")
			$vbox/Label2.text = tr("HANK_DESC")
			$Label3.text = tr("HANK_AUTHOR")
		"necoarc":
			colin.sprite_frames = load("res://skins/necoarc_player_skin.tres")
			$Label.text = tr("NECOARC_NAME")
			$vbox/Label2.text = tr("NECOARC_DESC")
			$Label3.text = tr("NECOARC_AUTHOR")
		"muha":
			colin.sprite_frames = load("res://skins/muha_player_skin.tres")
			$Label.text = tr("MUHAPEAR_NAME")
			$vbox/Label2.text = tr("MUHAPEAR_DESC")
			$Label3.text = tr("MUHAPEAR_AUTHOR")
		"solider":
			colin.sprite_frames = load("res://skins/solider_colin_skin.tres")
			$Label.text = tr("SOLIDER_NAME")
			$vbox/Label2.text = tr("SOLIDER_DESC")
			$Label3.text = tr("SOLIDER_AUTHOR")
		"yay basket ^w^":
			colin.sprite_frames = load("res://skins/basket_colin_skin.tres")
			$Label.text = tr("COLIN_BASKET_NAME")
			$vbox/Label2.text = tr("COLIN_BASKET_DESC")
			$Label3.text = tr("COLIN_BASKET_AUTHOR")
		"paladin":
			colin.sprite_frames = load("res://skins/paladin_skin.tres")
			$Label.text = "паладин"
			$vbox/Label2.text = "могучий рыцарь, охранявший лабораторию."
			$Label3.text = "автор: TheNamelessDeity"
	
	$lock.visible = !Global.listskins[curskin]["unlocked"]
	$vbox/btnexit.disabled = !Global.listskins[curskin]["unlocked"]
	
	if save: SavingManager.save("skins", Global.colinskin); colin.playanim();
	#if save: SavingManager.save("skinlist", Global.listskins)
	SavingManager.save("curskin", curskin)
	
	colin.play("idle")
