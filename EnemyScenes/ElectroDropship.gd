extends 'Enemy.gd'

var Bomb  = preload("ElectroDropshipBomb.tscn")
var enable_shoot = 'Yes'

# todo smooth deathg anim

#(have diff interval ranges for bomb drops)

func _ready():
	

	$AnimationPlayer.play('Fly')
	var rand_generate = RandomNumberGenerator.new()
	rand_generate.randomize()
	speed = rand_generate.randi_range(50,200)
	
	rand_generate.randomize()
	rotation = rand_generate.randi_range(0,360)
	
	rand_generate.randomize()
	$ShootTimer.set_wait_time(rand_generate.randi_range(0.5,3))
	# randomise, speed, and directin and bullet drop rate
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (health <= 0):
		$CollisionShape2D2.disabled = true
		$CollisionShape2D3.disabled = true
		enable_shoot = 'No'
	
	
	var velocity = Vector2(0, -1 ).rotated(rotation) * speed * delta
	position += velocity
	
	pass


func _on_ShootTimer_timeout():
	
	if (enable_shoot == 'Yes'):

		var change = Vector2(0, 1).rotated(rotation)
		change = change * 25
		var spawn = Vector2(global_position.x, global_position.y) + change
		emit_signal('shoot', Bomb, spawn, Vector2(0,1).rotated(rotation))




