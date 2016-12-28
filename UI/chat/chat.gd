extends Control

onready var text_edit_nickname = get_node("panel/text_edit_nickname")
onready var text_input = get_node("panel/text_input")
onready var chat_display = get_node("panel/chat_display")

signal chat_focus_enter
signal chat_focus_exit

var chat_focused = false

var messages = []

var random_nicks = [
	"Dude",
	"Bro",
	"Pal",
	"Friend",
	"Buddy",
	"Mate"
]

func _ready():
	if( text_edit_nickname.get_text() == ""):
		seed(OS.get_ticks_msec())
		var r = randi()%random_nicks.size()
		text_edit_nickname.set_text( random_nicks[r] )
	
	chat_display.set_scroll_follow(true)
	
func _process(delta):
	if ( Input.is_action_just_pressed("enter") ):
		if( network_manager.is_active ):
			var message = text_input.get_text()
			var nickname = text_edit_nickname.get_text()
			rpc("chat_message", {
				"message": message,
				"nickname": nickname
			})
		
		text_input.set_text("")
		release_focus()
		text_input.release_focus()
		text_edit_nickname.release_focus()

func add_chat_message( d, own ):
	
	var chat_message = "[b][u]" +d.nickname + ":[/u] " + d.message + "[/b]"
	if( own ):
		chat_message = "[color=navy]" + chat_message + "[/color]"
	else:
		chat_message = "[color=red]" + chat_message + "[/color]"
		
	chat_display.append_bbcode(chat_message)

remote func chat_message( d ):
	add_chat_message( d, false )
	rpc("chat_message_ack", d)
remote func chat_message_ack( d ):
	add_chat_message( d, true )
	

func _on_text_input_focus_enter():
	emit_signal("chat_focus_enter")
	chat_focused = true
	set_process(true)


func _on_text_input_focus_exit():
	emit_signal("chat_focus_exit")
	chat_focused = false
	set_process(false)


func _on_text_edit_nickname_focus_enter():
	emit_signal("chat_focus_enter")
	chat_focused = true
	set_process(false)

func _on_text_edit_nickname_focus_exit():
	emit_signal("chat_focus_exit")
	chat_focused = false
	set_process(false)