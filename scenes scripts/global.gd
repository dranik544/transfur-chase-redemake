extends Node

var brokenboxes: int = 0
var brokendoors: int = 0
var touchedslimes: int = 0
var hitsfromenemies: int = 0
var openvents: int = 0
var useditems: int = 0

var iswinter: bool = false

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
	{"name": "пройти 1 локацию", "desc": "завершить 1 локацию любым способом.", "unlocked": false}, #id: 0
	
	{"name": "WAAAA!", "desc": "нажать на
	слизне-кота в меню.", "unlocked": false}, #id: 1
	
	{"name": "ВОУ КАКОЙ КРУТОЙ БАГ!", "desc": "застрять в корзине
	во время игры.", "unlocked": false}, #id: 2
	
	{"name": "OneShot", "desc": "завершить локацию не
	получив лещей", "unlocked": false}, #id: 3
	
	{"name": "новый гоооод!", "desc": "встретить событие
	Новый Год в игре.", "unlocked": false}, #id: 4
	
	{"name": "на волоске от смерти", "desc": "завершить локацию будучи
	почти трансфурмированным", "unlocked": false}, #id: 5
]

var recordpoints: int = 0

signal navibakereq()


func _ready() -> void:
	var now = Time.get_datetime_dict_from_system()
	iswinter = now.month == Time.Month.MONTH_DECEMBER or now.month == Time.Month.MONTH_JANUARY
	
	iswinter = false
	
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
	colinskin = SavingManager.load("skins")
	
	for skin in listskins:
		if SavingManager.load("skinlist").has(skin["name"]):
			skin["unlocked"] = SavingManager.load("skinlist")[skin["name"]]
	
	for ach in achievements:
		if SavingManager.load("achievements").has(ach["name"]):
			ach["unlocked"] = SavingManager.load("achievements")[ach["name"]]
	
	recordpoints = SavingManager.load("recordpoints")
	
	listskins[3]["unlocked"] = iswinter

func unlockachievement(id: int):
	if !achievements[id]["unlocked"]:
		achievements[id]["unlocked"] = true
		SavingManager.save("achievements", achievements)
func checkachievement(id: int):
	return achievements[id]["unlocked"]

func _process(delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if Input.is_action_pressed("CTRL+Q"):
			get_tree().quit()
