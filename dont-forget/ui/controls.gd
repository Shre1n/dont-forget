extends Control

@export var game_manager : Game_Manager

@onready var container: MarginContainer = %MarginContainer
@onready var panel: Panel = $Control/Panel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_set_controls_pressed() -> void:
	panel.hide()
	container.show()
	
	


func _on_close_btn_pressed() -> void:
	hide()
	


func _on_margin_container_visibility_changed() -> void:
	pass


func _on_visibility_changed() -> void:
	if visible:
		container.show()
	else:
		container.hide()
