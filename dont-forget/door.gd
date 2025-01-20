class_name Door extends Area2D

signal player_entered_door(door:Door,transition_type:String)

@export_enum("fade_to_black","fade_to_white","wipe_to_right","no_transition", "fall_to_well") var transition_type:String ## transitoin we want to use when moving through the door
@export var path_to_new_scene:String	## scene we want to load when touchign this door
@export var new_position: Vector2
@export var new_direction: float
@export var menu: bool = false
@export var newRound: bool = false
#@export var pathToVillage: bool = false
#@export_enum("left", "right") var new_direction_word:string #auslesen und dann zu zahlen 1, 0, -1 umwandeln, 1 und -1 noch testen ob richtige richtung
@export_enum("left", "right") var new_direction_word: String

func _init() -> void:
	print("a")

func evaluate_direction():
	match new_direction_word:
		"left":
			new_direction = -1
		"right":
			new_direction = 1
		#_:
			#new_direction = 0  

func _on_body_entered(body: Node2D) -> void:
	if not body is Character:
		return
	var game_manager = find_game_manager()
	if menu:
		SceneManager.swap_scenes("res://ui/menu.tscn",get_tree().root,game_manager,"transition_type")
	else:
		if newRound:
			game_manager.restart_life_timer()
		player_entered_door.emit(self)
		Global.new_position = new_position
		evaluate_direction()
		Global.new_direction = new_direction
		#Global.coins = body.coins
	
		var gameplay_node:Game_Manager = get_tree().get_nodes_in_group("game_manager")[0] as Game_Manager
		var unload:Node = gameplay_node.current_level	# we're now responsible for tracking this 
	
		SceneManager.swap_scenes(path_to_new_scene,gameplay_node.level_holder,unload,transition_type)
		queue_free()

func find_game_manager():
	var root = get_tree().root  # Root-Node des Scene Trees
	for child in root.get_children():
		if child.name == "Game_Manager":
			return child
	return null
