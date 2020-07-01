extends 'Enemy.gd'

func _ready():

	$AnimationPlayer.play('On')
	
	



func _on_AudioStreamPlayer2D_finished():
	$AudioStreamPlayer2D.play()
