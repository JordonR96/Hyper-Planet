extends 'Enemy.gd'

export (int) var shoot_timer_wait
export (String, 'Right', 'Left') var x_direction_name 
var x_direction
var velocity 
# Declare member variables here. Examples: TODO bullets nmpt shjooting at right anmgle

# var a = 2
# var b = "text"
var Bullet  = preload("res://EnemyScenes/SDBullet.tscn")
# list of spawn locations, 0 is closest to back of shi[]

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# TODO set correct animation direction
	# TODO positions not work
	# get array of bullet spawn positions
	if (x_direction_name == 'Left'):
		x_direction = -1;
		$AnimationPlayer.play('Left')
	elif(x_direction_name == 'Right'):
		$AnimationPlayer.play('Right')
		x_direction = +1;
	
	
	velocity = Vector2(x_direction, 0) * speed
	# TODO should set it to randm number, based on speed and screen width (so would shoot somewhere between start and being off screen)
	$ShootTimer.wait_time = shoot_timer_wait
	$ShootTimer.start()
	#`TODO will have direction left or right depending on spawn side of screen
	

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += velocity * delta


func _on_ShootTimer_timeout():
	print('shooitng')
	var bulletSpawnPositions = []
	
	# left is -x, right is + x need to choose between these depdning on side of spawn, randomis sopeef
	#randomise shoot patterns
	
	
	
	# TODO more complex shooting patterns, ie start to finish with wait time, 
	# finish to start
	# spawn even indexes then odd indexes

	if (x_direction_name == 'Left'):
		for i in range(6):
			bulletSpawnPositions.append(Vector2((global_position.x + 54) - (i * 24), global_position.y + 56))
		
	elif(x_direction_name == 'Right'):
		for i in range(6):
			bulletSpawnPositions.append(Vector2((global_position.x - 54) + (i * 24), global_position.y + 56))
	$ShootPlayer.play('Shoot')
	for spawn in bulletSpawnPositions:
		emit_signal('shoot', Bullet, spawn, Vector2(0,1) )
