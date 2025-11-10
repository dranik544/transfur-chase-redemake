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

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if Input.is_action_pressed("CTRL+Q"):
			get_tree().quit()
