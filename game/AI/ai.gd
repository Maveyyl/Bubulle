extends Node2D

onready var solo_game = get_parent()

onready var double_game_panel = solo_game.get_node('double_game_panel')
onready var game_panel = double_game_panel.get_node('game_panel_p2')
onready var info_panel = double_game_panel.get_node('info_panel_p2')

onready var doublet_placer = get_node('doublet_placer')

var doublet

var simulation = global.SCRIPTS.GAME_PANEL_SIMULATION.new()
var show_simulation = false
onready var simulation_view = get_node('simulation_view')
var bulles = [[]]
var bulles_textures = [
	preload('res://game/bulles/red/base_red.png'),
	preload('res://game/bulles/green/base_green.png'),
	preload('res://game/bulles/yellow/base_yellow.png'),
	preload('res://game/bulles/purple/base_purple.png'),
	preload('res://game/bulles/cyan/base_cyan.png'),
	preload('res://game/bulles/black/base_black.png')
]

func _ready():
	set_process(true)
	
	if( show_simulation ):
		bulles = []
		bulles.resize(global.GRID_SIZE.x)
		for x in range(global.GRID_SIZE.x):
			bulles[x] = []
			bulles[x].resize(global.GRID_SIZE.y)
			for y in range(global.GRID_SIZE.y):
				bulles[x][y] = Sprite.new()
				simulation_view.add_child(bulles[x][y])
				bulles[x][y].set_pos( Vector2( global.BULLE_SIZE.x * x, global.BULLE_SIZE.y * y) + global.BULLE_SIZE/2 )
	

func _process(delta):	
	if( game_panel.doublet && doublet != game_panel.doublet ):
		doublet = game_panel.doublet
		
		var double_game_panel_data = double_game_panel.toDictionnary(true)
		simulation.set_base_state(double_game_panel_data)
		
		var ga = global.SCRIPTS.GA.new()
		var d = ga.run( simulation )
		doublet_placer.doublet_main_bulle_goal_pos_x = d[0]
		doublet_placer.doublet_second_bulle_goal_state = d[1]

		if( show_simulation ):
			for x in range(global.GRID_SIZE.x):
				for y in range(global.GRID_SIZE.y):
					if( simulation.bulles[x][y] >= 0 ):
						bulles[x][y].set_texture( bulles_textures[simulation.bulles[x][y]] )
						bulles[x][y].show()
					else:
						bulles[x][y].hide()

	# if there's a new doublet to place, choose random location and rotation
#	if( doublet != game_panel.doublet ):
#		var d = generate_random_placement()
#		doublet_placer.doublet_main_bulle_goal_pos_x = d[0]
#		doublet_placer.doublet_second_bulle_goal_state = d[1]
#
#		simulation.run_until_new_doublet(delta)



func generate_random_placement():
	var main_bulle_pos_x = randi()%int(global.GRID_SIZE.x)
	var second_bulle_state = randi()%global.DIRECTIONS.COUNT
	while( 
		(main_bulle_pos_x == 0 && second_bulle_state == global.DIRECTIONS.LEFT) 
		|| (main_bulle_pos_x == global.GRID_SIZE.x && second_bulle_state == global.DIRECTIONS.RIGHT)
	):
		second_bulle_state = randi()%global.DIRECTIONS.COUNT
	
	return [main_bulle_pos_x, second_bulle_state]