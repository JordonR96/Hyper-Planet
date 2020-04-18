extends Area2D

# TODO will need to set these on instantiate
var velocity = Vector2()
export (int) var speed
export (int) var damage
export (float) var lifetime


# Called when the node enters the scene tree for the first time.

func start(_position, _direction):
	position = _position
	rotation = _direction.angle() + PI/2
	

	$LifeTime.wait_time = lifetime
	$LifeTime.start()
	## TODO make the liftime timer kill bullet on timoute
	velocity = _direction * speed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	# TODO will need to move bullet in direction set by player
	# will need todo this in main scene
	position += velocity * delta


	pass


func _on_Bullet_area_entered(area):

	queue_free()
	if (area.has_method('take_damage')):
		area.take_damage(damage)



func _on_LifeTime_timeout():
	print('bullet gone')
	queue_free()
