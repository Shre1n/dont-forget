extends Control

signal ui_closed

@onready var closed_button: Button = $CloseButton
@onready var content_panel: Panel = $Panel

func _ready():
	closed_button.connect("pressed", Callable(self, "_on_close_button_pressed"))


func load_content(scene_path: String):
	var scene = load(scene_path).instantiate()
	content_panel.add_child(scene)


func _on_close_button_pressed(): 
	emit_signal("ui_closed")
	queue_free()
	
