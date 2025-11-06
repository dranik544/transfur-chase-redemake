extends Node

var brokenboxes: int = 0
var brokendoors: int = 0
var touchedslimes: int = 0

var colinskin: String = "colin"

signal navibakereq()


func _ready() -> void:
	colinskin = SavingManager.load("skins")

func _process(delta: float) -> void:
	pass
