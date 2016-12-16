extends Node2D

var simulation = preload('res://game/AI/game_panel_simulation.gd').new()

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
	
	
	bulles = []
	bulles.resize(global.GRID_SIZE.x)
	for x in range(global.GRID_SIZE.x):
		bulles[x] = []
		bulles[x].resize(global.GRID_SIZE.y)
		for y in range(global.GRID_SIZE.y):
			bulles[x][y] = Sprite.new()
			add_child(bulles[x][y])
			bulles[x][y].set_pos( Vector2( global.BULLE_SIZE.x * x, global.BULLE_SIZE.y * y) + global.BULLE_SIZE/2 )
	
	
func _process(delta):
	if ( Input.is_action_just_pressed("escape") ):
		scene_manager.change_scene_to_previous()
		
	for x in range(global.GRID_SIZE.x):
		for y in range(global.GRID_SIZE.y):
			if( simulation.bulles[x+1][y+1] >= 0 ):
				bulles[x][y].set_texture( bulles_textures[simulation.bulles[x+1][y+1]] )
				bulles[x][y].show()
			else:
				bulles[x][y].hide()
				
	if( Input.is_action_just_pressed('speed_p1') ):
		simulation.generate_random_doublet()
		var solution = []
		for i in range(1):
			var tmp = generate_random_placement()
			solution.push_back(tmp[0])
			solution.push_back(tmp[1])
		var score = simulation.simulate_solution(solution)
		print(score)






func generate_random_placement():
	var main_bulle_pos_x = randi()%int(global.GRID_SIZE.x)
	var second_bulle_state = randi()%global.DIRECTIONS.COUNT
	while( 
		(main_bulle_pos_x == 0 && second_bulle_state == global.DIRECTIONS.LEFT) 
		|| (main_bulle_pos_x == global.GRID_SIZE.x && second_bulle_state == global.DIRECTIONS.RIGHT)
	):
		second_bulle_state = randi()%global.DIRECTIONS.COUNT
	
	return [main_bulle_pos_x, second_bulle_state]
