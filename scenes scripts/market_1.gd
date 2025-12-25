extends StaticBody3D

var items = {
	1: {"price": 10, "scene": preload("res://scenes scripts/item_2.tscn"), "texture": preload("res://sprites/healitem1.png")}, # heal
	2: {"price": 25, "scene": preload("res://scenes scripts/item_3.tscn"), "texture": preload("res://sprites/tube1.png")}, # tube
	3: {"price": 25, "scene": preload("res://scenes scripts/item_4.tscn"), "texture": preload("res://sprites/halat1.png")}, # halat
}
var playerin: bool = false


func _ready() -> void:
	$Area3D.body_entered.connect(bodyentered)
	$Area3D.body_exited.connect(bodyexited)
	$CanvasLayer/NinePatchRect/exit.pressed.connect(exit)
	$CanvasLayer/NinePatchRect/price3/Label.text = ". . ."
	
	$CanvasLayer/NinePatchRect.modulate.a = 0.0
	
	spawnitems()

func bodyentered(body):
	if body.is_in_group("player"):
		playerin = true
		Engine.time_scale = 0.05
		var tween = create_tween()
		tween.set_ignore_time_scale(true)
		tween.tween_property($CanvasLayer/NinePatchRect, "modulate:a", 1.0, 0.25)

func bodyexited(body):
	if body.is_in_group("player"):
		exit()

func exit():
	playerin = false
	Engine.time_scale = 1.0
	var tween = create_tween()
	tween.set_ignore_time_scale(true)
	tween.tween_property($CanvasLayer/NinePatchRect, "modulate:a", 0.0, 0.25)

func spawnitems():
	var cheapitems = []
	var mediumitems = []
	
	for i in items.size():
		if items[i + 1]:
			if items[i + 1]["price"] == 10: cheapitems.push_back(items[i + 1])
			if items[i + 1]["price"] == 25: mediumitems.push_back(items[i + 1])
	
	print("cheap items: ", cheapitems)
	print("medium items: ", mediumitems)
	
	for i in 7:
		var button: Button = get_node("CanvasLayer/NinePatchRect/item" + str(i + 1))
		print(button)
		
		var randomnull = randi_range(1, 4)
		if button:
			if randomnull == 1:
				button.visible = false
				button.disabled = true
				continue
			else:
				if i <= 2 and cheapitems.size() > 0:
					var randitem = randi_range(0, cheapitems.size() - 1)
					button.icon = cheapitems[randitem]["texture"]
					button.set_meta("itemdata", {
						"item": randitem,
						"price": cheapitems[randitem]["price"],
						"scene": cheapitems[randitem]["scene"],
					})
				if i > 2 and i <= 5 and mediumitems.size() > 0:
					var randitem = randi_range(0, mediumitems.size() - 1)
					button.icon = mediumitems[randitem]["texture"]
					button.set_meta("itemdata", {
						"item": randitem,
						"price": mediumitems[randitem]["price"],
						"scene": mediumitems[randitem]["scene"],
					})
				if i == 6:
					var randitem = randi_range(0, items.size() - 1)
					button.icon = items[randitem]["texture"]
					button.set_meta("itemdata", {
						"item": randitem,
						"price": items[randitem]["price"] / 2,
						"scene": items[randitem]["scene"],
					})
					$CanvasLayer/NinePatchRect/price3/Label.text = str(items[randitem]["price"] / 2) + " (-50%!)"
