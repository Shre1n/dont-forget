extends Control

@export var game_manager : Game_Manager
@onready var close_btn: Button = $Control/Panel/Close_btn


func _on_close_btn_pressed():
	hide()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	close_btn.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
