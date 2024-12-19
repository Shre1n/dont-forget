extends Control

signal give_user

@onready var closed_button: Button = $Panel/CloseButton
@onready var content_holder: Container = $Panel/Container

var is_shop_open : bool = false

func _ready():
	#closed_button.connect("pressed", Callable(self, "_on_close_button_pressed"))
	hide()

func load_content(scene_path: String, profile: String = ""):
	var scene = load(scene_path).instantiate()
	if profile.length():
		scene.selected_profile = profile
	content_holder.add_child(scene)
	emit_signal("give_user")
	show()
	
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		_on_close_button_pressed()

func _on_close_button_pressed(): 
	extra_close()
	close()

func close():
	hide()
	for child in content_holder.get_children():
		child.queue_free()

func extra_close():
	if content_holder.get_child(0).has_method("close_npc"):
		content_holder.get_child(0).close_npc()


func _on_visibility_changed() -> void:
	pass
