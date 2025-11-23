extends Node2D


func _ready() -> void:
	setach($scc/hboxc/vboxc/ach1,
	Global.achievements[0]["name"],
	Global.achievements[0]["desc"],
	load("res://sprites/achievement1ic.png"),
	Global.achievements[0]["unlocked"])
	
	setach($scc/hboxc/vboxc/ach2,
	Global.achievements[1]["name"],
	Global.achievements[1]["desc"],
	null,
	Global.achievements[1]["unlocked"])
	
	setach($scc/hboxc/vboxc/ach3,
	Global.achievements[2]["name"],
	Global.achievements[2]["desc"],
	load("res://sprites/achievement2ic.png"),
	Global.achievements[2]["unlocked"])
	
	setach($scc/hboxc/vboxc/ach4,
	Global.achievements[3]["name"],
	Global.achievements[3]["desc"],
	load("res://sprites/achievement6ic.png"),
	Global.achievements[3]["unlocked"])
	
	setach($scc/hboxc/vboxc/ach5,
	Global.achievements[4]["name"],
	Global.achievements[4]["desc"],
	load("res://sprites/achievement5ic.png"),
	Global.achievements[4]["unlocked"])
	
	setach($scc/hboxc/vboxc/ach6,
	Global.achievements[5]["name"],
	Global.achievements[5]["desc"],
	load("res://sprites/achievement4ic.png"),
	Global.achievements[5]["unlocked"])
	
	setach($scc/hboxc/vboxc/ach7,
	Global.achievements[6]["name"],
	Global.achievements[6]["desc"],
	load("res://sprites/achievement3ic.png"),
	Global.achievements[6]["unlocked"])
	
	var total = 0
	var recomend
	
	for value in Global.generalstats:
		total += value
	
	if total < 0:
		recomend = "позорно!"
	elif total >= 0 and total < 20:
		recomend = "даже моя бабушка играет лучше"
	elif total >= 20 and total < 40:
		recomend = "неплохо!"
	elif total >= 40 and total < 65:
		recomend = "отлично!"
	elif total >= 65:
		recomend = "великолепно!"
	
	$scc/hboxc/vboxc2/Label.text = "
	общая статистика:
	
	
	всего сломано коробок: " + str(Global.generalstats[0]) + "
	всего выломано дверей: " + str(Global.generalstats[1]) + "
	всего тронуто луж: " + str(Global.generalstats[2]) + "
	всего получил лещей: " + str(Global.generalstats[3]) + "
	всего открыто люков: " + str(Global.generalstats[4]) + "
	всего использовано предметов: " + str(Global.generalstats[5]) + "
	пробуждено врагов: " + str(Global.generalstats[6]) + "
	
	общее итого: " + str(total) + "
	вердикт: " + recomend

func setach(ach, title: String, desc: String, image: Texture, completed: bool):
	ach.get_node("mc").get_node("vbc").get_node("label").text = str(title)
	ach.get_node("mc").get_node("vbc").get_node("label2").text = str(desc)
	
	if image: ach.get_node("mc2").get_node("ic").texture = image
	else: ach.get_node("mc2").get_node("ic").texture = null
	
	ach.size = Vector2.ZERO
	
	if completed: ach.modulate = Color(1.0, 1.0, 1.0)
	else: ach.modulate = Color(0.49, 0.49, 0.49)
