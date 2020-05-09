extends 'Enemy.gd'


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Bomb  = preload("BombSmilerBomb.tscn")
var enable_shoot = 'Yes'

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play('Default')


func _dead():
	## TODO play enemy dead animation, have some function that decides which one depending on enemy
	## need multiple dead animations to choose from
	

	if (!dead):
		dead = true
		$AnimationPlayer.play(dead_animation_name)
	
		## TODO maybe hide sprite in favour of explosions
		$CollisionShape2D.disabled = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (health <= 0 ):

		enable_shoot = 'No'
		_dead()
		emit_signal("enemy_dead")

		

func _on_ShootTimer_timeout():
	if (enable_shoot == 'Yes'):
		enable_shoot == 'No'
		$AnimationPlayer.play("Shoot")
	
	


func _on_AnimationPlayer_animation_finished(anim_name):

	if (anim_name == dead_animation_name):
		queue_free()
	elif(anim_name == 'Shoot'):
		enable_shoot == 'Yes'
		var change = Vector2(0, 1).rotated(rotation)
		change = change * 5
		var spawn = Vector2(global_position.x, global_position.y) + change
		emit_signal('shoot', Bomb, spawn, Vector2(0,1).rotated(rotation))
		$AnimationPlayer.play("Default")
