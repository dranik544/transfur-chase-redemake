extends Node

var savepath = "user://tfcrdsave1.lmao"
var whatload


func save(what):
	var file = FileAccess.open(savepath, FileAccess.WRITE)
	file.store_var(what)
	file.close()

func load():
	var file = FileAccess.open(savepath, FileAccess.READ)
	whatload = file.get_var()
	file.close()
	
	return whatload
