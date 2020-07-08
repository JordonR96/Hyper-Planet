
#  from main and add some pointas
extends Node2D

var rand_generate = RandomNumberGenerator.new()

export(int, 1000) var initial_y_axis_speed



export(Vector2) var player_start_position
export(Vector2) var camera_start_position

export(float) var score_increment
export(int) var start_time_between_spawns =2

var score = 0;


var screen_size


var sound = true
var soundOnImagePath = preload('res://Art/BG/sound_icon.png')
var soundOffImagePath = preload('res://Art/BG/sound_icon_mute.png')


var player_speed 
export (int) var bg_tile_count_x = 6
export (int) var bg_tile_count_y = 10
export (int) var bg_tile_resolution = 64
var playerScene = preload("res://Player.tscn")
var player


# TODO make this customisable so can have diff bullets?
var PlayerBulletScene = preload('res://PlayerBullet.tscn')

var BackgroundScene = preload("res://Background.tscn")


var Background1
var Background2
var Background3



var playing

signal destroy_all_enemies
# Called when the node enters the scene tree for the first time.
func _ready():
	$Camera2D/HUD/MuteButton.set_button_icon(soundOnImagePath)
	playing = false
	$Camera2D.make_current();
	screen_size = get_viewport_rect().size
	_start_backgrounds()
	$Camera2D/HUD/GameOver.hide()
	$Camera2D/HUD/TouchScreenButtonLeft.visible = false
	$Camera2D/HUD/TouchScreenButtonRight.visible = false
	$Camera2D/HUD/TouchScreenButtonShoot.visible = false
	

func _destroy_all_enemies ():
	## calling this function will remove all enemy and enemy bullets from screen
	
	emit_signal("destroy_all_enemies")
	
func _start_backgrounds():
	
	Background1 = BackgroundScene.instance()
	Background2 = BackgroundScene.instance()
	Background3 = BackgroundScene.instance()
	Background1.start(Vector2(180, 320))
	Background2.start(Vector2(180,(320 - 640)))
	Background3.start(Vector2(180,(320 - (2*640))))
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
	

	if (sound):
		$Music.play()
	
	# should be a function
	score = 0
	$Camera2D/HUD/ScoreLabel.text = str(score)
	$Camera2D/HUD/ScoreLabel.show()
	$Camera2D/HUD/StartButton.hide()
	$Camera2D/HUD/MenuSprite.visible = false
	$Camera2D/HUD/highScore.hide()
	$Camera2D/HUD/GameOver.hide()
	$Camera2D/HUD/GameOver.text = ''
	
	$Camera2D/HUD/TouchScreenButtonLeft.visible = true
	$Camera2D/HUD/TouchScreenButtonRight.visible = true
	$Camera2D/HUD/TouchScreenButtonShoot.visible = true
	$ScoreTimer.start()
	
	
	_start_update_timer()
	
	## TODO need to pass in initial spawn settings here
	$Camera2D/HUD/SpawnManager._start(start_time_between_spawns)

	# TODO should be function
	player.start(player_start_position)
	player.global_rotation = 0
	player.speed = initial_y_axis_speed
	player.connect('game_over', self, '_game_over')
	player.connect('shoot', self, '_player_shoot')


	_reset_backgrounds()
	

func _on_SpawnManager_spawn(EnemyScene, spawnPosition, spawnType):

	# spawn type is top left or right
	
	var enemy = EnemyScene.instance()
	spawnPosition.x = spawnPosition.x + $Camera2D.position.x
	spawnPosition.y = spawnPosition.y + $Camera2D.position.y
	
	enemy.position = spawnPosition
	enemy.connect('add_explosion', self, '_on_add_explosion')
	enemy.connect('shoot', self , '_spawn_enemy_bullet')
	if (sound):
		if (enemy.uses_sound == 'Yes' ):
			enemy.sound = true
	
	
	## make sure we can destroy all enemies if we wish (this will be a pickup)
	connect('destroy_all_enemies', enemy, '_on_destroy_all_enemies')
	
	if (enemy.has_method('set_target')):
		enemy.set_target(player)
	
	add_child(enemy)
	
func _spawn_enemy_bullet(BulletScene, position, direction):

	var bullet = BulletScene.instance();
	
	bullet.connect('add_explosion', self, '_on_add_explosion')
	
	bullet.start(position, direction)
	
	if (sound):
		bullet.play_sound();

	connect('destroy_all_enemies', bullet, '_on_destroy_all_enemies')
	add_child(bullet)
	
func _on_add_explosion(explosionScene, position):

	var explosion = explosionScene.instance()
	explosion.sound = sound

	explosion.position = position
	add_child(explosion)


func _player_shoot():
	
	# bullets are coming staight from guns
	var bullet1 = PlayerBulletScene.instance()
	var bullet2 = PlayerBulletScene.instance()

	add_child(bullet1)
	add_child(bullet2)
	var dir = Vector2(0,-1).rotated(player.global_rotation)
	if (sound):
		bullet1.play_sound();
		bullet2.play_sound()
		
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

	$ScoreTimer.stop()
	$Camera2D/HUD/ScoreLabel.hide()
	$Camera2D/HUD/GameOver.show()
	$Camera2D/HUD/GameOver.text = 'Game Over\n Score: ' + str(score)
	
	$Camera2D/HUD/TouchScreenButtonLeft.visible = false
	$Camera2D/HUD/TouchScreenButtonRight.visible = false
	$Camera2D/HUD/TouchScreenButtonShoot.visible = false
	
	if score > game.high_score:
		game.high_score = score
		$Camera2D/HUD/highScore.reload()
	
	$Camera2D/HUD/highScore.show()
	$Music.stop()
	
	$Camera2D/HUD/StartButton.show()
	$Camera2D/HUD/MenuSprite.visible = true
	$Camera2D/HUD/StartButton.text = 'Retry'
	$Camera2D.start(camera_start_position)
	
	_destroy_all_enemies()
	$Camera2D/HUD/SpawnManager._stop()
	
	$SettingsUpdate.stop()

func _on_Music_finished():
	if has_node('Player') && sound:
		$Music.play()

func _start_update_timer():
	$SettingsUpdate.set_wait_time(20)
	$SettingsUpdate.start()
	
func _on_SettingsUpdate_timeout():
	## TODO need fully testing
	rand_generate.randomize()
	player.speed  = clamp(player.speed + rand_generate.randi_range(10, 30),0, 300)

	$Camera2D/HUD/SpawnManager.update_spawn_settings(1, 10, 5)
	rand_generate.randomize()
	$SettingsUpdate.set_wait_time(rand_generate.randi_range(20, 30))
	$SettingsUpdate.start()

func _on_MuteButton_pressed():
	$Camera2D/HUD/MuteButton.release_focus()

	sound = !sound
	
	if (sound):
		$Camera2D/HUD/MuteButton.set_button_icon(soundOnImagePath)
		$Music.play()
	elif(!sound):
		$Camera2D/HUD/MuteButton.set_button_icon(soundOffImagePath)
		$Music.stop()
	
