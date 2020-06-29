extends Area2D

# TODO will need to set these on instantiate
var velocity = Vector2()
export (int) var speed
export (int) var damage
export (float) var lifetime
export (PackedScene) var explosion;
export (String, 'Yes', 'No') var use_explosion = 'No'
export (String, 'Yes', 'No') var delete_on_collision = 'Yes'

signal add_explosion
# Called when thex node enters the scene tree for the first time.

func play_sound():
	$Sound.play()



func start(_position, _direction):
	position = _position
	rotation = _direction.angle() + PI/2
	

	$LifeTime.wait_time = lifetime

	## TODO make the liftime timer kill bullet on timoute
	velocity = _direction * speed
	

	
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

	if (delete_on_collision == 'Yes'):		
		if (use_explosion == 'Yes'):

			emit_signal('add_explosion', explosion, position)
		queue_free()
		
	if (area.has_method('take_damage')):
		area.take_damage(damage)



func _on_LifeTime_timeout():

	queue_free()
