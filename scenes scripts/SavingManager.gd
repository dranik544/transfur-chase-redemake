extends Node


func save(savefile: String, what):
	var savepath = "user://" + str(savefile) + ".sdb"
	
	var file = FileAccess.open(savepath, FileAccess.WRITE)
	if file:
		file.store_var(what)
		file.close()
		return true
	return false

func load(savefile):
	var savepath = "user://" + str(savefile) + ".sdb"
	
	if not FileAccess.file_exists(savepath):
		return null
	
	var file = FileAccess.open(savepath, FileAccess.READ)
	if file:
		var data = file.get_var()
		file.close()
		return data
	return null
