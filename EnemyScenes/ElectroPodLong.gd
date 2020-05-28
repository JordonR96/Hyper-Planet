extends Node2D

func _ready():
	var rand_generate = RandomNumberGenerator.new()
		
	rand_generate.randomize()
	rotation_degrees = rand_generate.randi_range(-20,20)
