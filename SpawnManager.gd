extends Node2D
# TODO need to bring all enemy scenes here

# Left and right
var SDScene = preload("res://EnemyScenes/SideDropship.tscn")

# Top
var BSScene = preload("res://EnemyScenes/BombSmiler.tscn")
var LBScene = preload("res://EnemyScenes/LaserBlock.tscn")
var CGScene = preload("res://EnemyScenes/ChainGun.tscn")
var EPSScene = preload("res://EnemyScenes/ElectroPodShort.tscn")
var EPMScene = preload("res://EnemyScenes/ElectroPodMed.tscn")
var EPLScene = preload("res://EnemyScenes/ElectroPodLong.tscn")
var PPScene = preload("res://EnemyScenes/PulsePod.tscn")
# top should probably set stricter limit on this ones position
var BlockadeScene = preload("res://EnemyScenes/LaserBlockade.tscn")

# top left or right
var EDScene = preload("res://EnemyScenes/ElectroDropship.tscn")
var MScene = preload("res://EnemyScenes/Mech.tscn")

# Declare member variables here. Examples:
var leftSpawnPoints = []
var rightSpawnPoints = []
var topSpawnPoints = []
export (int) var spawnIncrement = 1
var screen_size

var leftMasterList = []

var rightMasterList = []
var topMasterList = []
signal spawn
# HAVE TEMP ARRAY WHERE WE REMOVE SPAWNS AA THEY USE TO PREVENT LOTS OF REPEAT OF SAME ONE<
# then reeset on interval

# chance of top l;eft right spawn being chosen needs to reflect number of enemiesa ion those categ

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	
	for i in range(screen_size.x/spawnIncrement + 1):
		topSpawnPoints.append(Vector2(i*spawnIncrement,-100))
	
	for i in range(screen_size.y/spawnIncrement + 1):
		rightSpawnPoints.append(Vector2(420, i*spawnIncrement))
		leftSpawnPoints.append(Vector2(-80, i*spawnIncrement))
	
	# now have arrays with spawn vectors across x and y axis
	
	pass # Replace with function body.
	
	#
	# SUPER IMPORTAN% when signalling spawn, have optional config key
	# x_direction_name that m,ust match variable of that name in enemy tscn
	# this mianly for side dropship
	#


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass
