class_name Pause_Menu extends Control

@export var game_manager : Game_Manager

func _ready() -> void:
	hide()
	game_manager.connect("toggle_game_paused", _on_game_manager_toggle_game_paused)

func _on_game_manager_toggle_game_paused(is_paused : bool):
	if(is_paused):
		show()
	else:
		hide()

func _process(delta):
	pass


func _on_resume_pressed():
	game_manager.game_paused = false

func _on_options_pressed():
	game_manager.options_opend()


func _on_quit_pressed():
	get_tree().quit()
