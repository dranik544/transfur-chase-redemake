extends CanvasLayer

var curd: int = 0
var posd: Vector3 = Vector3.ZERO

@export var pl: CharacterBody3D
@export var cam: Camera3D

@export var dialogs = [
	["эй, ты!", "tv"],
	
	["я?", "pl"],
	
	["[shake]ДА ТЫ![/shake]", "tv"],
	
	["[shake]ты мне уже по
	горло стоишь![/shake]", "tv"],
	
	["[shake]постоянно ломаешь коробки
	и двери выламываешь![/shake]", "tv"],
	
	["[shake]А ТЫ СНАЧАЛА СВОИХ Б**ДСКИХ
	БЕЛЫХ ЧЕРТЕЙ УГОМОНИ![/shake]", "pl"],
	
	["они не под
	моим контролем.", "tv"],
	
	["всмысле?", "pl"],
	
	["ага, а ты что думал?
	я их создал и управляю
	ими только чтобы потроллить
	чувачка! [wave]бэ-бэ-бэ![/wave]", "tv"],
	
	["а ты кто вообще?
	где ты находишься?", "pl"],
	
	["[color=#470000]...[color=]", "tv"],
	
	["???", "pl"],
	
	["[color=#470000]...[color=]", "tv"],
	
	["ну, сколько там осталось
	до конца минуты молчания?", "pl"],
	
	["[tornado]Cвязь потеряна, для большей информации обратитесь
	в службу поддержки ihsioK TV по ссылке https://ihsioktv.by/tv/help/,
	опишите вашу проблему и ждите ответа на ваш
	номер телефона. с уважением, ihsioK TV![/tornado]", "tv"],
	
	["[shake]ДА ЧТОБ ТЕБЯ!!![/shake]", "pl"],
	
	["ЛОШАРАААА! [wave]ХА-ХА!!![/wave]", "tv"],
	
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
		
		var sizew = Vector2(640, 480)
		$dialog.global_position.x = clamp($dialog.global_position.x, 10, sizew.x - $dialog.size.x - 10)
		$dialog.global_position.y = clamp($dialog.global_position.y, 10, sizew.y - $dialog.size.y - 10)
		
		updatedialog(true)
		
		if curd >= dialogs.size() - 1:
			get_tree().change_scene_to_file("res://scenes scripts/end.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed("ENTER"):
		curd += 1
		updatedialog()
