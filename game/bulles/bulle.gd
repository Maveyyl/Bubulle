extends Node2D

export(int, "RED","GREEN","YELLOW","PURPLE","CYAN","BLACK") var type

onready var animation_player = get_node("AnimationPlayer")
onready var extents = [
	get_node("base/extent_left"),
	get_node("base/extent_top"),
	get_node("base/extent_right"),
	get_node("base/extent_bottom")
]

var state = global.BULLE_STATES.IN_DOUBLET

var falling_acceleration = 10 # pixel per second per second
var falling_speed = 0

var grid
var grid_pos
var neighbours = []

signal started_falling
signal stopped_falling
signal started_popping
signal stopped_popping

func fromDictionnary( d ):
	type = d.type
	state = d.state
	falling_speed = d.falling_speed
	neighbours = []
func toDictionnary():
	return {
		"type": type,
		"state": state,
		"falling_speed": falling_speed
	}

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):	
	if( state == global.BULLE_STATES.FALLING ):
		# move the bulle down
		set_pos(get_pos() + Vector2( 0, falling_speed ) )
		# increase speed
		falling_speed += falling_acceleration * delta
		
		# if bulle can't move bottom further
		if( !can_move_bottom() ):
			# bulle emits a signal stating that it stopped falling
			emit_signal("stopped_falling", self)

	

func can_move_bottom():
	var grid_pos = grid.pos_to_grid_coord( get_pos() )
	var neighbour_slot_type = grid.get_neighbour_slot_type( grid_pos, global.DIRECTIONS.BOTTOM )
	# cannot move bottom if the slot under it is not empty
	return neighbour_slot_type == global.GRID_SLOT_TYPES.EMPTY
	

	
func set_in_doublet():
	state = global.BULLE_STATES.IN_DOUBLET
	remove_extents()
	
func set_falling():
	state = global.BULLE_STATES.FALLING
	remove_extents()
	falling_speed = 0
	emit_signal("started_falling", self)
	
func set_in_grid(grid_pos):
	state = global.BULLE_STATES.IN_GRID
	self.grid_pos = grid_pos
	
func set_popping():
	state = global.BULLE_STATES.POPPING
	emit_signal("started_popping", self)
	animation_player.play("popping")
	
	yield( animation_player, "finished" )
	emit_signal("stopped_popping", self)

	
func set_neighbours( neighbours ):
	self.neighbours = []

	for direction in range(global.DIRECTIONS.COUNT):
		self.neighbours.append( neighbours[direction ] )
		
		if( neighbours[direction] && neighbours[direction].type == type ):
			extents[direction].show()
		else:
			extents[direction].hide()


func explore_neighbourhood():
	var neighbours_list = []
	var neighbours_to_threat = [self]

	var bulle
	var neighbour

	# while neighbours to threat list not empty
	while( !neighbours_to_threat.empty() ):
		# get first element of neighbours to threat list and set it as current bulle
		bulle = neighbours_to_threat[0]
		# remove it from the list
		neighbours_to_threat.pop_front()
		
		# add it to neighbour list
		neighbours_list.append(bulle)
		
		# for each of that neighbour's neighbours
		for direction in range(global.DIRECTIONS.COUNT):
			neighbour = bulle.neighbours[direction]
			# if neighbour exists, is of the same type as current bulle and hasn't been threated yet
			if( neighbour && neighbour.type == bulle.type && !neighbours_list.has(neighbour) && !neighbours_to_threat.has(neighbour)  ): 
				# add neighbour to the neighbours to threat list
				neighbours_to_threat.append(neighbour)
				
	return neighbours_list

func remove_extents():
	if( extents != null ):
		for direction in range(global.DIRECTIONS.COUNT):
			extents[direction].hide()
