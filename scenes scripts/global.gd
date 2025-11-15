extends Node

var brokenboxes: int = 0
var brokendoors: int = 0
var touchedslimes: int = 0
var hitsfromenemies: int = 0
var openvents: int = 0
var useditems: int = 0

var colinskin: String = "colin"
var listskins = [
	{"name": "colin", "unlocked": true},
	{"name": "V1", "unlocked": false},
	{"name": "nightmare colin", "unlocked": false},
	{"name": "new year colin", "unlocked": false},
	{"name": "gold colin", "unlocked": false},
	{"name": "hank", "unlocked": false},
	{"name": "necoarc", "unlocked": false},
	{"name": "muha", "unlocked": false},
	{"name": "solider", "unlocked": false},
]

var recordpoints: int = 0

signal navibakereq()


func _ready() -> void:
	if SavingManager.load("skins") == null:
		SavingManager.save("skins", colinskin)
	if SavingManager.load("skinlist") == null:
		SavingManager.save("skinlist", listskins)
	if SavingManager.load("recordpoints") == null:
		SavingManager.save("recordpoints", recordpoints)
	colinskin = SavingManager.load("skins")
	listskins = SavingManager.load("skinlist")
	recordpoints = SavingManager.load("recordpoints")

func _process(delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if Input.is_action_pressed("CTRL+Q"):
			get_tree().quit()
