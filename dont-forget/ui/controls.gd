extends Control

@export var game_manager : Game_Manager

@onready var panel: Panel = $Control/Panel
@onready var panel_set_controls: Panel = $Control/Panel_Set_Controls

@onready var audio = $Audio_Stream

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_set_controls_pressed() -> void:
	audio.button_audio()
	panel.hide()
	panel_set_controls.show()
	



func _on_close_btn_pressed() -> void:
	audio.button_audio()
	hide()
	


func _on_margin_container_visibility_changed() -> void:
	pass
