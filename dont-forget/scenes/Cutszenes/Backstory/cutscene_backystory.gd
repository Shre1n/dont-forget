extends Level

@onready var ani_player = $Bilder/AnimationPlayer
@export var dialog : DialogueResource
@export var dialog_resource : DialogueResource
var _position = Vector2(100,100)
@onready var dia = $DialogueLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"../../Pause_Menu/UI".hide()
	DialogueManager.show_example_dialogue_balloon(dialog, "start_BS")
	Global.cutscene = true
	Global.lastCutsceneNr = 1
	ani_player.play("backstory")
	#DialogueManager.show_example_dialogue_balloon(dialog_resource, "start")
	#get_tree().root.print_tree_pretty()

func _process(delta):
	if Input.is_action_just_pressed("inventar"):
		$"../../Pause_Menu/UI".show()
		var gameplay_node:Game_Manager = get_tree().get_nodes_in_group("game_manager")[0] as Game_Manager
		var unload:Node = gameplay_node.current_level
		SceneManager.swap_scenes("res://scenes/Village.tscn",gameplay_node.level_holder,unload,"wipe_to_right")

func simulate_button_pressed():
	var event = InputEventMouseButton.new()
	event.position = _position
	event.button_index = MOUSE_BUTTON_LEFT
	event.pressed = true
	Input.parse_input_event(event)

	# Zum Loslassen des Klicks sofort ein zweites Event senden
	var release_event = InputEventMouseButton.new()
	release_event.position = _position
	release_event.button_index = MOUSE_BUTTON_LEFT
	release_event.pressed = false
	Input.parse_input_event(release_event)
	
	#var touch_event = InputEventScreenTouch.new()
	#touch_event.position = _position
	#touch_event.button_index = MOUSE_BUTTON_LEFT
	#touch_event.pressed = true
	#Input.parse_input_event(touch_event)
#
	## Zum Loslassen des Klicks sofort ein zweites Event senden
	#var touch_release_event = InputEventScreenTouch.new()
	#touch_release_event.position = _position
	#touch_release_event.button_index = MOUSE_BUTTON_LEFT
	#touch_release_event.pressed = false
	#Input.parse_input_event(touch_release_event)
	
func _on_animated_sprite_2d_frame_changed() -> void:
	simulate_button_pressed()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "backstory":
		#self.queue_free()
		$"../../Pause_Menu/UI".show()
		var gameplay_node:Game_Manager = get_tree().get_nodes_in_group("game_manager")[0] as Game_Manager
		var unload:Node = gameplay_node.current_level
		SceneManager.swap_scenes("res://scenes/Village.tscn",gameplay_node.level_holder,unload,"wipe_to_right")


func _on_animation_player_animation_started(anim_name: StringName) -> void:
	if anim_name == "backstory":
		DialogueManager.show_example_dialogue_balloon(dialog, "start_BS")
