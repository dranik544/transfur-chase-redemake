extends CanvasLayer

var curd: int = 0
var posd: Vector3 = Vector3.ZERO

@export var pl: CharacterBody3D
@export var cam: Camera3D

var itstvtiimeeee: bool = false

@export var dialogs = [
	[tr("DIALOG_1_1"), "tv"],
	[tr("DIALOG_1_2"), "pl"],
	[tr("DIALOG_1_3"), "tv"],
	[tr("DIALOG_1_4"), "pl"],
	[tr("DIALOG_1_5"), "tv"],
	[tr("DIALOG_1_6"), "tv"],
	[tr("DIALOG_1_7"), "pl"],
	[tr("DIALOG_1_8"), "tv"],
	[tr("DIALOG_1_9"), "tv"],
	[tr("DIALOG_1_10"), "pl"],
	[tr("DIALOG_1_11"), "tv"],
	[tr("DIALOG_1_12"), "tv"],
	[tr("DIALOG_1_13"), "pl"],
	[tr("DIALOG_1_14"), "pl"],
	[tr("DIALOG_1_15"), "tv"],
	[tr("DIALOG_1_16"), "pl"],
	[tr("DIALOG_1_17"), "tv"],
	[tr("DIALOG_1_18"), "tv"],
	[tr("DIALOG_1_19"), "tv"],
	[tr("DIALOG_1_20"), "pl"],
	[tr("DIALOG_1_21"), "tv"],
	[tr("DIALOG_1_22"), "pl"],
	[tr("DIALOG_1_23"), "pl"],
	[tr("DIALOG_1_24"), "tv"],
	[tr("DIALOG_1_25"), "tv"],
	[tr("DIALOG_1_26"), "tv"],
	[tr("DIALOG_1_27"), "tv"],
	[tr("DIALOG_1_28"), "tv"],
	[tr("DIALOG_1_29"), "pl"],
	[tr("DIALOG_1_30"), "tv"],
	[tr("DIALOG_1_31"), "tv"],
	[tr("DIALOG_1_32"), "tv"],
	[tr("DIALOG_1_33"), "pl"],
	[tr("DIALOG_1_34"), "pl"],
	[tr("DIALOG_1_35"), "tv"],
	[tr("DIALOG_1_36"), ""]
]


func start():
	itstvtiimeeee = true
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
	if itstvtiimeeee:
		if Input.is_action_pressed("ENTER"):
			curd += 1
			updatedialog()
