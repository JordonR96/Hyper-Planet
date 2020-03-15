extends Node2D

export(int, 1000) var y_axis_speed
export(float, 0, 10, 0.1)  var rotation_speed
export(Vector2) var player_start_position
export(Vector2) var camera_start_position
export(int, 90) var rotation_limit
export(float) var score_increment

var score = 0;
var playing = false
var screen_size
var rotation_dir = 0
var player_speed 



# Called when the node enters the scene tree for the first time.
func _ready():
	$Camera2D.make_current();
	$Camera2D/ScoreLabel.text = str(score)
	screen_size = get_viewport_rect().size
	player_speed = y_axis_speed



func _start_game():
	$ScoreTimer.start()
	$StartButton.visible = false
	$Player.start(player_start_position)
	$Camera2D.start(camera_start_position)
	playing = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if playing:
		# get global rotation in degrees
		var global_rot_rad = $Player.global_rotation 
		var global_rot_degree = global_rot_rad * (180/PI)

		handle_inputs(delta, global_rot_degree, global_rot_rad)
		move_camera(delta)
		move_player(delta, global_rot_degree, global_rot_rad)

#handle the inputs
func handle_inputs(delta, global_rot_degree, global_rot_rad):

	
	rotation_dir = 0
	# TODO figure out how tp do touch inputs
	# should be rotate to x axis of touch, further away form
	# player the bigger rotation accelaration

	
	if (Input.is_action_pressed('ui_left')):
		rotation_dir -= 1
	elif(Input.is_action_pressed('ui_right')):
		rotation_dir += 1
	var rotation_change = rotation_dir * rotation_speed * delta
	var new_rotation = global_rot_rad +  rotation_change

	var rotation_max = rotation_limit * (PI/180)
	var rotation_min = - rotation_max
	$Player.global_rotation = clamp(new_rotation, rotation_min, rotation_max)

	
func move_camera(delta):
	#only move camera in y dir
	var direction = Vector2(0,-1)
	$Camera2D.position += direction * y_axis_speed 


func move_player(delta, global_rot_degree, global_rot_rad):
	#move the player 
	# move in x axis based on player rotation
	var direction = Vector2()
	
	# calculate magnitude of x and y dir based on rotation
	# y axus movement decreases on rotaton
	direction.y = -cos(global_rot_rad)
	
	## no x axis movement when player is going straight
	## bigger rotation bigger movement
	direction.x = sin(global_rot_rad)
	
	# move the player with speed magnitude
	$Player.position += direction * player_speed 
	
	# with the player moving in a different direction
	# adjust speed of camera slow surroundings and camera down
	y_axis_speed = player_speed * abs(cos(global_rot_rad))
	
	$Player.position.x = clamp($Player.position.x,0,  360)


func _on_ScoreTimer_timeout():
	score+=score_increment
	$Camera2D/ScoreLabel.text = str(score)
	
func _game_over():
	# TODO on gameoverdisplay finished score
	#TODO figur ehow high score iwll work
	$ScoreTimer.stop()
