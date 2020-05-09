extends 'Enemy.gd'

var Bullet  = preload("ChainGunBullet.tscn")
var enable_shoot = 'Yes'
## TODO some movement patternz

## give some movement patterns (straight, diagonal, sinusoidal

#(have diff interval ranges for bomb drops)

## make it stay on screen ifront of player for a bit sometimes
## hagve range of time periods we can select from
## othertimes just comes on and off

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play('Default')
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (health <= 0):

		enable_shoot = 'No'
	var rotation_degree = rotation * (180/PI)
	
	# TODO make it rotate between values
	
	
	
	# TODO make it move a but then stationary rotate, also have one that just shoots 
	# have different modes where it stationary and rotates within limits and shoots
	# and one where it goes accross screen left to right shooting
	
	pass


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


