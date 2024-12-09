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
	var user_save = save_User.load_save()
	var current_scene = game_manager.get_child(0).get_child(0).scene_file_path
	var time_left = game_manager.life_time
	
	var gold = get_parent().get_child(0).find_child("Menge").text
	
	var character_position = game_manager.current_character.position
	
	user_save.scene_path = load(String(current_scene)) # Get the current scene's path
	user_save.life = time_left
	user_save.gold = gold
	user_save.position_of_character = character_position
	user_save.save()
	get_tree().quit()
