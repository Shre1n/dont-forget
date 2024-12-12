extends Control

@onready var closed_button: Button = $Panel/CloseButton
@onready var content_holder: Container = $Panel/Container

func _ready():
	closed_button.connect("pressed", Callable(self, "_on_close_button_pressed"))


func load_content(scene_path: String):
	var scene = load(scene_path).instantiate()
	content_holder.add_child(scene)
	
	self.show()

func _on_close_button_pressed(): 
	self.hide()
	for child in content_holder.get_children():
		child.queue_free()
