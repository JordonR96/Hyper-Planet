extends 'Enemy.gd'

# TODO smoother death anim

export (int) var shoot_timer_wait
export (String, 'Right', 'Left') var x_direction_name 
var x_direction
var velocity
var rand_generate = RandomNumberGenerator.new()
# Declare member variables here. Examples: TODO bullets nmpt shjooting at right anmgle

var Bullet  = preload("res://EnemyScenes/SDBullet.tscn")
# list of spawn locations, 0 is closest to back of shi[]

# Called when the node enters the scene tree for the first time.
func _ready():
	rand_generate.randomize()
	speed = rand_generate.randi_range(50,200)
	
	rand_generate.randomize()
	shoot_timer_wait = rand_generate.randf_range(0.3,360/speed)
	
	
	# get array of bullet spawn positions
	if (x_direction_name == 'Left'):
		x_direction = -1;
		$AnimationPlayer.play('Left')
	elif(x_direction_name == 'Right'):
		$AnimationPlayer.play('Right')
		x_direction = +1;
	
	
	velocity = Vector2(x_direction, 0) * speed

	$ShootTimer.wait_time = shoot_timer_wait
	$ShootTimer.start()

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += velocity * delta


func _on_ShootTimer_timeout():
	print('shooitng')
	var bulletSpawnPositions = []
	
	# left is -x, right is + x need to choose between these depdning on side of spawn, randomis sopeef
	#randomise shoot patterns
	
	

	if (x_direction_name == 'Left'):
		for i in range(6):
			bulletSpawnPositions.append(Vector2((global_position.x + 54) - (i * 24), global_position.y + 56))
		
	elif(x_direction_name == 'Right'):
		for i in range(6):
			bulletSpawnPositions.append(Vector2((global_position.x - 54) + (i * 24), global_position.y + 56))
	$ShootPlayer.play('Shoot')
	for spawn in bulletSpawnPositions:
		emit_signal('shoot', Bullet, spawn, Vector2(0,1) )
