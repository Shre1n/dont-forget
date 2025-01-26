extends Level

@export var ani_player : AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#ani_player.play("happy")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("inventar"):
		var gameplay_node:Game_Manager = get_tree().get_nodes_in_group("game_manager")[0] as Game_Manager
		var unload:Node = gameplay_node.current_level
		SceneManager.swap_scenes("res://cutscenes/Village/cutscene_end.tscn",gameplay_node.level_holder,unload,"wipe_to_right")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "happy":
		var gameplay_node:Game_Manager = get_tree().get_nodes_in_group("game_manager")[0] as Game_Manager
		var unload:Node = gameplay_node.current_level
		SceneManager.swap_scenes("res://cutscenes/Village/cutscene_end.tscn",gameplay_node.level_holder,unload,"wipe_to_right")
