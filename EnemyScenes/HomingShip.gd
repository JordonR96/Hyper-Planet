extends 'Enemy.gd'

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
export var rotation_speed = 20

var target = null

func set_target( _target):
	# add this line:
	target = _target


	
# Called when the node enters the scene tree for the first time.
func _ready():
	
	$LifeTimer.wait_time = life_time
	$LifeTimer.start()
	$AnimationPlayer.play('Fly')
	velocity =  Vector2(0, 1).rotated(rotation)
	
func _dead():
	


	if (!dead):
		target = null
		dead = true
		$AnimationPlayer.play(dead_animation_name)

		$CollisionShape2D.disabled = true
		
		if (use_explosion == 'Yes'):
			emit_signal('add_explosion', explosion, position)
			
			


	
func _process(delta):
	if (health > 0):
		var desired_direction = target.global_position - global_position
		desired_direction = desired_direction.normalized()
		
		var rotateAmount = desired_direction.cross(transform.y)
		rotation -= rotateAmount * delta * rotation_speed
	
		var velocity = Vector2(0, 1 ).rotated(rotation) * speed * delta
		position += velocity

	if (health <= 0 ):
		_dead()
		emit_signal("enemy_dead")
		

		
