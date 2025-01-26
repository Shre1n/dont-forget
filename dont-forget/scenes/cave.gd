extends Level

@onready var bg_audio_ := $AudioStreamPlayer
@export var visibile_notifier: VisibleOnScreenNotifier2D


func _init() -> void:
	print("fehjnuwrfhuwe")

func _ready() -> void:
	print("Vor audio")
	bg_audio_.play()
	print("HUAHSUHau")


func _on_visible_on_screen_notifier_2d_screen_entered_() -> void:
	self.visible = true
