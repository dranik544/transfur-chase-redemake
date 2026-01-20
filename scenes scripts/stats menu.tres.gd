extends CanvasLayer


func _ready() -> void:
	setach($control/scc/hboxc/vboxc/ach1,
	Global.achievements[0]["name"],
	Global.achievements[0]["desc"],
	load("res://sprites/achievement1ic.png"),
	Global.achievements[0]["unlocked"])
	
	setach($control/scc/hboxc/vboxc/ach2,
	Global.achievements[1]["name"],
	Global.achievements[1]["desc"],
	load("res://sprites/cat waaaa.png"),
	Global.achievements[1]["unlocked"])
	
	setach($control/scc/hboxc/vboxc/ach3,
	Global.achievements[2]["name"],
	Global.achievements[2]["desc"],
	load("res://sprites/achievement2ic.png"),
	Global.achievements[2]["unlocked"])
	
	setach($control/scc/hboxc/vboxc/ach4,
	Global.achievements[3]["name"],
	Global.achievements[3]["desc"],
	load("res://sprites/achievement6ic.png"),
	Global.achievements[3]["unlocked"])
	
	setach($control/scc/hboxc/vboxc/ach5,
	Global.achievements[4]["name"],
	Global.achievements[4]["desc"],
	load("res://sprites/achievement5ic.png"),
	Global.achievements[4]["unlocked"])
	
	setach($control/scc/hboxc/vboxc/ach6,
	Global.achievements[5]["name"],
	Global.achievements[5]["desc"],
	load("res://sprites/achievement4ic.png"),
	Global.achievements[5]["unlocked"])
	
	setach($control/scc/hboxc/vboxc/ach7,
	Global.achievements[6]["name"],
	Global.achievements[6]["desc"],
	load("res://sprites/achievement3ic.png"),
	Global.achievements[6]["unlocked"])
	
	setach($control/scc/hboxc/vboxc/ach8,
	Global.achievements[7]["name"],
	Global.achievements[7]["desc"],
	load("res://sprites/achievement7ic.png"),
	Global.achievements[7]["unlocked"])
	
	setach($control/scc/hboxc/vboxc/ach9,
	Global.achievements[8]["name"],
	Global.achievements[8]["desc"],
	load("res://sprites/achievement8ic.png"),
	Global.achievements[8]["unlocked"])
	
	setach($control/scc/hboxc/vboxc/ach10,
	Global.achievements[9]["name"],
	Global.achievements[9]["desc"],
	load("res://sprites/achievement9ic.png"),
	Global.achievements[9]["unlocked"])
	
	
	var total = 0
	var recomend
	
	for value in Global.generalstats:
		total += value
	
	var recomendkey: String
	if total < 0: recomendkey = "RATING_1"
	elif total < 75: recomendkey = "RATING_2"
	elif total < 120: recomendkey = "RATING_3"
	elif total < 275: recomendkey = "RATING_4"
	elif total < 750: recomendkey = "RATING_5"
	else: recomendkey = "RATING_6"
	
	var finalverdict = tr(recomendkey)
	var stats_text = tr("GENERAL_STATS_TEMPLATE").format({
		"boxes": str(Global.generalstats[0]),
		"doors": str(Global.generalstats[1]),
		"puddles": str(Global.generalstats[2]),
		"damage": str(Global.generalstats[3]),
		"vents": str(Global.generalstats[4]),
		"items": str(Global.generalstats[5]),
		"enemies": str(Global.generalstats[6]),
		"total": str(total),
		"verdict": finalverdict
	})
	
	$control/scc/hboxc/vboxc2/Label.text = stats_text

func setach(ach, title: String, desc: String, image: Texture, completed: bool):
	ach.get_node("mc/vbc/label").text = str(title)
	ach.get_node("mc/vbc/label2").text = str(desc)
	
	if image: ach.get_node("mc2/ic").texture = image
	else: ach.get_node("mc2/ic").texture = null
	
	ach.size = Vector2.ZERO
	
	if completed: ach.modulate = Color(1.0, 1.0, 1.0)
	else: ach.modulate = Color(0.49, 0.49, 0.49)
