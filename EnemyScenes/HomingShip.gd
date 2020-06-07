extends 'Enemy.gd'

#TODO it seeks but nor very well asnd doesnt travel in direction its facing


var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
export var steer_force = 50.0

var target = null

func set_target( _target):
	# add this line:
	target = _target

func seek():
	var steer = Vector2.ZERO
	if target:
		var desired = (target.position - position).normalized() * speed
		steer = (desired - velocity).normalized() * steer_force
	return steer
	
# Called when the node enters the scene tree for the first time.
func _ready():
	
	$LifeTimer.wait_time = life_time
	$LifeTimer.start()
	$AnimationPlayer.play('Fly')
	velocity = transform.y * speed
	
func _dead():

	if (!dead):
		target = null
		dead = true
		$AnimationPlayer.play(dead_animation_name)

		$CollisionShape2D.disabled = true
		
		if (use_explosion == 'Yes'):
			emit_signal('add_explosion', explosion, position)
			
			


	
func _process(delta):
	
	print(rotation_degrees)
	acceleration += seek()
	velocity += acceleration * delta
	velocity = velocity.clamped(speed)
	rotation = velocity.angle()
	position += velocity * delta
	if (health <= 0 ):
		_dead()
		emit_signal("enemy_dead")
		
		##TODO make it home on player
		
