extends Node2D

export(int, "RED","GREEN","YELLOW","PURPLE","CYAN","BLACK") var type
var state = global.BULLE_STATES.IN_DOUBLET

onready var extent_left = get_node("base/extent_left")
onready var extent_top = get_node("base/extent_top")
onready var extent_right = get_node("base/extent_right")
onready var extent_bottom = get_node("base/extent_bottom")
onready var animation_player = get_node("AnimationPlayer")

var falling_acceleration = 10 # pixel per second per second
var falling_speed = 0

var grid_pos
var neighbours = []

func _ready():
	set_fixed_process(true)
	pass

func _fixed_process(delta):
	# if is in falling state, parent is game panel
	if( state == global.BULLE_STATES.FALLING ):
		# the falling
		set_pos(get_pos() + Vector2( 0, falling_speed ) )
		# increase acceleration
		falling_speed += falling_acceleration * delta
		
		# if bulle can't move bottom
		if( !can_move_bottom() ):
			# bulle fall anymore and must be placed in the grid
			get_parent().remove_falling_bulle( self )

	

func can_move_bottom():
	var grid = get_parent().grid # moving bottom is only when bulle is in the single game panel
	var grid_pos = grid.pos_to_grid_coord( get_pos() )
	# cannot move bottom if the slot under it is full
	return grid.get_neighbour_slot_type( grid_pos, global.DIRECTIONS.BOTTOM ) == global.GRID_SLOT_TYPES.EMPTY
	

	
func set_in_doublet():
	state = global.BULLE_STATES.IN_DOUBLET
	remove_extents()
	
func set_falling():
	falling_speed = 0
	state = global.BULLE_STATES.FALLING
	remove_extents()
	
func set_in_grid(grid_pos):
	self.grid_pos = grid_pos
	state = global.BULLE_STATES.IN_GRID
	
func set_popping():
	state = global.BULLE_STATES.POPPING
	animation_player.play("popping")
	yield( animation_player, "finished" )
	get_parent().remove_popping_bulle(self)
	
	
func set_neighbours( neighbours ):
	self.neighbours = []
	for direction in range(global.DIRECTIONS.COUNT):
		self.neighbours.append( neighbours[direction ] )
	
	if( neighbours[global.DIRECTIONS.LEFT] && neighbours[global.DIRECTIONS.LEFT].type == type ):
		extent_left.show()
	if( neighbours[global.DIRECTIONS.TOP] && neighbours[global.DIRECTIONS.TOP].type == type ):
		extent_top.show()
	if( neighbours[global.DIRECTIONS.RIGHT] && neighbours[global.DIRECTIONS.RIGHT].type == type  ):
		extent_right.show()
	if( neighbours[global.DIRECTIONS.BOTTOM] && neighbours[global.DIRECTIONS.BOTTOM].type == type ):
		extent_bottom.show()

func explore_neighbourhood():
	var neighbours_list = []
	var neighbours_to_threat = [self]

	var bulle
	var neighbour

	# while neighbours to threat list not empty
	while( !neighbours_to_threat.empty() ):
		# get first element of neighbours to threat list
		bulle = neighbours_to_threat[0]
		
		# remove it from the list
		neighbours_to_threat.pop_front()
		# add it to neighbour list
		neighbours_list.append(bulle)
		# for each of that neighbour's neighbours
		for direction in range(global.DIRECTIONS.COUNT):
			neighbour = bulle.neighbours[direction]
		
			if( neighbour && neighbour.type == bulle.type && !neighbours_list.has(neighbour) && !neighbours_to_threat.has(neighbour)  ): 
				neighbours_to_threat.append(neighbour)
				
	return neighbours_list

func remove_extents():
	extent_left.hide()
	extent_top.hide()
	extent_right.hide()
	extent_bottom.hide()