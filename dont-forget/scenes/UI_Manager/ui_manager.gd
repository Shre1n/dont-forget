extends Control

signal give_user

@onready var closed_button: Button = $Panel/CloseButton
@onready var content_holder: Container = $Panel/Container

var is_shop_open : bool = false

func _ready():
	#closed_button.connect("pressed", Callable(self, "_on_close_button_pressed"))
	self.hide()

func load_content(scene_path: String, profile: String):
	var scene = load(scene_path).instantiate()
	scene.selected_profile = profile
	content_holder.add_child(scene)
	emit_signal("give_user")
	self.show()

func _on_close_button_pressed(): 
	extra_close()
	close()

func close():
	self.hide()
	for child in content_holder.get_children():
		child.queue_free()

func extra_close():
	if content_holder.get_child(0).has_method("close_npc"):
		content_holder.get_child(0).close_npc()
