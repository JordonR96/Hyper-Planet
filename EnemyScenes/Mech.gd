extends 'Enemy.gd'


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play('Default')


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AttackTimer_timeout():
	# TODO when attacking fddont allow tht emech to die
	
	$AnimationPlayer.play("Attack")
	
## TODO some movement patternz
	
func _dead():
	## TODO play enemy dead animation, have some function that decides which one depending on enemy
	## need multiple dead animations to choose from

	if (!dead):
		dead = true
		$AttackTimer.stop()
		$AnimationPlayer.stop()
		$AnimationPlayer.play(dead_animation_name)
	
		## TODO maybe hide sprite in favour of explosions
		$CollisionShape2D.disabled = true
		$CollisionShape2D2.disabled = true
		$CollisionShape2D3.disabled = true
		$CollisionShape2D4.disabled = true
		$CollisionShape2D5.disabled = true
		if (use_explosion == 'Yes'):
			emit_signal('add_explosion', explosion, position)
	
func _on_AnimationPlayer_animation_finished(anim_name):
	if (anim_name == dead_animation_name):
		queue_free()
		
	if (anim_name == 'Attack' and !dead):
		$AnimationPlayer.play('Default')
