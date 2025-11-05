extends Node

var brokenboxes: int = 0
var brokendoors: int = 0
var touchedslimes: int = 0

var colinskin: String = ""

signal navibakereq()


func _ready() -> void:
	Global.colinskin = SavingManager.load()
