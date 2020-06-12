extends Node2D
#NOT WORKING
#NOT WORKING

# TODO 

# 2. bevery minute have a chance to change the active listy to just contain 
# laser blockades or pulkse pods or electro pods () maybe mixture
# this should set this for maybe 20-30 seconds then revert back to maSTER list
# WOULD NEED TO LIMIT THE OPTIONS TO TOP LIST
# 3. need to make it consistently spawn stuff that makes a challenge,
# instead of increasing spawn frequency increase amount of selected enemy to spawn]
# have chance to spwn 2/ 3 of enemy as time goes on the chance increases
#


var rand_generate = RandomNumberGenerator.new()

# this shouol;d change when the avtive lists arent equal to master list
# will be master or top
var spawnState = 'Master'

# Left and right these guys dont really work well
#var SDScene = preload("res://EnemyScenes/SideDropship.tscn")

# Top
var BSScene = [preload("res://EnemyScenes/BombSmiler.tscn"), 'Bomb Smiler']
var LBScene = [preload("res://EnemyScenes/LaserBlock.tscn"),'Laser Block']
var CGScene = [preload("res://EnemyScenes/ChainGun.tscn"), 'Chain Gun']
var EPSScene = [preload("res://EnemyScenes/ElectroPodShort.tscn"), 'ElectroPod Small']
var EPMScene = [preload("res://EnemyScenes/ElectroPodMed.tscn"), 'ElectroPod Medium']
var EPLScene = [preload("res://EnemyScenes/ElectroPodLong.tscn"), 'ElectroPod Large']
var PPScene = [preload("res://EnemyScenes/PulsePod.tscn"),  'Pulse Pod']

# top should probably set stricter limit on this ones position
var BlockadeScene = [preload("res://EnemyScenes/LaserBlockade.tscn"), 'Laser Blockade']

# top left or right
var EDScene = [preload("res://EnemyScenes/ElectroDropship.tscn"), 'Electro Dropship']
var MScene = [preload("res://EnemyScenes/Mech.tscn"), 'Mech']
var HSScene = [preload("res://EnemyScenes/HomingShip.tscn"), 'Homing Ship']
#Screen Size
var screen_size


# Declare member variables here. Examples:
var leftSpawnPoints = []
var rightSpawnPoints = []
var topSpawnPoints = []

# probability of using top leftr or right
export (int) var topChance = 60
export (int) var leftChance = 19
export (int) var rightChance = 19
export (int) var noSpawnChance = 2

# Time between each spawn in seconds, will change during game
export (float) var spawnTimerWaitTime = 2

# unchanging master lists
var  leftMasterList = [ MScene, EDScene, HSScene]
var  rightMasterList = [ MScene, EDScene, HSScene]

# TODO make sure all top list are able to be spawned seem to only get homing ship mech and ed
var  topMasterList = [BSScene, LBScene, CGScene,EPSScene, EPMScene
, PPScene, BlockadeScene, EDScene, MScene, HSScene]

#active lists
var leftActiveList = []
var rightActiveList = []
var topActiveList = []

signal spawn
# HAVE TEMP ARRAY WHERE WE REMOVE SPAWNS AA THEY USE TO PREVENT LOTS OF REPEAT OF SAME ONE<
# then reeset on interval

# chance of top l;eft right spawn being chosen needs to reflect number of enemiesa ion those categ
func _ready():
	pass
# Called when the node enters the scene tree for the first time.
func _start():
	screen_size = get_viewport_rect().size
	
	leftActiveList = leftMasterList
	rightActiveList = rightMasterList
	#uncomment me topActiveList = topMasterList
	# TODO uncomment me topActiveList = topMasterList
	topActiveList = [HSScene]
	
	 ## TODO reduce range of values for spawns so its centre of screen

	for i in range(100,300):
		topSpawnPoints.append(Vector2(i,-200))
	
	# TODO reuce ranmge of these so they sopawn in top half of screen
	for i in range(-200, 0):
		rightSpawnPoints.append(Vector2(360, i))
		leftSpawnPoints.append(Vector2(-20, i))
	
	$Timer.set_wait_time(spawnTimerWaitTime)
	$Timer.start()

func _stop ():
	$Timer.stop()

func _spawn():
	
	#
	# SUPER IMPORTAN% when signalling spawn, have optional config key
	# x_direction_name that m,ust match variable of that name in enemy tscn
	# this mianly for side dropship
	#
	
	var spawningEnemy = true

	var enemyToSpawn
	var spawnPosition 
	var spawnConfig = {}
	var spawnType
	
	if (spawnState == 'Master'):
		
		
		
		# choose spanw position
		rand_generate.randomize()
		var randomNumber = rand_generate.randi_range(0, 100)
		
		var topAddLeft = topChance + leftChance
		
		var topAddLeftAddRight = topAddLeft + rightChance


		#  spawning at top
		if (randomNumber <= topChance):
			rand_generate.randomize()
			var randomTopIndex = rand_generate.randi_range(0, topActiveList.size()- 1)
			enemyToSpawn = topActiveList[randomTopIndex]

			rand_generate.randomize()
			var randomTopPositionIndex = rand_generate.randi_range(0, topSpawnPoints.size()- 1)
			spawnPosition = topSpawnPoints[randomTopPositionIndex]
			
			if (enemyToSpawn[1] == 'Laser Blockade'):
				print('Laser Blockade')
				spawnPosition = Vector2(screen_size.x/2, spawnPosition.y)
				spawnType = 'Top'
		#spanwing on the left
		elif (randomNumber > topChance and randomNumber  <= topAddLeft):
			rand_generate.randomize()
			var randomLeftIndex = rand_generate.randi_range(0, leftActiveList.size()- 1)
			enemyToSpawn = leftActiveList[randomLeftIndex]
			
			rand_generate.randomize()
			var randomLeftPositionIndex = rand_generate.randi_range(0, leftSpawnPoints.size()- 1)
			spawnPosition = leftSpawnPoints[randomLeftPositionIndex]
			
 
			spawnType = 'Left'
		
		# spawning on the right	
		elif (randomNumber > topAddLeft and randomNumber  <= topAddLeftAddRight):
			rand_generate.randomize()
			var randomRightIndex = rand_generate.randi_range(0, rightActiveList.size()- 1)
			enemyToSpawn = rightActiveList[randomRightIndex]
			
			rand_generate.randomize()
			var randomRightPositionIndex = rand_generate.randi_range(0, rightSpawnPoints.size()- 1)
			spawnPosition = leftSpawnPoints[randomRightPositionIndex]
			
			spawnType = 'Right'
		
		elif( randomNumber >= (100 - noSpawnChance)):
			
			spawningEnemy = false
		
	elif (spawnState == 'Top'):
		spawnType = 'Top'
		if (topActiveList.size() > 1):
			rand_generate.randomize()
			var randomTopIndex = rand_generate.randi_range(0, topActiveList.size()- 1)
			enemyToSpawn = topActiveList[randomTopIndex]
			
			rand_generate.randomize()
			var randomTopPositionIndex = rand_generate.randi_range(0, topSpawnPoints.size()- 1)
			spawnPosition = topSpawnPoints[randomTopPositionIndex]
			
			if (enemyToSpawn[1] == 'Laser Blockade'):
				print('Laser Blockade')
				spawnPosition = Vector2(screen_size.x/2, spawnPosition.y)
				spawnType = 'Top'
		
		else:
			spawningEnemy = false
		
	if (spawningEnemy):
		
		## The actual enemy scene exists in 0th index of enemytospawn
		emit_signal("spawn", enemyToSpawn[0], spawnPosition,spawnType)
		
		# spawn connecting function in main
		# _on_SpawnManager_spawn(EnemyScene, spawnPosition, spawnType)
		




func _on_Timer_timeout():
	_spawn()
