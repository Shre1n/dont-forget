extends Level

@onready var bg_audio_ := $AudioStreamPlayer
@export var visibile_notifier: VisibleOnScreenNotifier2D


func _ready() -> void:
	bg_audio_.play()


func _on_visible_on_screen_notifier_2d_screen_entered_() -> void:
	self.visible = true

func _on_visible_on_screen_notifier_2d_screen_exited_() -> void:
	self.hide()
