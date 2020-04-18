extends 'Enemy.gd'

var x_direction_name = 'right'
var x_direction = -1

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Bullet  = preload("res://SDBullet.tscn")
# list of spawn locations, 0 is closest to back of shi[]




signal shoot(bullet, position, rotation)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# TODO set correct animation direction
	# TODO positions not work
	# get array of bullet spawn positions
	

	# TODO should set it to randm number, based on speed and screen width (so would shoot somewhere between start and being off screen)
	$ShootTimer.wait_time = 1
	$ShootTimer.start()
	#`TODO will have direction left or right depending on spawn side of screen
	
	#Vector2(-32,28), Vector2(-20,28), Vector2(-8,28), Vector2(4,28), Vector2(16,28), Vector2(28,28)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_ShootTimer_timeout():
	print('shooitng')
	var bulletSpawnPositions = []
	
	# TODO more complex shooting patterns, ie start to finish with wait time, 
	# finish to start
	# spawn even indexes then odd indexes
	# will neew to re calc global position each time we shoot maybe not as ist global_postiion var
	if (x_direction_name == 'left'):
		for i in range(6):
			bulletSpawnPositions.append(Vector2((global_position.x + 32) - (i * 12), global_position.y + 28))
		
	elif(x_direction_name == 'right'):
		for i in range(6):
			bulletSpawnPositions.append(Vector2((global_position.x - 32) + (i * 12), global_position.y + 28))

	for spawn in bulletSpawnPositions:
		emit_signal('shoot', Bullet, spawn, Vector2(0,1) )
