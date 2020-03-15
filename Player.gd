extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var screen_size
var speed = 0
var MainNode

signal hit

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()

	screen_size = get_viewport_rect().size
	$CollisionShape2D.disabled = true
	

func start(pos):


	position = pos
	show()
	$CollisionShape2D.disabled = false



	
