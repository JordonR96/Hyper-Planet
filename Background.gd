extends Sprite

# get reference to the tileset

var rand_generate = RandomNumberGenerator.new()

var active = true

var total_frames

## todo make selecting a frame a function, give high chance of showing just plain desert


func start( start_position):
	total_frames = get_hframes() + get_vframes()

	position.x = start_position.x
	position.y = start_position.y	
	rand_generate.randomize()
	var frameIndex = rand_generate.randi_range(0, 17)	
	set_frame(frameIndex)


func _on_VisibilityNotifier2D_screen_exited():
	if (active):
		pass
	rand_generate.randomize()
	var frameIndex = rand_generate.randi_range(0,(total_frames -1))
	#	 move it up
	position.y = position.y - (640 *  3)








