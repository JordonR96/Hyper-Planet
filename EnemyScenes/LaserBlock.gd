extends "Enemy.gd"

var sound = false



# Called when the node enters the scene tree for the first time.
func _ready():
	
	if (sound):
		$AudioStreamPlayer2D.play()
	
	pass # Replace with function body.




	


func _on_AudioStreamPlayer2D_finished():
	$AudioStreamPlayer2D.play()
