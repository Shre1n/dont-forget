extends Control

signal ui_closed

@onready var closed_button: Button = $Panel/CloseButton
@onready var content_holder: Node = $Panel/Node

func _ready():
	closed_button.connect("pressed", Callable(self, "_on_close_button_pressed"))


func load_content(scene_path: String):
	var scene = load(scene_path).instantiate()
	set_content(scene)

func set_content(content:Control):
	for child in content_holder.get_children():
		child.queue_free()
	
	content_holder.add_child(content)
	print(content_holder.get_children())


func _on_close_button_pressed(): 
	emit_signal("ui_closed")
	queue_free()
