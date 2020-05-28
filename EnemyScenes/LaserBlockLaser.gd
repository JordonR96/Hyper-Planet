extends 'res://Bullet.gd'


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play('Off')
	


func _on_Timer_timeout():
	$AnimationPlayer.play('On')
