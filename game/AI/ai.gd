extends Node2D

onready var solo_game = get_parent()

onready var double_game_panel = solo_game.get_node('double_game_panel')
onready var game_panel = double_game_panel.get_node('game_panel_p2')
onready var info_panel = double_game_panel.get_node('info_panel_p2')

onready var doublet_placer = get_node('doublet_placer')

var doublet

var first_decision = true

var thread = Thread.new()
var ga = global.SCRIPTS.GA.new()
var ga_result
var ga_done = false
var ga_execution_time

var best_solution = []
var best_score = -1

var simulation = global.SCRIPTS.GAME_PANEL_SIMULATION.new()


var show_simulation = true
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

	doublet_placer.set_goal_placement( generate_random_placement() )


func _process(delta):
	if( ga.ready && !ga_done ):
		doublet_placer.increase_speed = true
		ga_done = true
		ga_execution_time = OS.get_ticks_msec() - ga_execution_time
		print("ga execution time: ", ga_execution_time)
	elif( !ga_done ):
		doublet_placer.increase_speed = false
	

	if( game_panel.doublet && doublet != game_panel.doublet ):
		doublet = game_panel.doublet
		# if first decision, don't do anything
		if( first_decision ):
			first_decision = false
		else:
			
			# recover genetic algorithm results
			ga_result = thread.wait_to_finish()
			
			# update current solution's score compared to environment
			best_score = simulation.copy().simulate_solution( best_solution )
			
			# compare with new results
			if( best_solution.size() == 0 || best_score < ga_result.score):
				best_solution = ga_result.solution
				best_score = ga_result.score
			ga_result = null
			ga_done = false

				
			# put the best solution as next order
			doublet_placer.set_goal_placement( best_solution )
			best_solution.pop_front()
			best_solution.pop_front()
				

		
		# create base simulation with current context
		var double_game_panel_data = double_game_panel.toDictionnary(true)
		simulation.fromDictionnary(double_game_panel_data)
		simulation.simulate_solution( doublet_placer.get_goal_placement() )
		simulation.main_bulle = info_panel.doublet.main_bulle.type
		simulation.second_bulle = info_panel.doublet.second_bulle.type
		
		ga_execution_time = OS.get_ticks_msec()
		thread.start( ga, "run", simulation.copy())
			
		if( show_simulation ):
			update_simulation_view()

#		ga_result = ga.run( simulation )
#		doublet_placer.set_goal_placement( ga_result )

func update_simulation_view():
	for x in range(global.GRID_SIZE.x):
		for y in range(global.GRID_SIZE.y):
			if( simulation.bulles[x+1][y+1] >= 0 ):
				bulles[x][y].set_texture( bulles_textures[simulation.bulles[x+1][y+1]] )
				bulles[x][y].show()
			else:
				bulles[x][y].hide()

func _exit_tree():
	thread.wait_to_finish()



func generate_random_placement():
	var main_bulle_pos_x = randi()%int(global.GRID_SIZE.x)
	var second_bulle_state = randi()%global.DIRECTIONS.COUNT
	while( 
		(main_bulle_pos_x == 0 && second_bulle_state == global.DIRECTIONS.LEFT) 
		|| (main_bulle_pos_x == global.GRID_SIZE.x && second_bulle_state == global.DIRECTIONS.RIGHT)
	):
		second_bulle_state = randi()%global.DIRECTIONS.COUNT
	
	return [main_bulle_pos_x, second_bulle_state]