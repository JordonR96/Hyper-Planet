extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready():
	var rand_generate = RandomNumberGenerator.new()
		
	rand_generate.randomize()
	rotation_degrees = rand_generate.randi_range(0,360)
