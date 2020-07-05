extends Node

var high_score = 0 setget set_high_score
const filepath = 'user://high_score.data'

func _ready():
	load_high_score()

func load_high_score():
	var file = File.new()
	
	if not file.file_exists(filepath): return
	
	file.open(filepath, File.READ)
	high_score = file.get_var()
	file.close()
	
func save_high_score():
	var file = File.new()
	file.open(filepath, File.WRITE)
	file.store_var(high_score)
	file.close()
	
func set_high_score(new_score):
	high_score = new_score
	save_high_score()
