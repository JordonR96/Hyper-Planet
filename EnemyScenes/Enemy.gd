extends Node2D
export var health = 1
export var speed = 10
export (String, 'Yes', 'No') var take_damage = 'Yes'
export (float) var life_time = 5
export (String) var dead_animation_name = 'Dead'
export (PackedScene) var explosion;
export (String, 'Yes', 'No') var use_explosion = 'No'

var dead = false
# important when creating new enemies that shoot make sure have enable_shoot flag
# that we disable when enemy health is 0
# If adding more collision shapes make sure to disable those when health is 0

## TODO figure how to display explosions on death usoing explosion scenes

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal enemy_dead
signal shoot(bullet, position, rotation)
signal add_explosion
# Called when the node enters the scene tree for the first time.
func _ready():
	$LifeTimer.wait_time = life_time
	$LifeTimer.start()
	pass # Replace with function body.


## TODO need connecting signal from main that when called will just que free
func _on_destroy_all_enemies():
	queue_free()

func get_health():
	return health
	
func set_health(new_health):
	health = new_health

func _dead():
	## TODO play enemy dead animation, have some function that decides which one depending on enemy
	## need multiple dead animations to choose from
	

	if (!dead):
		dead = true
		$AnimationPlayer.play(dead_animation_name)
	
		## TODO maybe hide sprite in favour of explosions
		$CollisionShape2D.disabled = true
		
		if (use_explosion == 'Yes'):
			emit_signal('add_explosion', explosion, position)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (health <= 0 ):
		_dead()
		emit_signal("enemy_dead")

		
	
func take_damage(amount):
	if (take_damage == 'Yes'):

		health = health - amount

func _on_Enemy_area_entered(area):

	## TODO call collision animation	
	
	if (area.has_method('take_damage')):
		area.take_damage(1)
		



func _on_AnimationPlayer_animation_finished(anim_name):
	if (anim_name == dead_animation_name):
		queue_free()


func _on_LifeTimer_timeout():
	queue_free()


func _on_ShootTimer_timeout():
	pass # Replace with function body.
