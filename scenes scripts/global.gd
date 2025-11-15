extends Node

var brokenboxes: int = 0
var brokendoors: int = 0
var touchedslimes: int = 0

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

signal navibakereq()


func _ready() -> void:
	if SavingManager.load("skins") == null:
		SavingManager.save("skins", colinskin)
	if SavingManager.load("skinlist") == null:
		SavingManager.save("skinlist", listskins)
	colinskin = SavingManager.load("skins")
	listskins = SavingManager.load("skinlist")

func _process(delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if Input.is_action_pressed("CTRL+Q"):
			get_tree().quit()
