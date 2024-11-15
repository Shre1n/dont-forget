class_name Door extends Area2D

signal player_entered_door(door:Door,transition_type:String)

@export_enum("fade_to_black","fade_to_white","wipe_to_right","no_transition") var transition_type:String ## transitoin we want to use when moving through the door
@export var path_to_new_scene:String	## scene we want to load when touchign this door
@export var new_position: Vector2
@export var new_direction: float
@export var menu: bool = false
#@export_enum("left", "right") var new_direction_word:string #auslesen und dann zu zahlen 1, 0, -1 umwandeln, 1 und -1 noch testen ob richtige richtung
@export_enum("left", "right") var new_direction_word: String

func evaluate_direction():
	match new_direction_word:
		"left":
			new_direction = -1
		"right":
			new_direction = 1
		#_:
			#new_direction = 0  

func _on_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	if menu:
		SceneManager.swap_scenes("res://ui/menu.tscn",get_tree().root,self,"transition_type")
	else:
		player_entered_door.emit(self)
		Global.new_position = new_position
		evaluate_direction()
		Global.new_direction = new_direction
	
		var gameplay_node:Game_Manager = get_tree().get_nodes_in_group("game_manager")[0] as Game_Manager
		var unload:Node = gameplay_node.current_level	# we're now responsible for tracking this 
	
		SceneManager.swap_scenes(path_to_new_scene,gameplay_node.level_holder,unload,transition_type)
		queue_free()

		
