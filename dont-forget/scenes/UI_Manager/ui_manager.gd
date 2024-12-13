extends Control

signal give_user

@onready var closed_button: Button = $Panel/CloseButton
@onready var content_holder: Container = $Panel/Container


func _ready():
	#closed_button.connect("pressed", Callable(self, "_on_close_button_pressed"))
	self.hide()

func load_content(scene_path: String):
	var scene = load(scene_path).instantiate()
	content_holder.add_child(scene)
	emit_signal("give_user")
	self.show()

func _on_close_button_pressed(): 
	if content_holder.get_child(0).has_method("close_npc"):
		content_holder.get_child(0).close_npc()
	close()

func close():
	self.hide()
	for child in content_holder.get_children():
		child.queue_free()
