extends 'Enemy.gd'

var Bomb  = preload("res://ElectroDropshipBomb.tscn")
var enable_shoot = 'Yes'

## TODO find locationi relative to ship to spawn bullet
## give some movement patterns (straight, diagonal, sinusoidal
## once on screen make it start droppind bombs at reg intervals 
#(have diff interval ranges)

## make it stay on screen ifront of player for a bit sometimes
## hagve range of time periods we can select from
## othertimes just comes on and off

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play('Fly')
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




