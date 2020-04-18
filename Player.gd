extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var screen_size
var speed 

var MainNode
export var health = 1
export(bool) var auto_straighten
export(float, 0, 10, 0.1)  var rotation_speed
export(int, 90) var rotation_limit
signal game_over
signal shoot
var allow_shoot = true
# Called when the node enters the scene tree for the first time.
func _ready():
	hide()

	screen_size = get_viewport_rect().size
	$CollisionShape2D.disabled = true
	
func get_health():
	return health
	
func set_health(new_health):
	health = new_health
	
func start(pos):
	position = pos
	show()
	$Sprite.visible = true
	$CollisionShape2D.disabled = false


func _process(delta):
	
	if (health <= 0 ):
		$Sprite.visible = false
		$ExplosionPlayer.play('explosion') 
		speed = 0
		rotation_speed = 0

		
	var rotation_degree = global_rotation * (180/PI)

	handle_inputs(delta, rotation_degree)
	move(delta, rotation_degree)
	
func move(delta, rotation_degree):
	#TODO tidy the code up
	# TODO test out auto mooveing player to face forward(have a flag on player)
	#move the player 
	# move in x axis based on player rotation
	var direction = Vector2()
	
	# calculate magnitude of x and y dir based on rotation
	# y axus movement decreases on rotaton
	direction.y = -cos(global_rotation)
	
	## no x axis movement when player is going straight
	## bigger rotation bigger movement
	# add extra x axis movement so it feels better
	#TODO adjust and make export variable
	direction.x = sin(global_rotation) *3
	
	# move the player with speed magnitude
	position += direction * (speed * delta)
	
	position.x = clamp(position.x,0,  360)
	
#handle the inputs
func handle_inputs(delta, rotation_degree):
	
	var straightening = false

	# TODO figure out how tp do touch inputs
	# should be rotate to x axis of touch, further away form
	# player the bigger rotation accelaration
	var rotation_dir = 0
	## TODO change to use custom inputz
	
	if (Input.is_action_pressed("ui_select")):
		if (allow_shoot):
			## TODO play the shooting animation
			emit_signal('shoot')
			allow_shoot = false
			$AnimationPlayer.queue('shoot') 



	

	if (Input.is_action_pressed('ui_left')):

		rotation_dir -= 1
	elif(Input.is_action_pressed('ui_right')):

		rotation_dir += 1
	else:
		if (auto_straighten and rotation_degree != 0):
			#TODO set rotation direction towards
			rotation_dir = -1 * (rotation_degree/abs(rotation_degree))
			straightening = true
			## todo consider snapback rotation quicker
	
	

	## TODO acceleration rotation/ rotation speed change with distrance touch
	# away from play/ touch screen left/right + shoot
		
	var rotation_change = rotation_dir * rotation_speed * delta
	

	var new_rotation = global_rotation +  rotation_change

	var rotation_max = rotation_limit * (PI/180)
	var rotation_min = - rotation_max
	

	
	if (global_rotation >= -0.05 and global_rotation <= 0.05 and straightening):
		global_rotation = 0
	else:
		global_rotation = clamp(new_rotation, rotation_min, rotation_max)

func take_damage(amount):

	health = health - amount





func _on_Player_area_entered(area):

	if (area.has_method('take_damage')):
		area.take_damage(1)


func _on_AnimationPlayer_animation_finished(anim_name):

	if (anim_name == 'shoot'):
		$AnimationPlayer.queue('default')
		#TODO allow shoot is a bit off
		
		allow_shoot = true



func _on_ExplosionPlayer_animation_finished(anim_name):
	queue_free()
	emit_signal('game_over')
