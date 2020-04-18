extends Node2D

export(int, 1000) var y_axis_speed

export(Vector2) var player_start_position
export(Vector2) var camera_start_position

export(float) var score_increment


var score = 0;

var screen_size

var player_speed 
export (int) var bg_tile_count_x = 6
export (int) var bg_tile_count_y = 10
export (int) var bg_tile_resolution = 64
var playerScene = preload("res://Player.tscn")
var player

var SDScene = preload("res://SideDropship.tscn")

# TODO make this customisable so can have diff bullets?
var PlayerBulletScene = preload('res://PlayerBullet.tscn')

var BackgroundScene = preload("res://Background.tscn")

var Background1
var Background2
var Background3

var playing
# Called when the node enters the scene tree for the first time.
func _ready():
	playing = false
	$Camera2D.make_current();
	screen_size = get_viewport_rect().size
	_start_backgrounds()
	## TODO make this a func so can call it when retry is pressed
	# so can reset backgrounds to begginining
	# manage backgrounds
	
	$Camera2D/HUD/GameOver.hide()
	
func _start_backgrounds():
	#TODO background not resetting properly on gameover

	Background1 = BackgroundScene.instance()
	Background2 = BackgroundScene.instance()
	Background3 = BackgroundScene.instance()
	Background1.start(bg_tile_count_x, bg_tile_count_y, bg_tile_resolution, Vector2(0,0))
	Background2.start(bg_tile_count_x, bg_tile_count_y, bg_tile_resolution, Vector2(0,(-1 * bg_tile_count_y * bg_tile_resolution)))
	Background3.start(bg_tile_count_x, bg_tile_count_y, bg_tile_resolution, Vector2(0,(-2 * bg_tile_count_y * bg_tile_resolution)))
	add_child(Background1)
	add_child(Background2)
	add_child(Background3)
	
func _reset_backgrounds():

	Background1.queue_free()
	Background2.queue_free()
	Background3.queue_free()
	
	_start_backgrounds()
	

func _start_game():
	

	player = playerScene.instance()
	add_child(player)


	## TODO make sure this rests the game properly on retry
	
	# should be a function
	score = 0
	$Camera2D/HUD/ScoreLabel.text = str(score)
	$Camera2D/HUD/ScoreLabel.show()
	$Camera2D/HUD/StartButton.hide()
	$Camera2D/HUD/GameOver.hide()
	$Camera2D/HUD/GameOver.text = ''
	
	$ScoreTimer.start()

	# TODO should be function
	player.start(player_start_position)
	player.global_rotation = 0
	player.speed = y_axis_speed
	player.connect('game_over', self, '_game_over')
	player.connect('shoot', self, '_player_shoot')
	_spawn_enemies()


	_reset_backgrounds()
	

func _spawn_enemies():
	
	var enemy = SDScene.instance()
	

	var spawn = Vector2(300, -182)
	enemy.position = spawn
	enemy.connect('shoot', self , '_spawn_enemy_bullet')
	
	
	add_child(enemy)
	print(enemy.position.y)
	# todo this will be used by spawn path
	
	## test spawn point

	pass

func _spawn_enemy_bullet(BulletScene, position, direction):
	print('shooting2')

	var bullet = BulletScene.instance();
	
	bullet.start(position, direction)

	add_child(bullet)



func _player_shoot():
	# TODO get player roatatoin, if player is rotated add a pixel amouun
	# to lef tor right (depending on rotation direction) so it looks like 
	# bullets are coming staight from guns
	var bullet1 = PlayerBulletScene.instance()
	var bullet2 = PlayerBulletScene.instance()
	add_child(bullet1)
	add_child(bullet2)
	var dir = Vector2(0,-1).rotated(player.global_rotation)
	
	## TODO have ability to change bullet velcotiy form console
	## todo do this in more clever way
	
	var bullet1position= Vector2( player.global_position.x + 20, player.global_position.y - 30)
	var bullet2position = Vector2( player.global_position.x - 20, player.global_position.y - 30)
	bullet1.start(bullet1position, dir)
	bullet2.start(bullet2position, dir)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if has_node('Player'):
		
			# with the player moving in a different direction
	# adjust speed of camera slow surroundings and camera down
		var camera_speed = player.speed * abs(cos(player.global_rotation))
		move_camera(delta, camera_speed)


	
func move_camera(delta, speed):
	#only move camera in y dir
	var direction = Vector2(0,-1)
	$Camera2D.position += direction * (speed * delta)


func _on_ScoreTimer_timeout():
	score += score_increment
	$Camera2D/HUD/ScoreLabel.text = str(score)
	
	 
func _game_over():

	## TODO emit a signal that will stop all enemies from scene after x seconds 
	# or leave it if it wont break everything
	## TODO  show whole game over screen
	$ScoreTimer.stop()
	$Camera2D/HUD/ScoreLabel.hide()
	$Camera2D/HUD/GameOver.show()
	$Camera2D/HUD/GameOver.text = 'Game Over\n Score: ' + str(score)
		## TODO emit a signal that all enemies/environment obj have that will cause them to die
	#will need to connect that on instantiation, will use queue_free() to dleete
	## TODO  show whole game over screen
	$Camera2D/HUD/StartButton.show()
	$Camera2D/HUD/StartButton.text = 'Retry'
	$Camera2D.start(camera_start_position)

	## TODO have gameover screen and show that should be same as start screen, shouldnt just be bg of game









	
