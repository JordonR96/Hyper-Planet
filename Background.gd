extends TileMap

# get reference to the tileset
var Tileset = get_tileset()
# get out tiles as variables
var crater = Tileset.find_tile_by_name('crater')
var river = Tileset.find_tile_by_name('river')
var block_hole = Tileset.find_tile_by_name('block_hole')
var path = Tileset.find_tile_by_name('path')
var background = Tileset.find_tile_by_name('background')
var screen_size




# Called when the node enters the scene tree for the first time.
func _ready():
	# tiles are 32 * 32 
	screen_size = get_viewport_rect().size
	# get number of tiles in x and y axis
	var tile_count_x = screen_size.x/32
	var tile_count_y = screen_size.y/32
	
	## todo continue will be able to od more complicated things,
	# look at algo, should be able to get this working
	# have option for fill/ not filled rect
	# have a draw line function (horiz and vert only)
	# create a draw crate function (random, x,y width heihgt, must fit in screen size y)
	# create a drawriver function, similar to draw crate, but with some lines
	# draw path, should jist ne lines
	# need a way to make sure no tile overlaps happen, assign regions

	_draw_rect(1,1,2, 3, crater)
	_draw_rect(2,2,3,2,crater)
	# always update bitmask region otherwise auto tile won work
	update_bitmask_region(Vector2(0,0), Vector2(tile_count_x, tile_count_y))
	
	pass # Replace with function body.

func _draw_rect(posx, posy, width, height, tile_id):
	# TODO have filled option
	#position x and y are integers,
	# width and height are int numbe rof cells
	var xstart = posx
	var xend = posx + width
	var ystart = posy
	var yend = posy + height
	print(xstart)
	for x in range(xstart, xend):
		for y in range(ystart, yend):
				set_cell(x,y, tile_id)
	


