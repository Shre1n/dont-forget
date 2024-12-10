class_name Pause_Menu extends Control

@export var game_manager : Game_Manager
var current_player

func _ready() -> void:
	hide()
	game_manager.connect("toggle_game_paused", _on_game_manager_toggle_game_paused)
	game_manager.connect("current_user", Callable(self, "save_user_location"))

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

	var gold = current_player.coins
	
	var character_position = game_manager.current_character.position
	
	user_save.scene_path = load(String(current_scene)) # Get the current scene's path
	user_save.life = time_left
	user_save.gold = gold
	user_save.position_of_character = character_position
	user_save.stats = game_manager.get_all_stats()
	print(game_manager.get_all_stats())
	
	var root_children = get_tree().root.get_children()
	for child in root_children:
		if child.name == "Bag":
			user_save.bag_scene = preload("res://assets/drops/bag_drop/bag.tscn")  # Assign it to the save resource
			user_save.bag_position = child.position
			print("Bag instance saved in user save.")
			break
	user_save.save()
	get_tree().quit()

func save_user_location(path):
	current_player = path
