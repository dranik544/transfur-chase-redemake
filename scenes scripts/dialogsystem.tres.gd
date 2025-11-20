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
	чувачка! бэ-бэ-бэ!", "tv"],
	
	["а ты кто вообще?
	где ты находишься?", "pl"],
	
	["...", "tv"],
	
	["???", "pl"],
	
	["...", "tv"],
	
	["ну, сколько там осталось
	до конца минуты молчания?", "pl"],
	
	["Cвязь потеряна, для большей информации обратитесь
	в службу поддержки ihsioK TV по ссылке https://ihsioktv.by/tv/help/,
	опишите вашу проблему и ждите ответа на ваш
	номер телефона. с уважением, ihsioK TV!", "tv"],
	
	["ДА ЧТОБ ТЕБЯ!!!", "pl"],
	
	["ЛОШАРАААА! ХА-ХА!!!", "tv"],
	
	["", ""]
]


func start():
	visible = true
	
	pl = get_tree().current_scene.get_node("player")
	cam = pl.get_node("center camera").get_node("cam")
	pl.get_node("gui").get_node("gui").visible = false
	
	updatedialog()

func updatedialog(updonlyposd: bool = false):
	if curd <= dialogs.size():
		match dialogs[curd][1]:
			"tv":
				posd = $"../NavigationRegion3D/StaticBody3D/mesh1".global_position
			"pl":
				posd = pl.global_position
			"":
				return
		
		if !updonlyposd:
			$dialog.settext(dialogs[curd][0])

func _process(delta: float) -> void:
	if posd:
		$dialog.global_position = cam.unproject_position(posd)
		$dialog.global_position.x -= $dialog.size.x / 2
		$dialog.global_position.y += 24
		
		var sizew = get_viewport().get_window().size
		$dialog.global_position.x = clamp($dialog.global_position.x, 5, sizew.x - $dialog.size.x - 5)
		$dialog.global_position.y = clamp($dialog.global_position.y, 5, sizew.y - $dialog.size.y - 5)
		
		updatedialog(true)
		
		if curd >= dialogs.size() - 1:
			get_tree().change_scene_to_file("res://scenes scripts/end.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed("ENTER"):
		curd += 1
		updatedialog()
