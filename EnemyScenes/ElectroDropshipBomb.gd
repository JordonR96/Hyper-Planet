extends 'res://Bullet.gd'

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play('Off')
	
	pass # Replace with function body.

func _on_OnTimer_timeout():
	print('playing')
	$AnimationPlayer.play('Start')


func _on_AnimationPlayer_animation_finished(anim_name):
	if (anim_name == 'Start'):
		$AnimationPlayer.play('On')


func _on_Sound_finished():
	$Sound.play()
