extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var speed = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	
func start(pos):

	position = pos
	show()


	
