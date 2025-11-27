extends CanvasLayer

var curd: int = 0
var posd: Vector3 = Vector3.ZERO

@export var pl: CharacterBody3D
@export var cam: Camera3D

@export var dialogs = [
	["Стоять.", "tv"],
	
	["?", "pl"],
	
	["Куда пошел? Я
	тебе разрешал?", "tv"],
	
	["А мне твое разрешение
	не требуется.", "pl"],
	
	["В общем не надо
	тебе идти дальше.", "tv"],
	
	["А почему?", "pl"],
	
	["А что я тебя останавливаю?
	Иди и сам узнаешь....", "tv"],
	
	["И знай я тебя предупреждал.", "tv"],
	
	["[shake]Как же ты задолбал со
	своими ловушками![/shake] Я тебя найду и ...", "pl"],
	
	["[wave]ХА! ХА! ХА![/wave] Я в другом городе
	(черт он действительно быстро приближается,
	надо подготовиться)", "tv"],
	
	["Я так то всё слышу. Да и как
	ты подготовишься? [wave]Автомат принесешь?[/wave]", "pl"],
	
	["Хм, а ведь это идея!
	Спасибо за совет!
	[wave]я пошеееел![/wave]", "tv"],
	
	["Э куда? А ловушки кто отрубит?....", "pl"],
	
	["...", "pl"],
	
	[".......", "pl"],
	
	["[shake]Как всегда всё самому надо делать.[/shake]", "pl"],
	
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
