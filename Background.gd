extends TileMap

# get reference to the tileset
var Tileset = get_tileset()
# get out tiles as variables
var rand_generate = RandomNumberGenerator.new()
var tile_count_x
var tile_count_y
var tile_resolution
var active = true
func _random_number(range_min, range_max):
	rand_generate.randomize()
	return rand_generate.randi_range(range_min, range_max)
	
	# Returns random integer between 0 and rnage_max


func start(bg_tile_count_x, bg_tile_count_y, bg_tile_resolution, start_position):


	tile_count_x = bg_tile_count_x
	tile_count_y = bg_tile_count_y
	tile_resolution = bg_tile_resolution
	_draw_full_screen()
	position.x = start_position.x
	position.y = start_position.y	


func _draw_full_screen():
	# modes of generation
	var modes = ['quarter', 'horizonatal_split', 'vertical_split', 'thirds']
	# list of available stuctures
	var structures = Tileset.get_tiles_ids()
	var structure_info = {}
	for id in structures:
		structure_info[Tileset.tile_get_name(id)] = id
	
	# draw_rect(Vector2(0,0), tile_count_x, tile_count_y , 1)
	var build_mode = modes[_random_number(0, modes.size() -1)]
	


	# fill screen with background tiles/ bg auto tiles
	var start = Vector2(0,0)
	var end = Vector2(tile_count_x, tile_count_y)
	
	_draw_rect(start, tile_count_x, tile_count_y, structure_info['background'])
	## TODO this is all too complicated need more simple build routine, butm some code may be useful
	#	if (build_mode == 'quarter'):
	#
	#		_build_screen_quarters(start, end, structures, structure_info)
	#
	#	elif (build_mode == 'horizonatal_split'):
	#
	#		_build_split_screen(start, end, true, false, structures, structure_info)
	#
	#	elif (build_mode == 'vertical_split'):
	#
	#		_build_split_screen(start, end, false, true, structures, structure_info)
	#
	#	elif (build_mode == 'thirds'):	
	#
	#		_build_thirds_screen(start, end, structures, structure_info)
	#
	#	# always update bitmask region otherwise auto tile won work
	#	update_bitmask_region(Vector2(0,0), Vector2(tile_count_x, tile_count_y))
	
func _get_quarters(start,end, halfx, halfy):
	var quarters = []
	
	quarters.push_back([Vector2(start.x, start.y), Vector2(halfx, halfy)])
	quarters.push_back([Vector2(halfx, start.y), Vector2(end.x,halfy)])	
	quarters.push_back([Vector2(start.x, halfy), Vector2(halfx, end.y)])
	quarters.push_back([Vector2(halfx, halfy), Vector2(end.x,end.y)])
	
	return quarters
	# return array of vectors splitting given x and y area into quarter regions

func _build_screen_quarters(start, end, structures, structure_info):
	var halfx = (end.x-start.x) /2
	var halfy = (end.y-start.y) /2
	var build_regions = _get_quarters(start, end, halfx, halfy)
	
	for i in range(build_regions.size()):
		var region = build_regions[i]
		_fill_region_with_structures(region[0], halfx, halfy, structures, structure_info)

func _get_split(start, end, horiz, vert, halfx, halfy):
	var regions = []
	
	if (horiz):
		regions.push_back([start, Vector2(end.x, halfy)])
		regions.push_back([Vector2(start.x, halfy), end])
	elif(vert):
		regions.push_back([start, Vector2(halfx, end.y)])
		regions.push_back([Vector2(halfx, start.y), end])

	return regions
	
func _build_split_screen(start, end, horiz, vert, structures, structure_info):
	# split the given area into horixontal or vertical regions
	var halfy = (end.y - start.y)/2
	var halfx = (end.x - start.x)/2
	
	# get the regions
	var build_regions = _get_split(start, end, horiz, vert, halfx, halfy)
	
	var split_width
	var split_height
	
	if (horiz):
		split_width = end.x - start.x
		split_height = (end.y - start.y)/2
	elif(vert):
		split_width = (end.x - start.x)/2
		split_height = end.y - start.y
	

	for i in range(build_regions.size()):
		
		var region = build_regions[i]
		_fill_region_with_structures(region[0], split_width, split_height, structures, structure_info)



func _get_thirds(start, end, third_y):
	var regions = []
	regions.push_front([start, Vector2(end.x, third_y)])
	regions.push_front([Vector2(start.x, third_y), Vector2(end.x, 2 *third_y)])
	regions.push_front([Vector2(start.x, 2 * third_y), end])
	return regions
	
func _build_thirds_screen(start, end, structures, structure_info):
	
	var ysize = (end.y - start.y)
	var third_y = ysize/3
	
	var xsize = (end.x - start.x)
	
	# get the regions
	var build_regions = _get_thirds(start, end, third_y)
	
	for i in range(build_regions.size()):
		# get the region
		var region = build_regions[i]
		# fill it with structures
		_fill_region_with_structures(region[0], xsize, third_y, structures, structure_info)
		

		

func _fill_region_with_structures(position,area_width,area_height, structures, structure_info):
	# decide on number of structures between 1 and 4
	var number_of_structures = 1
	#_random_number(1, 2)
	# TODO think numbe rof sturctures and spacing causing cl;ipping
	
	## loop over number of structures
	for i in range(number_of_structures):
		
		# get random position for the structure
		var structure_position_x = _random_number(position.x, position.x + area_width) 
		var structure_position_y = _random_number(position.y, position.y + area_height) 
		var structure_position = Vector2(structure_position_x, structure_position_y)
		
		# get random width and height in bounds of region
		var structure_width = _random_number(structure_position_x, (position.x + area_width - structure_position_x))
		var structure_height = _random_number(structure_position_y, (position.y+ area_height - structure_position_y))
		
		var structure_id = structures[_random_number(0, structures.size() -1)]
		var structure_name = structure_info[structure_id]
		_build_structure(structure_position, structure_width, structure_height, structure_id, structure_name)
		
func _build_structure(position, structure_width, structure_height, structure_id, structure_name):
	# needs to draw one of the structures with % chance of not drawinf any
	#then draw shape within the bounds , depending on the structure only draw square
	# oath only line
	# river rectangle on rectangle
	
	if (structure_width == 1):
		structure_width = 2
	if (structure_height == 1):
		structure_height = 2
	_draw_rect(position, structure_width, structure_height ,structure_id)


func _draw_rect(position, width, height, tile_id):
	# TODO have option for fill/ not filled rect
	#position x and y are integers,
	# width and height are int numbe rof cells
	var xstart = position.x
	var xend = position.x + width
	var ystart = position.y
	var yend = position.y + height

	for x in range(xstart, xend):
		for y in range(ystart, yend):
				set_cell(x,y, tile_id)

func _on_VisibilityNotifier2D_screen_exited():
	

	if (active):
		# clear the tiles
		clear()
		## draw again
		_draw_full_screen()
	
		# move it up
		position.y = position.y - (tile_count_y * tile_resolution * 3)





