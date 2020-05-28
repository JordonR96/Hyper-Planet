extends 'Enemy.gd'
var move = true
var rotate = false


var rotate_speed = 0;

var rand_generate = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play('Default')
	

	rand_generate.randomize()
	speed = rand_generate.randi_range(20,100)
	
	rand_generate.randomize()
	rotation_degrees = rand_generate.randi_range(0,360)
	
	rand_generate.randomize()
	$AttackTimer.set_wait_time(rand_generate.randi_range(0,3))




func _on_AttackTimer_timeout():
	# TODO when attacking fddont allow tht emech to die
	take_damage = 'No'
	move = false
	rotate = true
	rand_generate.randomize()
	rotate_speed = rand_generate.randi_range(0,360)
	$AnimationPlayer.play("Attack")

func _process(delta):
	if (health <= 0 ):
		_dead()
		emit_signal("enemy_dead")
		move = false
	
	if (move):
		var velocity = Vector2(0, 1 ).rotated(rotation) * speed * delta
		position += velocity
	
	if (rotate) :
		rotation_degrees += rotate_speed * delta
		
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
		take_damage = 'Yes'
		move = true
		rotate = false
		$AnimationPlayer.play('Default')
