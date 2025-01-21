extends Level


@export var ani: AnimationPlayer
@export var charakter: Character

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"../../Pause_Menu/UI".hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "ani":
		var gameplay_node:Game_Manager = get_tree().get_nodes_in_group("game_manager")[0] as Game_Manager
		var unload:Node = gameplay_node.current_level
		SceneManager.swap_scenes("res://cutscenes/cave/cutscene_gerettet.tscn",gameplay_node.level_holder,unload,"wipe_to_right")
