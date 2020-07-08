extends "Enemy.gd"

var repeat_ambient_sound = true;
var sound = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if (sound):
		$AudioStreamPlayer2D.play()
	pass

func _on_LaserBlockade_visibility_changed():
	if (visible):
		$AnimationPlayer.play('LaserBlockadeStart')
		$Beam.get_node('CollisionShape2D').disabled = false

		
	if (!visible):
		queue_free()

func _on_LaserBlockade_enemy_dead():
	$Beam.get_node('CollisionShape2D').disabled = true

func _on_Beam_area_entered(area):

	if (area.has_method('take_damage')):
		area.take_damage(1)


func _on_AnimationPlayer_animation_finished(anim_name):

	if (anim_name == dead_animation_name):
		
		$AnimationPlayer.play('LaserBlockadeOff')
		

	if (anim_name ==  'LaserBlockadeStart'):
		
		if (sound):
			$AudioStreamPlayer2D.stop()
			$Ambient.play()
		$AnimationPlayer.play('LaserBlockadeOn')







