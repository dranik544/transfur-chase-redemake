extends CanvasLayer

var curd: int = 0
var posd: Vector3 = Vector3.ZERO

@export var pl: CharacterBody3D
@export var cam: Camera3D

@export var dialogs = [
	["эй, ты!", "tv"],
	
	["я?", "pl"],
	
	["ДА ТЫ!", "tv"],
	
	["ты мне уже по
	горло стоишь!", "tv"],
	
	["постоянно ломаешь коробки
	и двери выламываешь!", "tv"],
	
	["А ТЫ СНАЧАЛА СВОИХ Б**ДСКИХ
	БЕЛЫХ ЧЕРТЕЙ УГОМОНИ!", "pl"],
	
	["они не под
	моим контролем.", "tv"],
	
	["всмысле?", "pl"],
	
	["ага, а ты что думал?
	я их создал и управляю
	ими только чтобы потроллить
	чувачка! бэбэбэ!", "tv"],
	
	["а ты кто вообще?
	где ты находишься?", "pl"],
	
	["...", "tv"],
	
	["???", "pl"]
]


func start():
	visible = true
	
	pl = get_tree().current_scene.get_node("player")
	cam = pl.get_node("center camera").get_node("cam")
	updatedialog()

func updatedialog():
	if curd <= dialogs.size():
		match dialogs[curd][1]:
			"tv":
				posd = $"../NavigationRegion3D/StaticBody3D/mesh1".global_position
			"pl":
				posd = pl.global_position
		$dialog.settext(dialogs[curd][0])

func _process(delta: float) -> void:
	if posd:
		$dialog.global_position = cam.unproject_position(posd)
		$dialog.global_position.x -= $dialog.size.x / 2
		$dialog.global_position.y += $dialog.size.y

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed("ENTER"):
		curd += 1
		updatedialog()
