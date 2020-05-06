extends Area2D

# TODO will need to set these on instantiate
var velocity = Vector2()
export (int) var speed
export (int) var damage
export (float) var lifetime

export (String, 'Yes', 'No') var delete_on_collision = 'Yes'

# Called when thex node enters the scene tree for the first time.

func start(_position, _direction):
	position = _position
	rotation = _direction.angle() + PI/2
	

	$LifeTime.wait_time = lifetime
	$LifeTime.start()
	## TODO make the liftime timer kill bullet on timoute
	velocity = _direction * speed
	
	$AnimationPlayer.play('shoot')
	
## TODO need connecting signal from main that when called will just que free
func _on_destroy_all_enemies():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	# TODO will need to move bullet in direction set by player
	# will need todo this in main scene
	position += velocity * delta


	pass


func _on_Bullet_area_entered(area):
	
	print('collision')
	
	if (delete_on_collision == 'Yes'):
		queue_free()
		
	if (area.has_method('take_damage')):
		area.take_damage(damage)



func _on_LifeTime_timeout():

	queue_free()
