extends Control

@export var pluspos: Vector2 = Vector2(25, 0)
var defpos


func _ready() -> void:
	defpos = $Sprite2D.position
	
	$Button.pressed.connect(btnpressed)

func _process(delta: float) -> void:
	$Sprite2D.position = lerp($Sprite2D.position, defpos, 10 * delta)

func btnpressed():$Sprite2D.position += pluspos
