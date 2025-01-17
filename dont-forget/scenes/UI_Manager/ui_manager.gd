extends Control

signal give_user

@onready var closed_button: Button = $Panel/CloseButton
@onready var content_holder: Container = $Panel/Container
@onready var audio = $Audio_Stream

var is_shop_open : bool = false

func _ready():
	#closed_button.connect("pressed", Callable(self, "_on_close_button_pressed"))
	hide()

func load_content(scene_path: String, profile: String = ""):
	audio.Cutscene_book_audio()
	var scene = load(scene_path).instantiate()
	if profile.length():
		scene.selected_profile = profile
	content_holder.add_child(scene)
	emit_signal("give_user")
	show()

func _on_close_button_pressed(): 
	audio.Cutscene_book_audio()
	extra_close()
	close()

func close():
	audio.Cutscene_book_audio()
	hide()
	for child in content_holder.get_children():
		child.queue_free()

func extra_close():
	audio.Cutscene_book_audio()
	if content_holder.get_child(0).has_method("close_npc"):
		content_holder.get_child(0).close_npc()


func _on_visibility_changed() -> void:
	pass
