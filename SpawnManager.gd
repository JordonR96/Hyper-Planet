extends Node2D

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
export (int) var topChance = 61
export (int) var leftChance = 19
export (int) var rightChance = 19
export (int) var noSpawnChance = 1
export (int) var dualSpawnChance = 2
export (int) var tripleSpawnChance = 5
# Time between each spawn in seconds, will change during game
var spawnTimerWaitTime = 5

# unchanging master lists
var  leftMasterList = [ MScene, EDScene, HSScene]
var  rightMasterList = [ MScene, EDScene, HSScene]

# TODO make sure all top list are able to be spawned seem to only get homing ship mech and ed
var  topMasterList = [BSScene, LBScene, CGScene,EPSScene, EPSScene
, PPScene, BlockadeScene, EDScene, MScene, EPSScene, HSScene, EPSScene]

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
func _start(start_time_between_spawns):
	screen_size = get_viewport_rect().size
	
	leftActiveList = leftMasterList
	rightActiveList = rightMasterList

	topActiveList = topMasterList
	
	 ## TODO reduce range of values for spawns so its centre of screen

	for i in range(100,300):
		topSpawnPoints.append(Vector2(i,-200))
	
	# TODO reuce ranmge of these so they sopawn in top half of screen
	for i in range(-200, 0):
		rightSpawnPoints.append(Vector2(360, i))
		leftSpawnPoints.append(Vector2(-20, i))
	
	$Timer.set_wait_time(start_time_between_spawns)
	## TODO export vars should be separate and then we update initials here
	dualSpawnChance = 2
	tripleSpawnChance = 7
	$Timer.start()
	
	
func update_spawn_settings(timeDecrease, dualChanceincrease, tripleChanceincrease):
	$Timer.stop()
	dualSpawnChance = clamp(dualSpawnChance + dualChanceincrease, 0, 40) 
	tripleSpawnChance =  clamp(tripleSpawnChance + tripleChanceincrease, 0, 20) 
	
	$Timer.set_wait_time(clamp($Timer.wait_time - timeDecrease,1 , 5))
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
			spawnType = 'Top'
			if (enemyToSpawn[1] == 'Laser Blockade'):
				spawnPosition = Vector2(screen_size.x/2, spawnPosition.y)

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

				spawnPosition = Vector2(screen_size.x/2, spawnPosition.y)
			
		
		else:
			spawningEnemy = false
		
	if (spawningEnemy):
		
		var dualSpawn = false
		
				## The actual enemy scene exists in 0th index of enemytospawn
		emit_signal("spawn", enemyToSpawn[0], spawnPosition,spawnType)
		## ban  'ElectroPod Small' mred and largee, lasr blockade from dueal spawn
		
		var allowMultipleSpawn = true
		
		var enemyName = enemyToSpawn[1]
		
		if (enemyName == 'ElectroPod Small' or enemyName == 'ElectroPod Medium' or enemyName == 'ElectroPod Large' or enemyName == 'Laser Blockade'):
			allowMultipleSpawn = false
		
		
		if (allowMultipleSpawn):
			
			# choose spanw position
			rand_generate.randomize()
			var dualSpawnRandomNumber = rand_generate.randi_range(0, 100)
			
			if (dualSpawnRandomNumber <= dualSpawnChance):
				dualSpawn = true
			
			if (dualSpawn and spawnType != null):
				
				var dualSpawnPosition
				
				rand_generate.randomize()
				
	
				if (spawnType == 'Left' or spawnType == 'Right'):
					
					dualSpawnPosition=  Vector2(spawnPosition.x, spawnPosition.y - rand_generate.randi_range(60, 160) )
					
				elif(spawnType == 'Top'):
					
					dualSpawnPosition =  Vector2(spawnPosition.x + rand_generate.randi_range(60, 160), spawnPosition.y )
		
				emit_signal("spawn", enemyToSpawn[0], dualSpawnPosition, spawnType)
				
			
#				var tripleSpawn = false
#				# choose spanw position
#				rand_generate.randomize()
#				var tripleSpawnRandomNumber = rand_generate.randi_range(0, 100)
#
#				if (tripleSpawnRandomNumber <= tripleSpawnChance):
#
#					rand_generate.randomize()
#					var tripleSpawnPosition
#					if (spawnType == 'Left' or spawnType == 'Right'):
#
#						tripleSpawnPosition=  Vector2(spawnPosition.x, spawnPosition.y - rand_generate.randi_range(60, 160) )
#
#					elif(spawnType == 'Top'):
#
#						tripleSpawnPosition =  Vector2(spawnPosition.x + rand_generate.randi_range(60, 160), spawnPosition.y )
#
#					emit_signal("spawn", enemyToSpawn[0], tripleSpawnPosition ,spawnType)
					
					
					
				
		
		# spawn connecting function in main
		# _on_SpawnManager_spawn(EnemyScene, spawnPosition, spawnType)
		




func _on_Timer_timeout():
	_spawn()
