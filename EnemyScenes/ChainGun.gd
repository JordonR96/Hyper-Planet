extends 'Enemy.gd'

var Bullet  = preload("ChainGunBullet.tscn")
var enable_shoot = 'Yes'

var rotate_speed = 0;
var rotate_direction = +1
var rand_generate = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play('Default')
	
	rand_generate.randomize()
	speed = rand_generate.randi_range(0,50)
	
	rand_generate.randomize()
	rotate_speed = rand_generate.randi_range(0,4)
	
	rand_generate.randomize()
	rotation_degrees = rand_generate.randi_range(-90,90)

	rand_generate.randomize()
	$RotateTimer.set_wait_time(rand_generate.randf_range(0,1))

	rand_generate.randomize()
	$ShootTimer.set_wait_time(rand_generate.randf_range(0.1,0.5))
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (health <= 0):

		enable_shoot = 'No'
	

	var velocity = Vector2(0, 1 ).rotated(rotation) * speed * delta
	position += velocity

	rotation_degrees += rotate_speed * delta * rotate_direction

	



func _on_ShootTimer_timeout():
	
	if (enable_shoot == 'Yes'):
		#TODO get bullets soawn properly
		var changea = Vector2(0.5, 1).rotated(rotation)
		changea = changea * 15
		
		
		var changeb = Vector2(0.5, 1).rotated(rotation)
		changeb = changeb * -30
		
		var spawn1 = Vector2(global_position.x, global_position.y) + changea
		var spawn2 = Vector2(global_position.x, global_position.y) + changeb
		emit_signal('shoot', Bullet, spawn1, Vector2(0,1).rotated(rotation))
		emit_signal('shoot', Bullet, spawn2, Vector2(0,1).rotated(rotation))
	else: $ShootTimer.stop()




func _on_RotateTimer_timeout():
	rotate_direction *= -1
