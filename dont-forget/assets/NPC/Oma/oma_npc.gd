extends Node2D


@onready var interaction_area = $InteractionArea
@onready var animation_player = $AnimationPlayer
@export var dialog_resource: DialogueResource
@export_category("Einstellungen für Cutscene verwendung")
@export var throwbackdream: bool = false
@export_enum("fade_to_black","fade_to_white","wipe_to_right","no_transition", "fall_to_well") var transition_type:String
@export var path_to_new_scene:String
@export var player: Character

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interaction_area.interact = Callable(self, "on_talk")
	animation_player.play("idle")


func on_talk():
	if throwbackdream:
		Global.new_position = player.position
		var gameplay_node:Game_Manager = get_tree().get_nodes_in_group("game_manager")[0] as Game_Manager
		var unload:Node = gameplay_node.current_level
		SceneManager.swap_scenes(path_to_new_scene,gameplay_node.level_holder,unload,transition_type)
		DialogueManager.show_example_dialogue_balloon(dialog_resource, "start_BS")
	else:
		animation_player.play("talk")
		DialogueManager.show_example_dialogue_balloon(dialog_resource, "start")
		get_tree().root.print_tree_pretty()
