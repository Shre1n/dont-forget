class_name StartScreen extends Control

#@export var game_manager : Game_Manager

var options_open: bool = false

func _input(event : InputEvent):
	if(event.is_action_pressed("ui_cancel") and options_open):
		options_open = false
		get_node("Options").hide()

func _ready():
	pass

func _process(delta):
	pass


func _on_start_button_pressed():
	SceneManager.swap_scenes("res://game.tscn",get_tree().root,self,"wipe_to_right")


func _on_load_button_pressed():
	pass # Replace with function body.


func _on_options_button_pressed():
	options_open = true
	get_node("Options").show()


func _on_credits_button_pressed():
	pass # Replace with function body.


func _on_quit_button_pressed():
	get_tree().quit()
