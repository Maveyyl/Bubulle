extends SceneTree

var solo_game
var double_game_panel
var game_panel
var info_panel

var ready = false setget ,is_ready


func _init():
	get_root().set_as_render_target(true)
	get_root().set_render_target_update_mode(Viewport.RENDER_TARGET_UPDATE_DISABLED)
	get_root().set_rect(Rect2(0, 0, 0, 0))
	init()
	
	change_scene_to( scene_manager.SCENES.solo )

	
func is_ready():
	if( get_current_scene() && !ready ):
		# memorized simulated nodes
		solo_game = get_current_scene()
		double_game_panel = solo_game.get_node('double_game_panel')
		game_panel = double_game_panel.get_node('game_panel_p2')
		info_panel = double_game_panel.get_node('info_panel_p2')
		ready = true
		
	return ready

func run_until_new_doublet():
	if( double_game_panel.ended ):
		return

	var doublet = game_panel.doublet

	while( doublet == game_panel.doublet && !double_game_panel.ended):
		idle( 0.33333333 )