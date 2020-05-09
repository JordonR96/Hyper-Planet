extends 'res://EnemyScenes/Enemy.gd'

export (String) var animation_name 

func _ready():

	$AnimationPlayer.play(animation_name)
## TODO need connecting signal from main that when called will just que free
func _on_destroy_all_enemies():
	pass
func _dead():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func take_damage(amount):
	pass

func _on_Enemy_area_entered(area):
	if (area.has_method('take_damage')):
		area.take_damage(1)

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()

func _on_LifeTimer_timeout():
	pass
