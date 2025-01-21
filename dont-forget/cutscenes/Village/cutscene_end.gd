extends Level

@export var anim_player: AnimationPlayer
@export var camera_player: AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim_player.play("anim")
	camera_player.play("zoom")
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "anim":
		var game_manager = find_game_manager()
		SceneManager.swap_scenes("res://ui/menu.tscn",get_tree().root,game_manager,"fade_to_black")

func find_game_manager():
	var root = get_tree().root  # Root-Node des Scene Trees
	for child in root.get_children():
		if child.name == "Game_Manager":
			return child
	return null
