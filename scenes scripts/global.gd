extends Node

var brokenboxes: int = 0
var brokendoors: int = 0
var touchedslimes: int = 0
var hitsfromenemies: int = 0
var openvents: int = 0
var useditems: int = 0
var unsleepenemies: int = 0
var generalstats = [
	0, #broken boxes
	0, #broken doors
	0, #touched slimes
	0, #hits from enemies
	0, #open vents
	0, #used items
	0, #unsleep enemies
]

var iswinter: bool = false

var money: int = 999
var rerollmarketprice: int = 15

var colinskin: String = "colin"
var listskins = [
	{"name": "colin", "unlocked": true}, #id: 0
	{"name": "V1", "unlocked": false}, #id: 1
	{"name": "nightmare colin", "unlocked": false}, #id: 2
	{"name": "new year colin", "unlocked": false}, #id: 3
	{"name": "gold colin", "unlocked": false}, #id: 4
	{"name": "hank", "unlocked": false}, #id: 5
	{"name": "necoarc", "unlocked": false}, #id: 6
	{"name": "muha", "unlocked": false}, #id: 7
	{"name": "solider", "unlocked": false}, #id: 8
	{"name": "yay basket ^w^", "unlocked": false}, #id: 9
	{"name": "paladin", "unlocked": false}, #id: 10
]

var achievements = [
	{"name": tr("ACHIEVEMENT_1_NAME"), "desc": tr("ACHIEVEMENT_1_DESC"), "unlocked": false}, # Complete 1 location
	{"name": tr("ACHIEVEMENT_2_NAME"), "desc": tr("ACHIEVEMENT_2_DESC"), "unlocked": false}, # WAAAA!
	{"name": tr("ACHIEVEMENT_3_NAME"), "desc": tr("ACHIEVEMENT_3_DESC"), "unlocked": false}, # THIS GAME IS FULL OF BUGS!
	{"name": tr("ACHIEVEMENT_4_NAME"), "desc": tr("ACHIEVEMENT_4_DESC"), "unlocked": false}, # OneShot.
	{"name": tr("ACHIEVEMENT_5_NAME"), "desc": tr("ACHIEVEMENT_5_DESC"), "unlocked": false}, # New Yeeeeear!
	{"name": tr("ACHIEVEMENT_6_NAME"), "desc": tr("ACHIEVEMENT_6_DESC"), "unlocked": false}, # On the Brink of Death
	{"name": tr("ACHIEVEMENT_7_NAME"), "desc": tr("ACHIEVEMENT_7_DESC"), "unlocked": false}, # This game has sliding?!
	{"name": tr("ACHIEVEMENT_8_NAME"), "desc": tr("ACHIEVEMENT_8_DESC"), "unlocked": false}, # A Pack on the Tail
	{"name": tr("ACHIEVEMENT_9_NAME"), "desc": tr("ACHIEVEMENT_9_DESC"), "unlocked": false}, # Slow and Steady Wins the Race!
]

var recordpoints: int = 0

var settings = {
	"soundvolume": 100.0,
	"musicvolume": 75.0,
	"effects": true,
	"cabels": true,
	"winterevent": true,
	"windowmode": 0,
	"tubes": true,
	"beauty": true,
	"cammode": true,
	"shakescreen": true,
	"light": true,
	"betterai": false,
}

signal navibake()
signal updatesoundandmusic()
signal punchpl(damage)
signal hitdoor(damage)
signal pickupitem(player, checkdist)
signal turnlight(onoff)


func _ready() -> void:
	var now = Time.get_datetime_dict_from_system()
	iswinter = now.month == Time.Month.MONTH_DECEMBER or now.month == Time.Month.MONTH_JANUARY
	
	if SavingManager.load("skins") == null:
		SavingManager.save("skins", colinskin)
	if SavingManager.load("skinlist") == null:
		SavingManager.save("skinlist", listskins)
	if SavingManager.load("recordpoints") == null:
		SavingManager.save("recordpoints", recordpoints)
	if SavingManager.load("curskin") == null:
		SavingManager.save("curskin", 0)
	if SavingManager.load("achievements") == null:
		SavingManager.save("achievements", achievements)
	if SavingManager.load("generalstats") == null:
		SavingManager.save("generalstats", generalstats)
	if SavingManager.load("settings") == null or settings.size() != SavingManager.load("settings").size():
		SavingManager.save("settings", settings)
	colinskin = SavingManager.load("skins")
	
	if SavingManager.load("skinlist") != null:
		for i in range(listskins.size()):
			if i < SavingManager.load("skinlist").size():
				listskins[i]["unlocked"] = SavingManager.load("skinlist")[i]["unlocked"]
	
	if SavingManager.load("achievements") != null:
		for i in range(achievements.size()):
			if i < SavingManager.load("achievements").size():
				achievements[i]["unlocked"] = SavingManager.load("achievements")[i]["unlocked"]
	
	for i in range(generalstats.size()):
		if i < SavingManager.load("generalstats").size():
			generalstats[i] = SavingManager.load("generalstats")[i]
	
	settings = SavingManager.load("settings")
	recordpoints = SavingManager.load("recordpoints")
	
	listskins[3]["unlocked"] = iswinter
	
	updatewindowmode()

func unlockachievement(id: int):
	if !achievements[id]["unlocked"]:
		achievements[id]["unlocked"] = true
		SavingManager.save("achievements", achievements)
		return true
	return false
func checkachievement(id: int):
	return achievements[id]["unlocked"]

func updatewindowmode():
	match settings["windowmode"]:
		0: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		1: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _process(delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if Input.is_action_pressed("CTRL+Q"): get_tree().quit()
		if Input.is_action_pressed("DOSKA"): get_tree().change_scene_to_file("res://doskapochteniya.tscn")
