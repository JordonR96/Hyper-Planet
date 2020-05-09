extends Node2D


# Declare member variables here. Examples:
var leftSpawnPoints = []
var rightSpawnPoints = []
var topSpawnPoints = []
export (int) var spawnIncrement = 1
var screen_size

# HAVE TEMP ARRAY WHERE WE REMOVE SPAWNS AA THEY USE TO PREVENT LOTS OF REPEAT OF SAME ONE<
# then reeset on interval

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	
	for i in range(screen_size.x/spawnIncrement + 1):
		topSpawnPoints.append(Vector2(i*spawnIncrement,-64))
	
	for i in range(screen_size.y/spawnIncrement + 1):
		rightSpawnPoints.append(Vector2(360, i*spawnIncrement))
		leftSpawnPoints.append(Vector2(0, i*spawnIncrement))
	
	# now have arrays with spawn vectors across x and y axis
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass
