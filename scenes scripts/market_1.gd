extends StaticBody3D

var items = {
	1: {"price": 10, "scene": preload("res://scenes scripts/item_2.tscn"), "texture": preload("res://sprites/healitem1.png")}, # heal
	2: {"price": 25, "scene": preload("res://scenes scripts/item_3.tscn"), "texture": preload("res://sprites/tube1.png")}, # tube
	3: {"price": 25, "scene": preload("res://scenes scripts/item_4.tscn"), "texture": preload("res://sprites/halat1.png")}, # halat
	4: {"price": 10, "scene": preload("res://scenes scripts/item_5.tscn"), "texture": preload("res://sprites/cocacola1.png")}, # energetik
	5: {"price": 30, "scene": preload("res://scenes scripts/item_6.tscn"), "texture": preload("res://sprites/pills1.png")}, # pills
}
var playerin: bool = false


func _ready() -> void:
	$Area3D.body_entered.connect(bodyentered)
	$Area3D.body_exited.connect(bodyexited)
	$CanvasLayer/NinePatchRect/hbox/exit.pressed.connect(exit)
	$CanvasLayer/NinePatchRect/hbox/reroll.pressed.connect(reroll)
	#$CanvasLayer/NinePatchRect/price3/Label.text = ". . ."
	
	$CanvasLayer/NinePatchRect.modulate.a = 0.0
	$CanvasLayer/NinePatchRect.position.x = get_tree().root.content_scale_size.x
	
	add_to_group("market")
	
	connectbuttons()
	spawnitems()

func bodyentered(body):
	if body.is_in_group("player"):
		playerin = true
		Engine.time_scale = 0.05
		var tween = create_tween()
		
		tween.set_ignore_time_scale(true)
		tween.set_parallel(true)
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_BACK)
		
		tween.tween_property($CanvasLayer/NinePatchRect, "modulate:a", 1.0, 0.5)
		tween.tween_property($CanvasLayer/NinePatchRect, "position:x", get_tree().root.content_scale_size.x - 270, 0.5)
		$CanvasLayer/NinePatchRect/money.text = str(Global.money)
		$CanvasLayer/NinePatchRect/hbox/exit.grab_focus()
		$CanvasLayer/NinePatchRect/hbox/reroll.text = str(Global.rerollmarketprice)

func bodyexited(body):
	if body.is_in_group("player"):
		exit()

func minusmoney(num: int):
	Global.money -= num
	$CanvasLayer/NinePatchRect/money.text = str(Global.money)
	$AudioStreamPlayer.volume_db = Global.settings["soundvolume"] / 10
	$AudioStreamPlayer.play()

func exit():
	playerin = false
	Engine.time_scale = 1.0
	var tween = create_tween()
	
	tween.set_ignore_time_scale(true)
	tween.set_parallel(true)
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_BACK)
	
	tween.tween_property($CanvasLayer/NinePatchRect, "modulate:a", 0.0, 0.4)
	tween.tween_property($CanvasLayer/NinePatchRect, "position:x", get_tree().root.content_scale_size.x, 0.4)

func reroll():
	if Global.money >= Global.rerollmarketprice:
		minusmoney(Global.rerollmarketprice)
		Global.rerollmarketprice += 5
		$CanvasLayer/NinePatchRect/hbox/reroll.text = str(Global.rerollmarketprice)
		
		spawnitems()

func connectbuttons():
	for i in range(1, 8):
		var button = get_node_or_null("CanvasLayer/NinePatchRect/item" + str(i))
		if button:
			button.pressed.connect(_on_item_button_pressed.bind(button))

func _on_item_button_pressed(button: Button):
	if not button.has_meta("itemdata") or !playerin:
		return
	
	if Global.money >= button.get_meta("itemdata")["price"]:
		minusmoney(button.get_meta("itemdata")["price"])
		
		var player = get_tree().get_first_node_in_group("player")
		var item: RigidBody3D = button.get_meta("itemdata")["scene"].instantiate()
		get_parent().add_child(item)
		item.global_position = player.global_position + Vector3(randf_range(-0.6, 0.6), 2, randf_range(-0.6, 0.6))
		if !player.isinv:
			item.pick(player, false)
		
		$CanvasLayer/NinePatchRect/pursacheeffect.position = button.position + button.size / 2
		$CanvasLayer/NinePatchRect/pursacheeffect.restart()
		$CanvasLayer/NinePatchRect/hbox/exit.grab_focus()
		
		button.visible = false
		button.disabled = true
	else:
		#print("недостаточно деньжат")
		pass

func spawnitems():
	var cheapitems = []
	var mediumitems = []
	
	#for i in items.size():
		#if items[i + 1]:
			#if items[i + 1]["price"] == 10: cheapitems.push_back(items[i + 1])
			#if items[i + 1]["price"] == 25: mediumitems.push_back(items[i + 1])
	
	for i in range(1, 8):
		var btn = get_node("CanvasLayer/NinePatchRect/item" + str(i))
		if btn:
			btn.text = ""
	
	#print("cheap items: ", cheapitems)
	#print("medium items: ", mediumitems)
	
	for i in 7:
		var button: Button = get_node("CanvasLayer/NinePatchRect/item" + str(i + 1))
		#print(button)
		
		var randomnull = randi_range(1, 4)
		if button:
			if randomnull == 1:
				button.visible = false
				button.disabled = true
				if i == 6: $CanvasLayer/NinePatchRect/discount.visible = false
				continue
			else:
				button.visible = true
				button.disabled = false
				
				var randitem = randi_range(1, items.size())
				var price = items[randitem]["price"]
				
				if i == 6:
					price = items[randitem]["price"] / 2
					$CanvasLayer/NinePatchRect/discount.visible = true
				
				button.icon = items[randitem]["texture"]
				button.text = str(price)
				
				#if price <= 15:
					#button.add_theme_color_override("font_color", Color.GREEN)
				#elif price <= 30:
					#button.add_theme_color_override("font_color", Color.YELLOW)
				#else:
					#button.add_theme_color_override("font_color", Color.RED)
				
				button.set_meta("itemdata", {
					"item": randitem,
					"price": price,
					"scene": items[randitem]["scene"],
				})
