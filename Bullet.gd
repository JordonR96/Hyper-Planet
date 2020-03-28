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
	
	print(_direction.angle() * 180/PI)
	$LifeTime.wait_time = lifetime
	velocity = _direction * speed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	# TODO will need to move bullet in direction set by player
	# will need todo this in main scene
	position += velocity * delta


	pass


func _on_Bullet_area_entered(area):
	if (area.has_method('take_damage')):
		area.take_damage(damage)
		queue_free()
