extends Node2D
export var health = 1
export var speed = 10
export (String, 'Yes', 'No') var take_damage = 'Yes'

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal enemy_dead
signal shoot(bullet, position, rotation)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


## TODO need connecting signal from main that when called will just que free
func _on_destroy_all_enemies():
	queue_free()

func get_health():
	return health
	
func set_health(new_health):
	health = new_health
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	## TODO play enemy dead animation, have some function that decides which one depending on enemy

	if (health <= 0 ):
		queue_free()
		## TODO enemy dead signal
		# todo play death anim

		emit_signal("enemy_dead")

		
	
func take_damage(amount):
	if (take_damage == 'Yes'):
		health = health - amount

func _on_Enemy_area_entered(area):

	## TODO call collision animation	
	
	if (area.has_method('take_damage')):
		area.take_damage(1)
