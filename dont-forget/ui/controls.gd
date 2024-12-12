extends Control

@export var game_manager : Game_Manager


func _on_close_btn_pressed():
	if (game_manager != null):
		game_manager.controls_closed()
		return
	hide()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
