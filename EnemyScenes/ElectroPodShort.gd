extends Node2D

export (String, 'Yes', 'No') var uses_sound = 'No'

# Called when the node enters the scene tree for the first time.
func _ready():
	var rand_generate = RandomNumberGenerator.new()
		
	rand_generate.randomize()
	rotation_degrees = rand_generate.randi_range(-70, 70)
