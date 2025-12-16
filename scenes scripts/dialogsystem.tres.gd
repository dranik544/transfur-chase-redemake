extends CanvasLayer

var curd: int = 0
var posd: Vector3 = Vector3.ZERO

@export var pl: CharacterBody3D
@export var cam: Camera3D

@export var dialogs = [
	["[shake]Так, ты![/shake]", "tv"],
	
	["Я?", "pl"],
	
	["[wave]Да ты![/wave] Кроме тебя тут
	в комплексе нет никого...", "tv"],
	
	["В смысле никого нет?!", "pl"],
	
	["[shake]Не перебивай меня![/shake]
	Что ты тут, полоумный, устроил?", "tv"],
	["Латексных будишь, сам носишься
	как угарелый, ломая всё что под ноги
	попадётся.", "tv"],
	
	["[shake]А не надо своих животных
	на меня натравливать[/shake]! ", "pl"],
	
	["Во-первых, если бы ты был хоть
	чуточку терпеливее, то и бегать не пришлось,", "tv"],
	["но у тебя же в жопе свербит! 
	[wave]дай побегаю по комплексу.[/wave]", "tv"],
	
	["А если бы ты решил на меня
	их настроить, пока я там сидел?", "pl"],
	
	["[shake]Дай договорить то![/shake]
	[pulse]Кхем.[/pulse]", "tv"],
	["Во-вторых, я их не контролирую,
	и они делают что им вздумается.", "tv"],
	
	["Так стоп! То есть рядом с капсулами
	бродят агрессивные твари?", "pl"],
	["Что тут у вас творится?!", "pl"],
	
	["[color=#FF5555]Тебе мелкому
	знать не положено.[/color]", "tv"],
	["Тогда я сам узнаю, и они
	меня не остановят.", "pl"],
	
	["Не советую идти дальше...", "tv"],
	["Хотя, зная тебя, ты все равно пойдешь,", "tv"],
	["так что просто будь готов к
	маленьким неприятностям.", "tv"],
	["Сам решил выйти и мне по лбу надавать?", "pl"],
	
	["Зачем? В комплексе достаточно способов
	дистанционно тебе нагадить.", "tv"],
	["Зачем ты пытаешься меня остановить?", "pl"],
	["Что, страшно, что я твое наглое лицо разобью?", "pl"],
	
	["ТЫ?", "tv"],
	["МНЕ?", "tv"],
	["[wave]ХА! ХА! ХА![/wave] Как смешно.", "tv"],
	["Уверен, ты не пройдешь
	и десяти комнат дальше.", "tv"],
	["[pulse]Тихо: если, конечно,
	этот гандон не вмешается[/pulse]", "tv"],
	["Кто, кто?", "pl"],
	
	["[shake]Так, все[/shake],
	хватит этой болтовни.", "tv"],
	["Либо ты идешь к тем латексным,
	либо тебя [shake]сожрут[/shake]
	в следующей комнате.", "tv"],
	["Выбирай.", "tv"],
	
	["Ага, то есть уже нет
	выбора подождать.", "pl"],
	["Ну ладно, тогда я выберу
	набить тебе лицо.", "pl"],
	
	["[rainbow]Что могу сказать,
	можешь попытаться.[/rainbow]", "tv"],
	
	["end dialog", ""]
]


func start():
	visible = true
	
	pl = get_tree().current_scene.get_node("player")
	cam = pl.get_node("center camera").get_node("cam")
	pl.get_node("gui").get_node("gui").visible = false
	
	updatedialog()

func updatedialog(updonlyposd: bool = false):
	if curd <= dialogs.size() - 1:
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
			ScreenTransition.changescene("res://scenes scripts/end.tscn", Color.BLACK, 0.25)

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed("ENTER"):
		curd += 1
		updatedialog()
