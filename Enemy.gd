extends Node2D
export var health = 1
export var speed = 10

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal enemy_dead

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_health():
	return health
	
func set_health(new_health):
	health = new_health
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if (health <= 0 ):

		emit_signal("enemy_dead")

		
	
func take_damage(amount):

	health = health - amount

func _on_Enemy_area_entered(area):

	## TODO call collision animation	
	
	if (area.has_method('take_damage')):
		area.take_damage(1)
