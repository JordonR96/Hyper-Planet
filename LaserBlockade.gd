extends "Enemy.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _break():
	$AnimationPlayer.queue('LaserBlockadeBreak')
	$AnimationPlayer.queue('Dead')
	$Beam.get_node('CollisionShape2D').disabled = true

func _on_LaserBlockade_visibility_changed():
	if (visible):
		$AnimationPlayer.play('LaserBlockadeStart')
		$Beam.get_node('CollisionShape2D').disabled = false
		$AnimationPlayer.queue('LaserBlockadeOn')
		
	if (!visible):
		queue_free()



func _on_LaserBlockade_enemy_dead():
	_break()


func _on_Beam_area_entered(area):

	if (area.has_method('take_damage')):
		area.take_damage(1)


func _on_AnimationPlayer_animation_finished(anim_name):
	if (anim_name == 'LaserBlockadeOn'):
		$AnimationPlayer.queue('LaserBlockadeOn')
